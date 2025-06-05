#let config(doc) = {
  set text(lang: "it", region: "IT")

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
}
