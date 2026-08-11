#let example(title, body) = {
  block(
    width: 100%,
    inset: (left: 0.85em, right: 1em, top: 0.7em, bottom: 0.7em),
    stroke: (left: 3pt + rgb("#7b7b7b")),
    fill: luma(95%),
    [
      #if title != none {
        text(size: 1.15em, weight: "bold", fill: rgb("#000000"))[#title]
        v(0.2em)
      }
      #body
    ],
  )
  v(1em)
}
