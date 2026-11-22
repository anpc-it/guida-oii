/*
# draw-array

```
#canvas({
  import "draw_array.typ": *

  let fill = (
    "1": rgb("#ff9595"),
    "4": aqua,
    "5": luma(75%),
  )

  let pointers = (
    (1, "l"),
    (4, "r", blue),
    (6, "mid"),
  )

  draw_array((5, 3, 8, 1, 9, 2, 7), fill: fill, pointers: pointers)
})
```

## function `draw_array`

Draws an array as a row of cells.

### Parameters:

`values`: array of the values to show in the cells like (5, 3, 8, ...).
A value of `none` gives an empty cell.

`origin`: position of the bottom-left corner of the array, default: `(0, 0)`

`cell_w`, `cell_h`: width and height of a cell in canvas units, default: `1` and `0.7`

`font_size`: size of the text inside the cells, default: `14pt`

`fill`: dictionary with the cells with background color, default background: `white`.
Keys should be the 0-based indices of the cells as strings.

`pointers`: array of indicators drawn above the array, each one is an arrow
pointing down to a cell, with a label on its top. Each item is
`(index, label)` or `(index, label, color)`.

`arrow_len`: length of the indicator arrows in canvas units, default: `0.9`

`show_indices`: `true` to write the 0-based index under every cell, default: `true`

`bg_color`: background color of the canvas, default: white

*/
#import "@preview/cetz:0.4.2": draw
#import draw: line, content, rect

#let lines_color = rgb("#252525")
#let indices_color = luma(45%)

#let draw_cell(i, value, origin, cell_w, cell_h, font_size, fill) = {
  let (ox, oy) = origin
  rect(
    (ox + i * cell_w, oy),
    (ox + (i + 1) * cell_w, oy + cell_h),
    fill: fill,
    stroke: lines_color,
  )
  if value != none {
    content(
      (ox + (i + 0.5) * cell_w, oy + cell_h / 2),
      text(size: font_size)[$#value$],
    )
  }
}

#let draw_index(i, origin, cell_w, font_size) = {
  let (ox, oy) = origin
  content(
    (ox + (i + 0.5) * cell_w, oy - 0.1),
    text(size: 0.7 * font_size, fill: indices_color)[$#i$],
    anchor: "north",
  )
}

#let draw_pointer(i, label, color, origin, cell_w, cell_h, arrow_len, font_size, bg_color) = {
  let (ox, oy) = origin
  let x = ox + (i + 0.5) * cell_w
  let top = oy + cell_h
  line(
    (x, top + arrow_len),
    (x, top + 0.05),
    stroke: color,
    mark: (end: "stealth", fill: color),
  )
  if label != none {
    content(
      (x, top + arrow_len + 0.35),
      text(size: 0.85 * font_size, weight: "bold")[$#label$],
      anchor: "south",
    )
  }
}

#let draw_array(values, origin: (0, 0), cell_w: 1, cell_h: .7,
                font_size: 14pt, fill: (:), pointers: (),
                arrow_len: 0.1, show_indices: true, bg_color: white) = {

  for i in range(values.len()) {
    let cell_fill = bg_color
    if str(i) in fill {
      cell_fill = fill.at(str(i))
    }
    draw_cell(i, values.at(i), origin, cell_w, cell_h, font_size, cell_fill)
    if show_indices {
      draw_index(i, origin, cell_w, font_size)
    }
  }

  for p in pointers {
    let color = lines_color
    if p.len() > 2 {
      color = p.at(2)
    }
    draw_pointer(
      p.at(0), p.at(1), color,
      origin, cell_w, cell_h, arrow_len, font_size, bg_color,
    )
  }
}
