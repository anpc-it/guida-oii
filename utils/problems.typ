#let tag_color = (
  "oii": rgb("#5cacec"),
  "ois": rgb("#b0a3d6"),
  "pre-oii": rgb("#80d66a"),
  "cses": rgb("#eecd5f"),
)

#let tag(name) = box(
  fill: tag_color.at(name, default: luma(220)),
  inset: (x: 0.2em),
  outset: (bottom: 0.23em, top: 0.08em),
  radius: 0.2em,
  baseline: -0.05em,
  text(number-type: "old-style", tracking: 0pt, upper(name))
)

#let problem(title, url: none, lbl: none, tags: (), solution: none, body) = {
  if lbl != none {
    title = [#title #label(lbl)]
  }

  block(
    width: 100%,
    above: 0.8em,
    below: 0.8em,
    fill: luma(97%),
    inset: (left: 0.85em, right: 1em, top: 0.6em, bottom: 0.6em),
    stroke: (left: 2pt + rgb("#bac8ff")),
    [
      #text(weight: "bold")[#title]
      #if tags.len() > 0 {
        h(0.5em)
        for tagname in tags { tag(tagname) }
      }
      #v(0.35em)
      #body
      #if url != none {
        v(0.35em)
        align(right)[
          #text(size: 0.8em)[Prova il problema online: #link(url)[#url]]
        ]
      }

      #if solution != none {
        v(0.6em)
        text(weight: "bold")[Soluzione]
        v(0.2em)
        solution
      }

    ],
  )
}
