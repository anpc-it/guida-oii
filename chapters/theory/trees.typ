#import "@preview/cetz:0.4.2": canvas, draw, tree
#import "@preview/cetz-plot:0.1.2": plot, chart

== Alberi

Dopo aver introdotto i grafi e alcuni algoritmi utili nel ricavare informazioni da essi, è necessario parlare di un tipo particolare di grafo: l'_albero_.

#align(center)[
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

  draw_graph(nodes, edges, rad: 10pt, directed: true)
})
  _Un esempio di albero con $6$ nodi_
]

Un albero è un grafo connesso con esattamente $N - 1$ archi, dove $N$ è il numero di nodi.

Questo fatto comporta diverse proprità, la più importante delle quali è che gli alberi non contengono cicli#footnote([Si può dimostrare facilemnte per induzione.]). 
Questo fatto implica a sua volta che tra due nodi dell'albero esiste un solo cammino che li collega. 

È bene notare che vale anche l'implicazione inversa, cioè se un grafo è connesso e aciclico, allora è un albero ed ha esattamente $N - 1$ archi.

Data l'unicità del cammino tra due nodi è possibile utilizzare molto degli algoritmi noti su grafi generici, spesso con una migliore complessità. 
Ad esempio, per trovare il cammino più breve tra due nodi basta una _DFS_ o una _BFS_, anche se gli archi avessero un peso.

Quando un nodo ha grado $1$, ovvero ha un solo arco uscente, viene detto _foglia_. Nell'albero sopra, le foglie sono i nodi $2, 3$ e $5$. 
Tutti gli alberi con più di un nodo contengono sempre almeno $2$ foglie. 

