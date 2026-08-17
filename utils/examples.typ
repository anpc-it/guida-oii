#import "palette.typ": *
#import "render.typ": is-pdf, is-web

#let example(title, body) = {
  if is-web {
    block(
      width: 100%,
      inset: (left: 0.85em, right: 1em, top: 0.7em, bottom: 0.7em),
      stroke: 0.5pt + rgb("#7b7b7b"),
      radius: 0.3em,
      fill: example_bg,
      [
        #if title != none {
          text(size: 1.15em, weight: "bold", fill: rgb("#000000"))[#title]
          v(0.2em)
        }
        #body
      ],
    )
  } else {
    block(
      width: 100%,
      inset: (left: 0.85em, right: 1em, top: 0.7em, bottom: 0.7em),
      stroke: (left: 3pt + rgb("#7b7b7b")),
      fill: example_bg,
      [
        #if title != none {
          text(size: 1.15em, weight: "bold", fill: rgb("#000000"))[#title]
          v(0.2em)
        }
        #body
      ],
    )
  }
  v(1em)
}
