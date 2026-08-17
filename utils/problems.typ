#import "palette.typ": *
#import "render.typ": is-pdf, is-web

#let tag(name) = box(
  fill: tag_color.at(name, default: luma(220)),
  inset: (x: 0.2em),
  outset: (bottom: 0.23em, top: 0.08em),
  radius: 0.2em,
  baseline: -0.05em,
  text(number-type: "old-style", tracking: 0pt, upper(name))
)

// web: rounded full border (0.5pt + radius); PDF: left accent bar (2pt left stroke).
#let problem(title, url: none, lbl: none, tags: (), body, solution) = {
  if lbl != none {
    title = [#title #label(lbl)]
  }

  if is-web {
    block(
      width: 100%,
      above: 0.8em,
      below: 0.8em,
      fill: problem_bg,
      inset: (left: 0.85em, right: 1em, top: 0.6em, bottom: 0.6em),
      stroke: 0.5pt + rgb("#bac8ff"),
      radius: 0.3em,
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

        #if solution != [] {
          v(0.6em)
          text(weight: "bold")[Soluzione]
          v(0.2em)
          solution
        }
      ],
    )
  } else {
    block(
      width: 100%,
      above: 0.8em,
      below: 0.8em,
      fill: problem_bg,
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

        #if solution != [] {
          v(0.6em)
          text(weight: "bold")[Soluzione]
          v(0.2em)
          solution
        }

      ],
    )
  }
}
