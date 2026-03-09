#import "../../util.typ": *
#import "@preview/cetz:0.4.2": *
#import "@preview/cetz-plot:0.1.2": *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *

#show: codly-init.with()
#codly(languages: codly-languages)

== Grafi

Molti problemi algoritmici si possono formulare in termini di _grafi_. Chiamiamo grafi gli oggetti simili a quelli in figura.

#grid(
  columns: (1fr, 1fr, 1fr),
  rows: 2,
  gutter: 2em,
  align: center,
  [
    #import "../../draw_graph.typ": *
    #canvas({
      let nodes = ((-1, 0), (-1, -1.5), (-1, -3), (1, 0), (1, -1.5), (1, -3))
      let edges = ((0, 3), (0, 4), (0, 5), (1, 3), (1, 5), (2, 4))

      draw_graph(nodes, edges, rad: 10pt)
    })
  ],[
    #import "../../draw_graph.typ": *
    #canvas({
      let N = 8
      let rad = 45pt
      let nodes = ((0, 0),)
      let edges = ()

      for i in range(1, N) {
        nodes.push((
          rad * calc.cos(i * 2 * calc.pi / (N - 1)),
          rad * calc.sin(i * 2 * calc.pi / (N - 1))
        ))

        edges.push((0, i))
      }

      draw_graph(nodes, edges, rad: 10pt)
    })
  ],[
    #import "../../draw_graph.typ": *
    #canvas({
      let nodes = ((0, -1.5), (1, -0.5), (2.5, -0.5), (3.5, -1.5), (2.5, -2.5), (1, -2.5))
      let edges = ((0, 1), (0, 5), (1, 2), (2, 4), (3, 2), (4, 3), (5, 1), (5, 2), (5, 4))

      draw_graph(nodes, edges, rad: 10pt, directed: true)

      let directed = true
    })
  ],
  [_Un grafo bipartito_],
  [_Un albero_],
  [_Un grafo diretto_],
)

Sono grafi gli incroci di una città collegati dalle strade, gli esami necessari per laurearsi e le dipendenze del tipo "l'esame $a$ va dato prima dell'esame $b$", l'insieme dei vostri amici e le relazioni di amicizia tra di loro e tanti altri oggetti. "Tutto è grafo", disse un saggio.

Formalmente, un grafo $G$ è una coppia $(V, E)$ dove $V$ è un insieme di _nodi_ (o _vertici_) e $E$ è un (multi)insieme di _archi_, cioè coppie di nodi. Un arco può essere diretto, cioè una strada a senso unico, o non diretto, cioè una strada a doppio senso. Archi diretti e non diretti corrispondono a coppie ordinate e non ordinate.
Denotiamo con $N$ il numero di nodi e con $M$ il numero di archi.

Due nodi $u, v$ si dicono _adiacenti_ se sono connessi da un arco.

// zoologia?

A livello implementativo, un grafo può assumere tre forme:
- matrice di adiacenza
- lista di archi
- lista di adiacenza

Quest'ultima è la rappresentazione più pratica e comune, ma ognuna ha i propri vantaggi e svantaggi. Una lista di adiacenza da una lista di archi si costruisce come segue.

```cpp
int main() {
  int n; cin >> n; // numero di nodi
  int m; cin >> m; // numero di archi
  vector<vector<int>> adj(n);
  for (int i = 0, a, b; i < m; ++i) {
    cin >> a >> b;
    adj[a].push_back(b); // a -> b
    adj[b].push_back(a); // b -> a
  }

  // la lista di adiacenza è pronta!
}
```

Sottolineamo il fatto che non sempre è necessario memorizzare il grafo come oggetto esplicito: pensa al caso di una griglia $R times C$ dove ogni cella è un nodo e ogni coppia di celle adiacenti è connessa da un arco. Non è necessario memorizzare esplicitamente gli archi, poiché dato un nodo puoi calcolare i suoi vicini in tempo costante.

Abbiamo il nostro grafo in forma di lista di adiacenza: per ogni nodo $v$ il corrispondente vettore $"adj"[v]$ contiene i vicini di $v$. Ora ci piacerebbe visitarlo a partire da un nodo. Ci sono sostanzialmente due modi per farlo.


=== Visite in ampiezza e in profondità

Le due visite che seguono sono i mattoni con cui si costruiscono buona parte degli algoritmi sui grafi: la visita in ampiezza (Breadth-First Search) e in profondità (Depth-First Search).

La BFS visita il grafo a livelli: prima il nodo di partenza, seguito dai suoi vicini, poi i vicini dei vicini non già visitati, e così fino a visitare tutti i nodi raggiungibili. La BFS si implementa processando i nodi uno per volta: il nodo corrente si segna come visitato e i suoi vicini non già visitati si mettono in coda, in attesa di essere processati.

```cpp
// leggi il grafo, ...
auto bfs = [&](int root) {
  vector<bool> vis(adj.size());   // inizializzato a false
  queue<int> Q;                   // libreria <queue>
  vis[root] = true;
  while (!Q.empty()) {
    int cur = Q.front();
    Q.pop();
    cout << "Processo il nodo " << cur << "\n";
    for (int u : adj[v]) {
      if (vis[u])
        continue
      vis[u] = true;
      Q.push(u);
    }
  }
};
```

Nota come la BFS si può utilizzare per calcolare le distanze minime in un grafo non pesato: il livello di ogni nodo è la sua distanza dalla radice.

La DFS, invece, visita il grafo in maniera sostanzialmente ricorsiva. L'implementazione più naturale è quella che segue, ma se nel codice precedente sostituissi la parola `stack` a `queue` e la parola `top` a `front` otterresti lo stesso ordine di visita.

```cpp
// leggi il grafo, ...
vector<bool> vis(n);
auto dfs = [&](auto&& self, int cur) -> void {
  vis[v] = true;
  cout << "Processo il nodo " << cur << "\n";
  for (int u : adj[v])
    if (!vis[u])
      self(self, u);
};
```

// TODO: disegnini dei vari passaggi e relativo albero BFS/DFS
Ti invitiamo a pensare in che senso una visita è in ampiezza e l'altra in profondità.

Prima di procedere, diciamo che un grafo è _connesso_ se da ogni nodo si può raggiungere ogni altro nodo tramite una sequenza di archi consecutivi, chiamata _cammino_. Non tutti i grafi sono connessi, ma ogni grafo si partiziona naturalmente in _componenti connesse_, cioè sottografi connessi, ma sconnessi l'uno dall'altro.
Ora che sappiamo visitare il grafo, possiamo anche contare il numero di isole su una mappa, come nel problema #link(<graph_problems>)[Find the Treasure (ois_islands)].

Un'altra applicazione delle visite è dire se un grafo contiene o meno dei _cicli_, cioè dei cammini che partono e arrivano allo stesso nodo senza passare due volte per lo stesso arco, o ancora l'ordinamento topologico di un grafo diretto acilico, che tratteremo più avanti.

=== Cammini minimi: L'algoritmo di Dijkstra

Consideriamo ora grafi pesati, cioè dove ogni arco ha un _peso_ (o _costo_) associato.

In questo caso, nella lista di adiacenza memorizziamo anche il peso di ogni arco come segue.
```cpp
vector<vector<array<int, 2>>> adj(n);   // {nodo di arrivo, peso dell'arco}
for (int i = 0, a, b, w; i < m; ++i) {
  cin >> a >> b >> w;                   // arco a->b di peso w
  adj[a].push_back({b, w});
}
```

Che te ne fai di un grafo pesato?
Pensa a Google Maps che calcola il percorso migliore per andare da casa tua al panificio: in questo caso il peso di un arco è il tempo necessario per percorrerlo e tu vuoi arrivare al panificio nel minor tempo possibile.

#problem("Cammino Minimo", lbl: "dijkstra",
[
  Dato un grafo pesato, un nodo sorgente $s$ e un nodo obiettivo $t$, determina la lunghezza del minimo cammino da $s$ a $t$.
]
)

In un grafo non pesato, ogni arco ha lo stesso costo (ad esempio $1$) e il problema si risolve facilmente con una BFS. In generale la questione si complica.
Viene in soccorso l'algoritmo di Dijkstra (pronunciato "Daikstra"), che funziona in modo simile alla BFS, ma invece di usare una coda usa una _coda di priorità_ per processare prima i nodi più vicini alla radice. In questo modo, quando si processa un nodo, si è sicuri di aver trovato il cammino più corto per raggiungerlo.

La coda di priorità, per noi `priority_queue` supporta le sequenti operazioni:
- `push(x)`: inserisce l'elemento $x$ nella coda, complessità $cal(O)(log n)$ con $n$ numero di elementi nella coda;
- `top()`: restituisce l'elemento massimo, complessità $cal(O)(1)$;
- `pop()`: rimuove l'elemento massimo, complessità $cal(O)(log n)$.

Segue un'implementazione dell'algoritmo di Dijkstra.

```cpp
// #include <le solite librerie>
#include <array>
#include <queue>

int main() {
  // leggi il grafo
  constexpr LL INF = 1e15;

  vector<LL> dist(n, INF);
  priority_queue<array<int, 2>> Q;  // {-dist[v], v}
  dist[0] = 0;
  Q.push({-0, 0});

  while (!Q.empty()) {
    auto [d, v] = Q.top();
    Q.pop();
    d = -d;
    if (d > dist[v])
      continue;
    for (auto [u, w] : adj[v]) {
      if (dist[v] + w < dist[u]) {
        dist[u] = dist[v] + w;
        Q.push({-dist[u], u});
      }
    }
  }

  for (int i = 0; i < n; ++i)
    cout << "La distanza minima da 0 a " << i << " e' " << dist[i] << "\n";
}
```

Nota come le distanze nella coda di priorità siano cambiate di segno: questo perché la `priority_queue` di default restituisce il massimo, mentre
a noi interessa estrarre l'elemento con la distanza minima.
Ci sono modi più canonici per ottenere lo stesso risultato: in gara questo è il modo più funzionale.

Poiché l'algoritmo esegue al più un inserimento per arco del grafo, la nostra implementazione ha complessità $cal(O)(M log N)$.

=== Minimo albero ricoprente
Immagina di dover progettare la rete elettrica dell'attuale Repubblica Ceca in modo tale che ogni luogo di interesse sia collegato, anche non direttamente, a ogni altro luogo di interesse, minimizzando la lunghezza totale dei collegamenti. Puoi convincerti facilmente che questo problema si formula naturalmente come segue in termini di grafi.

Dato un grafo $G(V, E)$ connesso e pesato, un albero ricoprente è un sottografo connesso che contiene tutti i nodi di $G$ e non contiene cicli.

#problem("Minimum Spanning Tree (MST)", lbl: "mst",
[
  Dato un grafo pesato, trova un albero ricoprente di peso totale minimo.
]
)

// #import "../../draw_graph.typ": *
// #canvas({
//   let nodes = ((0, 0), (2, 2), (2, -2), (5, 2), (5, -2), (7, 0))
//   let edges = ((0, 1), (0, 2), (1, 3), (2, 4), (3, 5), (4, 5), (1, 2), (1, 4), (3, 4))
// 
//   let rad = 0.3
//   for i in range(nodes.len()) {
//     let pos = nodes.at(i)
//     circle(pos, fill: white, stroke: lines_color, radius: 0.3)
//     content(pos, text(size: 1.4 * 0.3)[$#i$])
//   }
// 
//   // draw_graph(nodes, edges, rad: 10pt)
// })

Questo problema si affronta sostanzialmente in tre modi: l'algoritmo di Prim, l'algoritmo di Kruskal e l'algoritmo di Borùvka. Trattiamo i primi due.

==== Algoritmo di Prim

L'algoritmo funziona nel seguente modo. Inizialmente si aggiunge un nodo arbitrario all'albero,
dopodiché, per $N - 1$ volte, si aggiunge un arco di peso minimo che connetta un nuovo nodo all'albero.
Il sottografo risultante è un albero ricoprente di peso minimo.

Anche se inizialmente non si direbbe, l'implementazione è molto simile a quella di Dijkstra. Il cuore del programma cambia come segue.
```cpp
vector<LL> cost(n, INF);
priority_queue<array<int, 2>> Q;  // {-cost[v], v}
cost[0] = 0;
Q.push({-0, 0});

LL peso_totale = 0;

while (!Q.empty()) {
  auto [d, v] = Q.top();
  Q.pop();
  d = -d;
  if (d > cost[v])
    continue;
  peso_totale += d;
  for (auto [u, w] : adj[v]) {
    if (w < cost[u]) {
      cost[u] = w;
      Q.push({-cost[u], u});
    }
  }
}

cout << "L'MST ha peso totale " << peso_totale << "\n";

```

Come ti puoi aspettare, questa implementazione dell'algoritmo di Prim ha la stessa complessità del precedente algoritmo di Dijkstra, cioè $cal(O)(M log N)$.
// inserire dei disegni che simulino l'algoritmo di Prim su un grafo semplice

==== Algoritmo di Kruskal

L'algoritmo di Kruskal si basa sulla seguente proprietà: dato un albero ricoprente, questo ha peso totale minimo se e soltanto se, per ogni ciclo, gli archi rimasti nell'albero non sono più pesanti di quelli rimossi.

Se la proprietà sopra ti sembra intuitiva, possiamo occuparci dell'algoritmo di Kruskal.
L'albero ricoprente contiene inizialmente i nodi del grafo, ma non contiene archi. L'algoritmo processa gli archi uno alla volta in ordine crescente di peso, e li aggiunge all'albero se e soltanto se questi non creano un ciclo.

// disegno di esempio

Una domanda naturale è come facciamo a controllare che aggiungere un arco non formi cicli? Viene in soccorso una delle nostre strutture dati preferite: la cosiddetta Union-Find, efficiente, super carina e dall'implementazione breve.

// mettere i box problema

// === Ordinamento topologico
// TODO
