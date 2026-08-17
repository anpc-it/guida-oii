#let target = sys.inputs.at("x-target", default: "pdf")
#let is-pdf = target.starts-with("pdf")

// Everything that isn't PDF is rendered through Shiroa (which uses "web",
// "html-wrapper" and other non-pdf targets depending on build mode).
#let is-web = not is-pdf

// Dynamic web/Shiroa content phase (e.g. "web-light"). CeTZ and other vector
// graphics render here via the browser WASM renderer.
#let is-web-content = target.starts-with("web")

// Native Typst HTML export (static-html mode). Layout-heavy features such as
// CeTZ canvas are unsupported here.
#let is-native-html = target == "html"
