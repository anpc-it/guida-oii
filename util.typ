#let problems = counter("problems")

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
  text(number-type: "old-style", smallcaps(name))
)

#let problem(title, url: none, lbl: none, tags: (), body) = {
  v(0.85em)
  box({
    problems.step()
    if label != none {
      title = [#title #label(lbl)]
    }
    let title = place(
      top,
      dy: -1.7em,
      block(
        radius: 0.3em,
        stroke: 1pt + black,
        fill: white,
        inset: 0.5em,
        spacing: 0pt,
        context [
          Problema #problems.display(): #title 
          #for tagname in tags {[
            #tag(tagname)
          ]}
        ]
      )
    );
    let body = title + v(0.5em) + body;
    if url != none {
      body += line(
        length: 100% + 2.0em,
        start: (-1em, 0em),
        stroke: 0.1pt
      ) + v(-0.7em) + text(size: 0.8em, "Prova il problema online: " + link(url)) + v(-0.3em);
    }
    block(radius: 0.3em, stroke: 1pt + black, inset: 1em, width: 100%, above: 1.5em,
        body,
    )
  })
};

#let node_rad = 10pt
#let lines_color = rgb("#252525")
#import "@preview/cetz:0.4.2": draw
#import draw: *

#let draw_node(i, pos) = {
  circle(pos, fill: white, stroke: lines_color, radius: node_rad)
  content(pos, [$#i$])
}

#let draw_edge(i, posA, posB) = {
  draw.line(posA, posB, stroke: lines_color)
}

#let draw_graph(nodes, edges) = {
  for i in range(edges.len()) {
    draw_edge(i, nodes.at(edges.at(i).at(0)), nodes.at(edges.at(i).at(1)))
  }
  for i in range(nodes.len()) {
    draw_node(i, nodes.at(i))
  }
}
