#import "@preview/shiroa:0.4.0": (
  get-page-width, is-html-target, is-pdf-target, is-web-target, plain-text, shiroa-sys-target, templates,
)
#import templates: *

#let web-theme = if is-html-target(exclude-wrapper: true) { "starlight" } else { "mdbook" }
#let is-starlight-theme = web-theme == "starlight"

#let is-html-target = is-html-target()
#let is-pdf-target = is-pdf-target()
#let is-web-target = is-web-target()
#let sys-is-html-target = ("html" in dictionary(std))

#let web-page-width = 975pt
#let page-width = if is-web-target { web-page-width } else { get-page-width() }

#let themes = theme-box-styles-from(toml("theme-style.toml"), read: it => read(it))
#let (
  default-theme: (
    style: theme-style,
    is-dark: is-dark-theme,
    is-light: is-light-theme,
    main-color: main-color,
    dash-color: dash-color,
    code-extra-colors: code-extra-colors,
  ),
) = themes;
#let (
  default-theme: default-theme,
) = themes;
#let theme-box = theme-box.with(themes: themes)

#let main-font = ("Crimson Text", "Libertinus Serif")
#let code-font = "DejaVu Sans Mono"

#let web-scale = 1.3
#let main-size = if is-web-target { 18pt * web-scale } else { 10.5pt }
#let heading-sizes = if is-web-target {
  (2, 1.5, 1.17, 1, 0.83).map(it => it * main-size)
} else {
  (26pt, 22pt, 14pt, 12pt, main-size)
}
#let list-indent = 0.5em

// Temporary fix, all themes look weird and broken. Also search doesn't work.
// TODO: (low priority) in the future fix this
#let extra-css = raw(read("./styles.css"), lang: "css")

// force light theme
#let extra-js = ```js
try { localStorage.setItem("shiroa-theme", "light"); } catch (e) {}
```

#let project(title: "Typst Book", description: auto, authors: (), kind: "page", plain-body) = {
  set document(author: authors, title: title) if not is-pdf-target

  set page(numbering: none, number-align: center, width: page-width) if not (sys-is-html-target or is-html-target)

  set page(
    margin: (top: 20pt, left: 20pt, bottom: 0.5em, rest: 0pt),
    height: auto,
  ) if is-web-target and not is-html-target

  let common = (web-theme: web-theme)

  let template-args = arguments(
    include "/book.typ",
    title: title,
    description: description,
    plain-body: plain-body,
    extra-assets: (extra-css, extra-js),
  )

  show: if web-theme == "starlight" {
    import "@preview/shiroa-starlight:0.4.0": starlight
    starlight.with(..template-args)
  } else if web-theme == "mdbook" {
    import "@preview/shiroa-mdbook:0.4.0": mdbook
    mdbook.with(..template-args)
  } else {
    panic("Unknown web theme: " + web-theme)
  }

  set text(
    font: main-font,
    size: main-size,
    fill: main-color,
    lang: "en",
    weight: "regular",
  )


  show math.equation: set text(font: "STIX Two Math") // generic thick math font

  show: markup-rules.with(..common, themes: themes, heading-sizes: heading-sizes, list-indent: list-indent, main-size: main-size)
  show heading: set text(font: "EB Garamond")
  show heading: it => if is-web-target {
      set text(size: heading-sizes.at(it.level), weight: "bold")
      block(
        spacing: 0.7em * 1.5 * 1.2,
        below: 0.7em * 1.2,
        it,
      )
    } else {
      it
    }
  show: equation-rules.with(..common, theme-box: theme-box)
  show: code-block-rules.with(..common, themes: themes, code-font: code-font)

  show raw.where(block: false): it => box(
    fill: luma(94%),
    inset: (x: 0.25em, y: 0.05em),
    outset: (y: 0.12em),
    radius: 0.15em,
    it,
  )

  set par(justify: true)

  plain-body
}

#let part-style = heading
