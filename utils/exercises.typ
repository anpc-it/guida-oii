#import "render.typ": is-pdf, is-web

#let exercise(name, url, diff: 1) = {
  let col = (rgb("#10b981"), rgb("#f59e0b"), rgb("#ef4444")).at(diff - 1, default: rgb("#10b981"))
  let off = rgb("#cbd5e1")

  let meter = box(baseline: -0.5pt)[
    #stack(
      dir: ltr,
      spacing: 2pt,
      circle(radius: 2.2pt, fill: col),
      circle(radius: 2.2pt, fill: if diff >= 2 { col } else { none }, stroke: if diff >= 2 { none } else { 0.6pt + off }),
      circle(radius: 2.2pt, fill: if diff >= 3 { col } else { none }, stroke: if diff >= 3 { none } else { 0.6pt + off }),
    )
  ]

  block(
    width: 100%,
    stroke: (bottom: 0.35pt + luma(228)),
    radius: (right: 2.5pt),
    inset: (x: 7pt, y: 3.5pt),
    above: 0.35em,
    below: 0.35em,
    [
      #grid(
        columns: (auto, 1fr),
        gutter: 6pt,
        align: (horizon, left + horizon),
        meter,
        [
          #name #h(2pt) #text(size: 8pt)[(#link(url))]
        ],
      )
    ],
  )
}
