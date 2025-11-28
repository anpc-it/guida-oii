/*
#canvas({
  import draw: *
  import "../../draw_graph.typ": *

  let nodes = (
    (0, 0),
    (-1, -1.5),
    (-1.7, -3),
    (-0.3, -3),
    (1, -1.5),
    (1.7, -3),
  )

  let edges = (
    (0, 1),
    (1, 2),
    (1, 3),
    (0, 4),
    (4, 5),
  )

  draw_graph(
    nodes, // array of nodes position like ((0, 0), (3, 3), ...)
    edges, // array of nodes indices pair 0-based like ((0, 1), (1, 2), ...)
    rad: 12pt, // radius of the nodes, default 12pt
    directed: false // if graph is directes, default false
  )
})

*/
#import "@preview/cetz:0.4.2": draw
#import draw: line, circle, content

#let node_rad = 12pt
#let lines_color = rgb("#252525")

#let draw_node(i, pos, rad) = {
  circle(pos, fill: white, stroke: lines_color, radius: rad)
  content(pos, text(size: 1.4 * rad)[$#i$])
}

#let draw_edge(i, posA, posB, directed, rad) = {
  let arrow = none
  if directed {
    arrow = (end: ")>", fill: white, pos: rad, scale: 1.5 * rad / node_rad)
  }
  draw.line(posA, posB, stroke: lines_color, mark: arrow)
}

#let draw_graph(nodes, edges, rad: node_rad, directed: false) = {
  for i in range(edges.len()) {
    draw_edge(
      i, 
      nodes.at(edges.at(i).at(0)), 
      nodes.at(edges.at(i).at(1)),
      directed,
      rad
    )
  }
  for i in range(nodes.len()) {
    draw_node(i, nodes.at(i), rad)
  }
}

