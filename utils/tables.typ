#import "palette.typ": *
#import "render.typ": is-pdf, is-web

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
  let table-body = table(
    columns: (auto, auto, 1fr),
    gutter: 2pt,
    stroke: white,
    inset: (x: 5pt, y: 7pt),
    align: (center, center, left),
    fill: (x, y) =>
      if y == 0 { luma(75%) }
      else { op_table_cell_bg },
    ..cells,
  )

  if is-web {
    table-body
  } else {
    figure(table-body)
  }
}
