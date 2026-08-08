#let op-row(operation, complexity, details) = (operation, complexity, details)

#let op-table(..rows) = {
  let cells = (
    [#text(weight: "semibold")[Operazione]],
    [#text(weight: "semibold")[Complessità]],
    [#text(weight: "semibold")[Dettagli]],
  )
  for row in rows.pos() {
    cells = cells + row
  }
  figure(
    table(
      columns: (auto, auto, 1fr),
      gutter: 2pt,
      stroke: white,
      inset: (x: 5pt, y: 7pt),
      fill: (x, y) =>
        if y == 0 { luma(75%) }
        else { luma(97%) },
      ..cells,
    )
  )
}
