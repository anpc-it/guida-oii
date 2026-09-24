#!/usr/bin/env node
// 1. Builds the dynamic Shiroa site into the source dir (skip with --no-build).
// 2. Serves the source dir over local HTTP.
// 3. Renders every HTML page in headless Chromium so the wasm produces the final DOM.
// 4. Snapshots each page and sanitizes it
// 5. Copies non-HTML assets, excluding .sir.in and .wasm.
// 6. brotli and gzip compresses text assets.
// 7. Writes the static site to the output dir and reports per-page sizes.

import { createServer } from "node:http";
import { spawnSync } from "node:child_process";
import { createRequire } from "node:module";
import {
  cpSync,
  existsSync,
  mkdirSync,
  readFileSync,
  readdirSync,
  statSync,
  writeFileSync,
} from "node:fs";
import { dirname, extname, isAbsolute, join, relative, resolve } from "node:path";
import { brotliCompressSync, constants as zlibConstants, gzipSync } from "node:zlib";

const require = createRequire(import.meta.url);

const args = process.argv.slice(2);
const flag = (name, def) => {
  const i = args.indexOf("--" + name);
  if (i === -1) return def;
  const next = args[i + 1];
  return !next || next.startsWith("--") ? true : next;
};

const SRC = resolve(flag("src", "dist"));
const OUT = resolve(flag("out", "dist-static"));
const PORT = Number(flag("port", 8137));
const CONCURRENCY = Number(flag("concurrency", 4));
const LIMIT = Number(flag("limit", 0));
const RETRIES = Number(flag("retries", 2));
const FONT_PATH = flag("font-path", null);
const DO_BUILD = !args.includes("--no-build");
const DO_COMPRESS = !args.includes("--no-compress");
const ALLOW_SKIPS = args.includes("--allow-skips");
const EXTS_TEXT = new Set([".html", ".css", ".js", ".json"]);

const started = Date.now();
const displayPath = (p) => (p.startsWith(process.cwd()) ? relative(process.cwd(), p) : p);
const log = (...parts) => {
  const t = ((Date.now() - started) / 1000).toFixed(1).padStart(6);
  console.log(`[${t}s] ${parts.join(" ")}`);
};

let playwright;
try {
  playwright = require("playwright");
} catch {
  console.error("Missing 'playwright'. Run: npm i playwright && npx playwright install chromium");
  process.exit(1);
}
const { chromium } = playwright;

const MIME = {
  ".html": "text/html; charset=utf-8",
  ".css": "text/css; charset=utf-8",
  ".js": "text/javascript; charset=utf-8",
  ".json": "application/json; charset=utf-8",
  ".wasm": "application/wasm",
  ".svg": "image/svg+xml",
  ".png": "image/png",
  ".in": "application/octet-stream",
};

function walk(dir, pred, base = dir, out = []) {
  for (const name of readdirSync(dir)) {
    const full = join(dir, name);
    if (statSync(full).isDirectory()) walk(full, pred, base, out);
    else if (pred(full)) out.push(relative(base, full));
  }
  return out;
}

function serve(root, port) {
  const server = createServer((req, res) => {
    let p = decodeURIComponent((req.url || "/").split("?")[0]);
    if (p.endsWith("/")) p += "index.html";
    const file = join(root, p);
    const rel = relative(root, file);
    if (isAbsolute(rel) || rel.startsWith("..")) {
      res.writeHead(403).end();
      return;
    }
    try {
      const body = readFileSync(file);
      res.writeHead(200, { "content-type": MIME[extname(file)] || "application/octet-stream" });
      res.end(body);
    } catch {
      res.writeHead(404).end("not found");
    }
  });
  return new Promise((ok) => server.listen(port, "127.0.0.1", () => ok(server)));
}

function stripRenderScripts(html) {
  return html.replace(/<script\b([^>]*)>([\s\S]*?)<\/script>/g, (full, attrs, body) => {
    const src = (attrs.match(/\bsrc="([^"]*)"/) || [])[1] || "";
    let code = body;
    let dataUrl = false;
    if (src.startsWith("data:application/javascript;base64,")) {
      dataUrl = true;
      try {
        code = Buffer.from(src.split(",")[1], "base64").toString("utf8");
      } catch {
        code = "";
      }
    }
    const drop =
      src.includes("/internal/shiroa.js") ||
      code.includes("typst_ts_renderer") ||
      code.includes("rendererWasmModule") ||
      code.includes("typstRenderModuleReady") ||
      code.includes("typstBookRenderPage") ||
      code.includes("(function themes()");
    if (drop) return "";
    return dataUrl ? `<script>${code}</script>` : full;
  });
}

function decodeDataCss(html) {
  return html.replace(/<link\b[^>]*href="data:text\/css;base64,([^"]*)"[^>]*>/g, (_m, b64) => {
    try {
      return `<style>${Buffer.from(b64, "base64").toString("utf8")}</style>`;
    } catch {
      return "";
    }
  });
}

function usedClasses(html) {
  const css = [...html.matchAll(/<style\b[^>]*>([\s\S]*?)<\/style>/g)].map((m) => m[1]).join("\n");
  const set = new Set([...css.matchAll(/\.([a-zA-Z_][\w-]*)/g)].map((m) => m[1]));
  for (const c of [
    "js", "no-js", "light", "rust", "coal", "navy", "ayu", "active", "hidden",
    "expanded", "open", "sidebar-visible", "sidebar-hidden", "sidebar-resizing",
    "theme-selected", "focus", "hover",
  ]) set.add(c);
  return set;
}

function filterClasses(html, allowed) {
  return outsideStyleScript(html, (seg) =>
    seg.replace(/ class="([^"]*)"/g, (_m, value) => {
      const kept = value.split(/\s+/).filter((t) => t && allowed.has(t));
      return kept.length ? ` class="${kept.join(" ")}"` : "";
    }),
  );
}

function outsideStyleScript(html, fn) {
  return html
    .split(/(<style\b[\s\S]*?<\/style>|<script\b[\s\S]*?<\/script>)/)
    .map((seg) => (/^<(style|script)\b/.test(seg) ? seg : fn(seg)))
    .join("");
}

const GEOMETRY_ATTRS = /(\s)(d|points)="([^"]*)"/g;

function trimNumber(value) {
  return value
    .replace(/(\.\d{3})\d+/g, "$1")
    .replace(/(\d+)\.0+(?=\D|$)/g, "$1");
}

function roundNumbers(html) {
  return outsideStyleScript(html, (seg) =>
    seg.replace(GEOMETRY_ATTRS, (_m, sp, attr, value) => `${sp}${attr}="${trimNumber(value)}"`),
  );
}

function stripDebugAttrs(html) {
  return html.replace(/ data-tid="[^"]*"/g, "").replace(/ data-hint="[^"]*"/g, "");
}

function scriptAllowlist(dir, rel) {
  let html;
  try {
    html = readFileSync(join(dir, rel), "utf8");
  } catch {
    return null;
  }
  const allowed = new Set();
  for (const m of html.matchAll(/<script\b([^>]*)>([\s\S]*?)<\/script>/g)) {
    const src = (m[1].match(/\bsrc="([^"]*)"/) || [])[1] || "";
    if (src.startsWith("data:application/javascript;base64,")) {
      try {
        allowed.add(Buffer.from(src.split(",")[1], "base64").toString("utf8"));
      } catch {}
    } else if (src) {
      allowed.add("src:" + src);
    } else {
      allowed.add(m[2]);
    }
  }
  return allowed;
}

function sanitizeScripts(html, allowed) {
  if (!allowed) return html;
  return html.replace(/<script\b([^>]*)>([\s\S]*?)<\/script>/g, (full, attrs, body) => {
    const src = (attrs.match(/\bsrc="([^"]*)"/) || [])[1] || "";
    if (src) return allowed.has("src:" + src) ? full : "";
    return allowed.has(body) ? full : "";
  });
}

function sanitizeHandlers(html) {
  const safeHandler = /^\s*handleTypstLocation\(this,\s*-?\d+(?:\.\d+)?,\s*-?\d+(?:\.\d+)?,\s*-?\d+(?:\.\d+)?\);\s*return false;?\s*$/;
  return outsideStyleScript(html, (seg) =>
    seg.replace(/\son[a-z]+\s*=\s*"([^"]*)"/gi, (m, value) => (safeHandler.test(value) ? m : "")),
  );
}

function sanitizeHrefs(html) {
  return outsideStyleScript(html, (seg) =>
    seg.replace(/\shref="([^"]*)"/gi, (m, value) => {
      const v = value.trim().toLowerCase();
      const safe =
        v === "" ||
        v.startsWith("#") ||
        v.startsWith("http://") ||
        v.startsWith("https://") ||
        v.startsWith("mailto:") ||
        v.startsWith("tel:") ||
        !v.includes(":");
      return safe ? m : "";
    }),
  );
}

function removeEditButtons(html) {
  return html.replace(/<a\b[^>]*(?:title|aria-label)="Suggest an edit"[^>]*>[\s\S]*?<\/a>/g, "");
}

function addCsp(html) {
  if (html.includes('http-equiv="Content-Security-Policy"')) return html;
  const csp =
    "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'; " +
    "img-src 'self' data:; font-src 'self' data:; connect-src 'self'; object-src 'none'; base-uri 'self'";
  return html.replace(/<head\b[^>]*>/i, (m) => `${m}\n<meta http-equiv="Content-Security-Policy" content="${csp}">`);
}

function freezeHtml(html, scriptAllowed) {
  html = stripRenderScripts(html);
  html = sanitizeScripts(html, scriptAllowed);
  html = stripDebugAttrs(html);
  html = decodeDataCss(html);
  html = filterClasses(html, usedClasses(html));
  html = roundNumbers(html);
  html = sanitizeHandlers(html);
  html = sanitizeHrefs(html);
  html = removeEditButtons(html);
  html = addCsp(html);
  return html;
}

function precompress(dir) {
  const files = walk(dir, (f) => EXTS_TEXT.has(extname(f)));
  let rawTotal = 0;
  let brTotal = 0;
  let gzTotal = 0;
  for (const rel of files) {
    const full = join(dir, rel);
    const buf = readFileSync(full);
    const br = brotliCompressSync(buf, { params: { [zlibConstants.BROTLI_PARAM_QUALITY]: 11 } });
    const gz = gzipSync(buf, { level: 9 });
    writeFileSync(full + ".br", br);
    writeFileSync(full + ".gz", gz);
    rawTotal += buf.length;
    brTotal += br.length;
    gzTotal += gz.length;
  }
  return { files: files.length, rawTotal, brTotal, gzTotal };
}

async function ensureAllPagesRendered(page) {
  await page
    .waitForFunction(
      () => {
        const app = document.querySelector(".typst-app");
        if (!app) return false;
        const h = app.scrollHeight;
        if (window.__fh !== h) {
          window.__fh = h;
          window.__fht = Date.now();
          return false;
        }
        return Date.now() - window.__fht > 300;
      },
      { timeout: 30000, polling: 100 },
    )
    .catch(() => {});
  const needed = await page.evaluate(
    () => Math.ceil(document.querySelector(".typst-app")?.scrollHeight || 0) + 200,
  );
  const vp = page.viewportSize();
  if (needed > vp.height) {
    await page.setViewportSize({ width: vp.width, height: Math.min(needed, 30000) });
    await page.evaluate(async () => {
      const h = document.body.scrollHeight;
      for (let y = 0; y <= h; y += 800) {
        window.scrollTo(0, y);
        await new Promise((r) => setTimeout(r, 120));
      }
      window.scrollTo(0, 0);
    });
  }
  await page
    .waitForFunction(
      () => {
        const app = document.querySelector(".typst-app");
        if (!app) return false;
        const svgs = [...app.querySelectorAll(".typst-svg-page")];
        if (svgs.length === 0) return false;
        const key = svgs.map((s) => s.innerHTML.length).join(",");
        if (window.__freezeKey !== key) {
          window.__freezeKey = key;
          window.__freezeAt = Date.now();
          return false;
        }
        return Date.now() - window.__freezeAt > 800;
      },
      { timeout: 60000, polling: 150 },
    )
    .catch(() => {});
}

async function renderOne(context, rel, workerId) {
  const url = `http://127.0.0.1:${PORT}/${rel.split("/").map(encodeURIComponent).join("/")}`;
  const scriptAllowed = scriptAllowlist(SRC, rel);
  for (let attempt = 1; attempt <= RETRIES + 1; attempt++) {
    const page = await context.newPage();
    const t0 = Date.now();
    try {
      await page.route("**/*", (route) => {
        const u = route.request().url();
        if (u.startsWith(`http://127.0.0.1:${PORT}/`) || u.startsWith("data:") || u.startsWith("blob:")) {
          route.continue();
        } else {
          route.abort();
        }
      });
      log(`worker ${workerId} render ${rel}${attempt > 1 ? ` (attempt ${attempt})` : ""}`);
      await page.goto(url, { waitUntil: "domcontentloaded", timeout: 90000 });
      await page.waitForSelector(".typst-app .typst-svg-page", { state: "attached", timeout: 90000 });
      await ensureAllPagesRendered(page);
      const rendered = await page.content();
      const frozen = freezeHtml(rendered, scriptAllowed);
      const target = join(OUT, rel);
      mkdirSync(dirname(target), { recursive: true });
      writeFileSync(target, frozen);
      log(
        `worker ${workerId} done   ${rel} in ${Date.now() - t0}ms ` +
          `(rendered ${(rendered.length / 1024).toFixed(0)}KB -> frozen ${(frozen.length / 1024).toFixed(0)}KB)`,
      );
      return { rel, raw: Buffer.byteLength(rendered), frozen: Buffer.byteLength(frozen) };
    } catch (e) {
      if (attempt > RETRIES) {
        log(`worker ${workerId} SKIP   ${rel} (${e.message})`);
        return { rel, skipped: true };
      }
      log(`worker ${workerId} retry  ${rel} (${e.message})`);
      await page.waitForTimeout(1000);
    } finally {
      await page.close();
    }
  }
}

async function main() {
  if (DO_BUILD) {
    const buildArgs = ["build", "-d", SRC];
    if (FONT_PATH) buildArgs.push("--font-path", FONT_PATH);
    log("build: shiroa", buildArgs.join(" "));
    const r = spawnSync("shiroa", buildArgs, { stdio: "inherit" });
    if (r.status !== 0) process.exit(r.status ?? 1);
  }
  if (!existsSync(SRC)) {
    console.error(`source directory not found: ${displayPath(SRC)} (run a build or fix --src)`);
    process.exit(1);
  }

  log("server: serving", displayPath(SRC), "on port", PORT);
  const server = await serve(SRC, PORT);

  const launchArgs = [];
  if (args.includes("--no-sandbox")) launchArgs.push("--no-sandbox");
  if (process.env.CI) launchArgs.push("--disable-dev-shm-usage");
  log("browser: launching chromium");
  const browser = await chromium.launch({ args: launchArgs });
  const context = await browser.newContext({ viewport: { width: 1280, height: 900 } });

  let pages = walk(SRC, (f) => extname(f) === ".html").sort();
  const only = flag("only", null);
  if (only) pages = pages.filter((p) => p.includes(only));
  if (LIMIT > 0) pages = pages.slice(0, LIMIT);
  log(`freeze: ${pages.length} pages, concurrency ${CONCURRENCY}, retries ${RETRIES}`);

  const results = [];
  let cursor = 0;
  const worker = async (id) => {
    while (true) {
      const my = cursor++;
      if (my >= pages.length) break;
      results.push(await renderOne(context, pages[my], id));
    }
  };
  await Promise.all(Array.from({ length: Math.min(CONCURRENCY, pages.length) }, (_, i) => worker(i + 1)));

  await browser.close();
  server.close();
  log("browser: closed");

  log("assets: copying non-html files to", displayPath(OUT));
  cpSync(SRC, OUT, {
    recursive: true,
    force: true,
    filter: (src) => {
      const e = extname(src);
      return !src.endsWith(".sir.in") && e !== ".wasm" && e !== ".html";
    },
  });

  let compressed = null;
  if (DO_COMPRESS) {
    log("compress: brotli/gzip text assets");
    compressed = precompress(OUT);
  }

  console.log("\npage                           rendered      frozen"); //sus
  const skipped = results.filter((r) => r.skipped);
  for (const r of results.sort((a, b) => a.rel.localeCompare(b.rel))) {
    if (r.skipped) console.log(`${r.rel.padEnd(30)} (skipped)`);
    else console.log(`${r.rel.padEnd(30)} ${String(r.raw).padStart(9)} ${String(r.frozen).padStart(11)}`);
  }
  if (compressed) {
    const kb = (n) => (n / 1024).toFixed(0) + " KB";
    console.log(
      `\n${compressed.files} text files: raw ${kb(compressed.rawTotal)} -> brotli ${kb(compressed.brTotal)} / gzip ${kb(compressed.gzTotal)}`,
    );
  }
  log(`done: ${results.length - skipped.length}/${results.length} pages -> ${displayPath(OUT)}/`);

  if (skipped.length > 0 && !ALLOW_SKIPS) {
    console.error(`\n${skipped.length} page(s) failed to render. Re-run or pass --allow-skips to ignore.`);
    process.exitCode = 1;
  }
}

main().catch((e) => {
  console.error("fatal:", e);
  process.exit(1);
});
