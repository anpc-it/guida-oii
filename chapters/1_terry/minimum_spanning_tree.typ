#import "/templates/page.typ": project
#import "/utils/render.typ": is-web

#let render = if is-web { project.with(title: "Minimo albero ricoprente") } else { it => it }
#show: render

#import "../../utils/problems.typ": *
#import "../../utils/examples.typ": *
#import "../../utils/exercises.typ": *
#import "../../utils/draw_graph.typ": *
#import "../../utils/cetz.typ": canvas
#import "@preview/cetz:0.4.2": vector
#import "../../utils/ref.typ": crossref



=== Minimo albero ricoprente

Immagina di dover progettare la rete elettrica dell'attuale Repubblica Ceca in modo tale che ogni luogo di interesse sia collegato, anche non direttamente, a ogni altro luogo di interesse, minimizzando la lunghezza totale dei collegamenti. Puoi convincerti facilmente che questo problema si formula naturalmente come segue in termini di grafi.

Dato un grafo $G(V, E)$ connesso e pesato, un albero ricoprente è un sottografo connesso che contiene tutti i nodi di $G$ e non contiene cicli.


Questo problema si affronta sostanzialmente in tre modi: l'algoritmo di Prim, l'algoritmo di Kruskal e l'algoritmo di Borůvka. Trattiamo i primi due.

==== Algoritmo di Prim

L'algoritmo funziona nel seguente modo. Inizialmente si aggiunge un nodo arbitrario all'albero,
dopodiché, per $N - 1$ volte, si aggiunge un arco di peso minimo che connetta un nuovo nodo all'albero.
Il sottografo risultante è un albero ricoprente di peso minimo.

Anche se inizialmente non si direbbe, l'implementazione è molto simile a quella di Dijkstra.
Il cuore del programma cambia come segue.

```cpp
vector<ll> cost(n, INF);
priority_queue<pair<ll, int>,
                vector<pair<ll, int>>,
                greater<>> Q;  // {cost[u], u}

cost[0] = 0;
Q.push({0, 0});

ll peso_totale = 0;

while (!Q.empty()) {
    auto [d, u] = Q.top();
    Q.pop();

    if (d > cost[u])
        continue;

    peso_totale += d;
    for (auto [v, w]: adj[u]) {
        if (w < cost[v]) {
            cost[v] = w;
            Q.push({cost[v], v});
        }
    }
}

cout << "L'MST ha peso totale " << peso_totale << "\n";

```

Come ti puoi aspettare, questa implementazione dell'algoritmo di Prim ha la stessa complessità del precedente algoritmo di Dijkstra, cioè $cal(O)(M log N)$.

#example[][
  Consideriamo il seguente grafo:

  #figure(
    canvas({
      let nodes = ((0.25, 1.5), (1.5, 0), (1.5, 3), (2.75, 1.5), (4, 0), (4, 3), (5.25, 1.5))
      let edges = ((0, 1, 7), (0, 2, 2), (2, 3, 3), (1, 3, 1), (2, 5, 5), (1, 4, 8), (3, 6, 4), (4, 6, 2), (5, 6, 2))

      draw_graph(nodes, edges, rad: 10pt, bg_color: example_bg)
    })
  )

  Procediamo passo dopo passo seguendo l'algoritmo di Prim. 
  Ogni volta prenderemo l'arco di peso minimo che connette un nodo preso (in rosso) e uno non preso.
  Cominceremo scegliendo arbitrariamente il nodo $0$ come nodo preso.

  #v(2em)

  #[

  #let nodes = ((0.25, 1.5), (1.5, 0), (1.5, 3), (2.75, 1.5), (4, 0), (4, 3), (5.25, 1.5))
  #for i in range(nodes.len()) {
    nodes.at(i) = vector.scale(nodes.at(i), 0.8)
  }
  //#let edges = ((0, 1, 7), (0, 2, 2), (2, 3, 3), (1, 3, 1), (2, 5, 5), (1, 4, 8), (3, 6, 4), (4, 6, 2), (5, 6, 2))
  #let edges = ()
  #let in_color = rgb("#ff9494")
  #let add_color = rgb("#9adcff")
  #let fill = ("0": in_color)

  #figure(grid(
    columns: (1fr, 1fr, 1fr),
    row-gutter: 30pt,
    column-gutter: 10pt,
    [
      #canvas({
        edges += ((0, 2, 2),)
        fill += ("2": add_color)
        draw_graph(nodes, edges, rad: 8pt, node_fill: fill, bg_color: example_bg)
      })
      Passo $1$: l'arco più piccolo uscente da $0$ è quello verso $2$.
    ],[
      #canvas({
        fill.at("2") = in_color
        fill += ("3": add_color)
        edges += ((2, 3, 3),)
        draw_graph(nodes, edges, rad: 8pt, node_fill: fill, bg_color: example_bg)
      })
      Passo $2$: ora l'albero è composto da $0$ e $2$, l'arco minimo uscente è $2->3$ con peso $3$.
    ],[
      #canvas({
        fill.at("3") = in_color
        fill += ("1": add_color)
        edges += ((1, 3, 1),)
        draw_graph(nodes, edges, rad: 8pt, node_fill: fill, bg_color: example_bg)
      })
      Passo $3$: l'arco uscente minimo è $3->1$ con peso $1$.
    ],[
      #canvas({
        fill.at("1") = in_color
        fill += ("6": add_color)
        edges += ((3, 6, 4),)
        draw_graph(nodes, edges, rad: 8pt, node_fill: fill, bg_color: example_bg)
      })
      Passo $4$: l'arco uscente minimo è $3->6$ con peso $4$.
    ],[
      #canvas({
        fill.at("6") = in_color
        fill += ("4": add_color)
        edges += ((4, 6, 2),)
        draw_graph(nodes, edges, rad: 8pt, node_fill: fill, bg_color: example_bg)
      })
      Passo $5$: l'arco uscente minimo è $6->4$ con peso $2$.
    ],[
      #canvas({
        fill.at("4") = in_color
        fill += ("5": add_color)
        edges += ((5, 6, 2),)
        draw_graph(nodes, edges, rad: 8pt, node_fill: fill, bg_color: example_bg)
      })
      Passo $6$: l'arco uscente minimo è $6->5$ con peso $2$.
    ],
  ))]

  #v(2em)

  Abbiamo ottenuto l'albero che desideravamo. 
  Di questo ora sappiamo dire il costo totale (14 in questo caso) e da quali archi è composto. 
]

//TODO: spostare MST in OII dopo il capitolo sulla DSU, così si può spiegare Kruskal
/*
==== Algoritmo di Kruskal

L'algoritmo di Kruskal si basa sulla seguente proprietà: dato un albero ricoprente, questo ha peso totale minimo se e soltanto se, per ogni ciclo, gli archi rimasti nell'albero non sono più pesanti di quelli rimossi.

Se la proprietà sopra ti sembra intuitiva, possiamo occuparci dell'algoritmo di Kruskal.
L'albero ricoprente contiene inizialmente i nodi del grafo, ma non contiene archi. L'algoritmo processa gli archi uno alla volta in ordine crescente di peso, e li aggiunge all'albero se e soltanto se questi non creano un ciclo, cioè se connettono due componenti prima non connesse.

Una domanda naturale è come facciamo a controllare che due nodi siano in componenti diverse ed eventualmente a unire queste componenti? Viene in soccorso una delle nostre strutture dati preferite: la cosiddetta Union-Find, o DSU.

#example[][
  Per il momento limitiamoci a vedere un esempio con lo stesso grafo usato in precedenza:

  #v(2em)

  #[

  #let nodes = ((0.25, 1.5), (1.5, 0), (1.5, 3), (2.75, 1.5), (4, 0), (4, 3), (5.25, 1.5))
  #for i in range(nodes.len()) {
    nodes.at(i) = vector.scale(nodes.at(i), 0.8)
  }
  //#let edges = ((0, 1, 7), (0, 2, 2), (2, 3, 3), (1, 3, 1), (2, 5, 5), (1, 4, 8), (3, 6, 4), (4, 6, 2), (5, 6, 2))
  #let edges = ()

  #figure(grid(
    columns: (1fr, 1fr, 1fr),
    row-gutter: 30pt,
    column-gutter: 10pt,
    [
      #canvas({
        edges += ((1, 3, 1),)
        draw_graph(nodes, edges, rad: 8pt, bg_color: example_bg)
      })
      Passo $1$: l'arco più piccolo in assoluto è $1->3$ con peso $1$.
    ],[
      #canvas({
        edges += ((0, 2, 2),)
        draw_graph(nodes, edges, rad: 8pt, bg_color: example_bg)
      })
      Passo $2$: l'arco (uno dei tre) più piccolo ora è $0->2$ con peso $2$.
    ],[
      #canvas({
        edges += ((6, 5, 2),)
        draw_graph(nodes, edges, rad: 8pt, bg_color: example_bg)
      })
      Passo $3$: prendiamo ora l'arco $5->6$ di peso $2$.
    ],[
      #canvas({
        edges += ((6, 4, 2),)
        draw_graph(nodes, edges, rad: 8pt, bg_color: example_bg)
      })
      Passo $4$: anche l'arco $4->6$ di peso $2$ viene preso.
    ],[
      #canvas({
        edges += ((2, 3, 3),)
        draw_graph(nodes, edges, rad: 8pt, bg_color: example_bg)
      })
      Passo $5$: possiamo aggiungere l'arco $2->3$ di peso $3$.
    ],[
      #canvas({
        edges += ((3, 6, 4),)
        draw_graph(nodes, edges, rad: 8pt, bg_color: example_bg)
      })
      Passo $6$: l'ultimo arco che prendiamo è $3->6$ con peso $4$.
    ],
  ))]

  #v(2em)

  Gli ultimi due archi in ordine di peso non connettono nodi che non siano già connessi fra loro, dunque non prendiamo altri archi.

  Si noti che gli archi sono stati aggiunti in ordine di peso e che, a differenza di Prim, si connettono più gruppi di nodi contemporaneamente.
]

L'albero risultante da quest'altro algoritmo è lo stesso ottenuto con Prim, ma non è sempre così.
La garanzia che abbiamo è che entrambi producano un albero ricoprente il cui peso è minimo tra tutti i possibili alberi ricoprenti.

*/