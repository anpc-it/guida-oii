#let problems = counter("problems")

#let problem(title, url: none, lbl: none, body) = {
  problems.step()
  if label != none {
    title = [#title #label(lbl)]
  }
  let title = place(
    top,
    dy: -1.7em,
    block(
      stroke: 1pt + black,
      fill: white,
      inset: 0.5em,
      spacing: 0pt,
      context { "Problema " + problems.display() + ": " + title }
    )
  );
  let body = title + v(0.5em) + body;
  if url != none {
    body += line(
      length: 100% + 2.0em,
      start: (-1em, 0em),
      stroke: 0.1pt
    ) + v(-0.7em) + text(size: 0.8em, "Prova il problema online: " + url) + v(-0.3em);
  }
  block(radius: 1em, stroke: 1pt + black, inset: 1em, width: 100%, above: 1.5em,
      body,
  )
};
