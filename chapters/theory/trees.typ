#import "@preview/cetz:0.4.2": canvas, draw, tree
#import "@preview/cetz-plot:0.1.2": plot, chart

== Alberi

Dopo aver introdotto i grafi e alcuni algoritmi utili nel ricavare informazioni da essi, è necessario parlare di un tipo particolare di grafo: l'albero.

#align(center)[
#canvas({
  import draw: *
  let encircle(i) = {
    std.box(baseline: 2pt, std.circle(stroke: .5pt, radius: 1em)[#move(dx: -0em, dy: -0.1em, $#i$)])
  }

  set-style(content: (padding: 0))
  tree.tree((
      [#encircle($0$)],
      (
        [#encircle($1$)],
          ([#encircle($2$)]),
          ([#encircle($3$)]),
      ),
      (
        [#encircle($4$)],
          ([#encircle($5$)]),
      ),
    )
  )
})
  _Prossimamente arriva un'immagine migliore_
]

