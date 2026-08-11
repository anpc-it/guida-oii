/*
# draw-graph

```
#canvas({
  import "draw-graph.typ": *
  
  let nodes = (
    (0, 0),
    (-1, -1.5),
    (-1.7, -3),
    (-0.3, -3),
    (1, -1.5),
    (1.7, -3),
  )

  let edges = (
    (0, 1, 8),
    (1, 2),
    (1, 3, 6),
    (0, 4),
    (4, 5, 2),
  )

  let fill = (
    "0": rgb("#ff9595"),
    "4": aqua,
    "2": luma(75%),
  )

  draw_graph(nodes, edges, node_fill: fill)
})
```

## function `draw_graph`

Draws a graph

### Parameters:

`nodes`: array of nodes position like ((0, 0), (3, 3), ...)

`edges`: array of nodes indices pair 0-based like ((0, 1), (1, 2), ...). For each edge, you can specify a third number: the weight of the edge.

`rad`: radius of the nodes, default: `12pt`

`directed`: `true` if graph is directed, default: `false`

`node_fill`: dictionary with the nodes with background color, default background: `white`.
Keys should be the 0-based indices of the nodes as strings.

*/
#import "@preview/cetz:0.4.2": draw, vector
#import draw: line, content, 
#import vector: scale, add

#let node_rad = 12pt
#let lines_color = rgb("#252525")

#let pos_avg(posA, posB) = {
  return vector.scale(vector.add(posA, posB), .5)

}

#let draw_node(i, pos, rad, fill: white) = {
  draw.circle(pos, fill: fill, stroke: lines_color, radius: rad)
  content(pos, text(size: 1.4 * rad)[$#i$])
}

#let draw_edge(i, posA, posB, directed, rad, w) = {
  let arrow = none
  if directed {
    arrow = (end: "straight", fill: white, pos: rad)
  }
  draw.line(posA, posB, stroke: lines_color, mark: arrow)

  if w != none {
    content(
      (posA, 50%, posB), 
      rect(stroke: none, fill: white, inset: 3pt, radius: 5pt)[
        #align(center + horizon)[
          #text(size: rad)[$#w$]
        ]
      ]
    )
  }
}

#let draw_graph(nodes, edges, rad: node_rad, directed: false, node_fill: (:)) = {
  for i in range(edges.len()) {
    let w = none
    if edges.at(i).len() > 2 { 
      w = edges.at(i).at(2) 
    }
    draw_edge(
      i, 
      nodes.at(edges.at(i).at(0)), 
      nodes.at(edges.at(i).at(1)),
      directed,
      rad,
      w,
    )
  }
  for i in range(nodes.len()) {
    if str(i) in node_fill {
      draw_node(i, nodes.at(i), rad, fill: node_fill.at(str(i)))
    } else {
      draw_node(i, nodes.at(i), rad)
    }
  }
}

