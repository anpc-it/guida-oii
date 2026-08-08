#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *

#let config(doc) = {
  set text(lang: "it", region: "IT")
  set par(justify: true)
  set smartquote(alternative: true)

  show raw.where(block: false): it => {
    box(
      fill: luma(92%),
      inset: (x: 0.2em, y: 0em),
      outset: (y: 0.2em),
      radius: 0.2em,
      it
    )
  }

  show link: it => {
    text(fill: rgb("#168aad"), it)
  }

  show: codly-init.with()
  codly(
    zebra-fill: luma(94%),
    fill: luma(97%),
    languages: codly-languages,
    display-icon: false,
  )
  show raw.where(block: true, lang: "input"): local.with(number-format: none)
  show raw.where(block: true, lang: "output"): local.with(number-format: none)

  context {
      if "html_mode" in sys.inputs and target() != "paged" {
        // Workaround broken math in HTML export mode.
        show math.equation.where(block: false): it => {
          html.elem("span", attrs: (role: "math"), html.frame(it))
        }
        show math.equation.where(block: true): it => {
          html.elem("figure", attrs: (role: "math"), html.frame(it))
        }
        html.elem("style", read("style.css"))
        doc
      } else {
        doc
      }
    }
}
