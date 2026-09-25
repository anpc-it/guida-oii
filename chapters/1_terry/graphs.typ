#import "/templates/page.typ": project
#import "/utils/render.typ": is-web

#let render = if is-web { project.with(title: "Grafi") } else { it => it }
#show: render

#import "../../utils/problems.typ": *
#import "../../utils/examples.typ": *
#import "../../utils/exercises.typ": *
#import "../../utils/draw_graph.typ": *
#import "../../utils/cetz.typ": canvas
#import "@preview/cetz:0.4.2": vector
#import "../../utils/ref.typ": crossref


== Grafi

Molti problemi algoritmici si possono formulare in termini di _grafi_. Chiamiamo grafi gli oggetti simili a quelli in figura.

#figure(grid(
  columns: (1fr, 1fr, 1fr),
  rows: 2,
  gutter: 2em,
  align: center + horizon,
  [
    #canvas({
      let nodes = ((0, 0), (2, 2), (-1, 2), (3, 0))
      let edges = ((0, 1, 2), (0, 2, 1), (1, 2, 3), (1, 3, 5))

      draw_graph(nodes, edges, rad: 10pt)
    })
  ],[
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
    #import "../../utils/draw_graph.typ": *
    #canvas({
      let nodes = ((0, -1.5), (1, -0.5), (2.5, -0.5), (3.5, -1.5), (2.5, -2.5), (1, -2.5))
      let edges = ((0, 1), (0, 5), (1, 2), (2, 4), (3, 2), (4, 3), (5, 1), (5, 2), (5, 4))

      draw_graph(nodes, edges, rad: 10pt, directed: true)
    })
  ],
  [_Un grafo pesato_],
  [_Un albero_],
  [_Un grafo diretto_],
))

In generale possiamo modellare con un grafo un insieme di entità (dette *nodi*) tra le quali sussistono relazioni di qualche tipo (dette *archi*). 

Sono esempi di grafi gli incroci di una città collegati dalle strade, gli esami necessari per laurearsi e le dipendenze del tipo "l'esame $a$ va dato prima dell'esame $b$", l'insieme dei vostri amici e le relazioni di amicizia tra di loro e tanti altri oggetti.

Formalmente, un grafo $G$ è una coppia $(V, E)$ dove $V$ è un insieme di _nodi_ (o _vertici_) e $E$ è un (multi)insieme di _archi_, cioè coppie di nodi. 
Un arco può essere diretto, cioè una strada a senso unico, o non diretto, cioè una strada a doppio senso. Archi diretti e non diretti corrispondono a coppie ordinate e non ordinate.
Denotiamo con $N$ il numero di nodi e con $M$ il numero di archi.

Due nodi $u, v$ si dicono _adiacenti_ se sono connessi da un arco.

A livello implementativo, un grafo può assumere tre forme:
- matrice di adiacenza
- lista di archi
- lista di adiacenza

Quest'ultima è la rappresentazione più pratica e comune, ma ognuna ha i propri vantaggi e svantaggi. 
Una lista di adiacenza da una lista di archi si costruisce come segue.

```cpp
int main() {
    int n; // numero di nodi
    cin >> n;
    int m; // numero di archi
    cin >> m;
    vector<vector<int>> adj(n);
    for (int i = 0, a, b; i < m; i++) {
        cin >> a >> b;
        adj[a].push_back(b); // a -> b
        adj[b].push_back(a); // b -> a
    }

    // la lista di adiacenza è pronta!
}
```

Sottolineiamo il fatto che non sempre è necessario memorizzare il grafo come oggetto esplicito: pensa al caso di una griglia $R times C$ dove ogni cella è un nodo e ogni coppia di celle adiacenti è connessa da un arco. 
Non è necessario memorizzare esplicitamente gli archi, poiché dato un nodo puoi calcolare i suoi vicini in tempo costante.

Cosa ce ne facciamo di un grafo? 
Alcune delle domande che uno si potrebbe fare sono: posso andare dal nodo $A$ al nodo $B$? C'è solo un modo? Quanto è lungo il cammino più breve tra questi? Quanti sono i gruppi di nodi?

A queste e altre domande possiamo rispondere attraverso degli algoritmi che operano su uno o più grafi.

Abbiamo il nostro grafo in forma di lista di adiacenza: per ogni nodo $v$ il corrispondente vettore $"adj"[v]$ contiene i vicini di $v$. Ora ci piacerebbe visitarlo a partire da un nodo. Ci sono sostanzialmente due modi per farlo.

Prima di vedere quali, è importante introdurre alcuni termini che ci permetteranno di esprimere in modo più semplice alcuni concetti.

Un *_cammino_* fra due nodi $A$ e $B$ è una sequenza di nodi $a_1, a_2, dots, a_k$ tale che $a_1 = A$, $a_k = B$ ed esiste un arco dal nodo $a_i$ al nodo $a_(i + 1)$ per ogni $i = 1 dots k - 1$.
In altre parole seguo un cammino se mi muovo tra i nodi del grafo attraverso gli archi.

Due nodi sono *_connessi_* se esiste un cammino tra loro.

La *_lunghezza_* di un cammino in un grafo non pesato è il numero di archi che questo utilizza. Se il grafo è pesato, la lunghezza del cammino è la somma dei pesi degli archi percorsi.

La *_distanza_* fra due nodi è la lunghezza minima di un cammino tra questi.

=== Visite in ampiezza e in profondità

Le due visite che seguono sono i mattoni con cui si costruiscono buona parte degli algoritmi sui grafi: la visita in ampiezza (Breadth-First Search) e in profondità (Depth-First Search).

La BFS visita il grafo a livelli: prima il nodo di partenza, seguito dai suoi vicini, poi i vicini dei vicini non già visitati, e così fino a visitare tutti i nodi raggiungibili. 
La BFS si implementa processando i nodi uno per volta: il nodo corrente si segna come visitato e i suoi vicini non già visitati si mettono in coda, in attesa di essere processati.

```cpp
// leggi il grafo, ...

vector<bool> vis(adj.size());   // inizializzato a false
vis[root] = true;

queue<int> Q;                   // libreria <queue>
Q.push(root);

while (!Q.empty()) {
    int u = Q.front();
    Q.pop();
    cout << "Processo il nodo " << u << "\n";
    for (int v : adj[u]) {
        if (vis[v])
            continue;
        vis[v] = true;
        Q.push(v);
    }
}

```

Nota come la BFS si può utilizzare per calcolare le distanze minime in un grafo non pesato: il livello di ogni nodo è la sua distanza dalla radice.

Prendiamo il seguente grafo e facciamo una visita in ampiezza assumendo $"root" = 0$. 

#[

#let nodes = ((0, -1.5), (1, -0.5), (2.5, -0.5), (3.5, -1.5), (2.5, -2.5), (1, -2.5))
#let edges = ((0, 1), (0, 5), (1, 2), (2, 4), (3, 2), (4, 3), (5, 1), (5, 2), (5, 4))

#let current = rgb("#a6ffb6")
#let visited = rgb("#d2d2d2") 
#let fill = (:)

#figure(grid(
  columns: (1fr, 1fr, 1fr),
  row-gutter: 30pt,

  [
    #canvas({
      fill += ("0": current)

      draw_graph(nodes, edges, rad: 10pt, node_fill: fill)
    })
    Passo 1 $-> Q = [underline(0)]$
  ],[
    #canvas({
      fill.at("0") = visited
      fill += ("1": current)

      draw_graph(nodes, edges, rad: 10pt, node_fill: fill)
    })
    Passo 2 $-> Q = [cancel(0), underline(1), 5]$
  ],[
    #canvas({
      fill.at("1") = visited
      fill += ("5": current)

      draw_graph(nodes, edges, rad: 10pt, node_fill: fill)
    })
    Passo 3 $-> Q = [cancel(0), cancel(1), underline(5), 2]$
  ],[
    #canvas({
      fill.at("5") = visited
      fill += ("2": current)

      draw_graph(nodes, edges, rad: 10pt, node_fill: fill)
    })
    Passo 4 $-> Q = [cancel(0), cancel(1), cancel(5), underline(2), 4]$
  ],[
    #canvas({
      fill.at("2") = visited
      fill += ("4": current)

      draw_graph(nodes, edges, rad: 10pt, node_fill: fill)
    })
    Passo 5 $-> Q = [cancel(0), cancel(1), cancel(5), cancel(2), underline(4), 3]$
  ],[
    #canvas({
      fill.at("4") = visited
      fill += ("3": current)

      draw_graph(nodes, edges, rad: 10pt, node_fill: fill)
    })
    Passo 6 $-> Q = [cancel(0), cancel(1), cancel(5), cancel(2), cancel(4), underline(3)]$
  ],
))]

L'ordine di visita dei nodi è $[0, 1, 5, 2, 4, 3]$.

I nodi vengono visitati in ordine di distanza dal nodo di partenza, cioè il nodo $0$. Dopo il nodo $0$ vengono visitati i nodi $1$ e $5$ che sono a distanza $1$, poi i nodi $2$ e $4$ a distanza $2$ e infine il nodo $3$ che si trova a distanza $3$.


La DFS, invece, visita il grafo in maniera sostanzialmente ricorsiva. L'implementazione più naturale è quella che segue, ma se nel codice precedente sostituissi la parola `stack` a `queue` e la parola `top` a `front` otterresti lo stesso ordine di visita.

```cpp
// la lista di adiacenza e vis devono essere dichiarati globalmente

void dfs(int u) {
    vis[u] = true;
    cout << "Processo il nodo " << u << "\n";
    for (int v: adj[u])
        if (!vis[v])
            dfs(v);
};
```
Prendiamo il seguente grafo e facciamo una visita in profondità assumendo $"root" = 0$. 

#[

#let nodes = ((0, -1.5), (1, -0.5), (2.5, -0.5), (1.75, -1.5), (2.5, -2.5), (1, -2.5))
#let edges = ((0, 1), (0, 5), (1, 2), (4, 3), (5, 3), (5, 4))

#let current = rgb("#a6ffb6")
#let visited = rgb("#d2d2d2") 
#let fill = (:)

#figure(grid(
  columns: (1fr, 1fr, 1fr),
  row-gutter: 30pt,

  [
    #canvas({
      fill += ("0": current)

      draw_graph(nodes, edges, rad: 10pt, node_fill: fill)
    })
    Passo 1 $-> "dfs"(0)$
  ],[
    #canvas({
      fill.at("0") = visited
      fill += ("1": current)

      draw_graph(nodes, edges, rad: 10pt, node_fill: fill)
    })
    Passo 2 $-> "dfs"(1)$
  ],[
    #canvas({
      fill.at("1") = visited
      fill += ("2": current)

      draw_graph(nodes, edges, rad: 10pt, node_fill: fill)
    })
    Passo 3 $-> "dfs"(2)$
  ],[
    #canvas({
      fill.at("2") = visited
      fill += ("5": current)

      draw_graph(nodes, edges, rad: 10pt, node_fill: fill)
    })
    Passo 4 $-> "dfs"(5)$
  ],[
    #canvas({
      fill.at("5") = visited
      fill += ("4": current)

      draw_graph(nodes, edges, rad: 10pt, node_fill: fill)
    })
    Passo 5 $-> "dfs"(4)$
  ],[
    #canvas({
      fill.at("4") = visited
      fill += ("3": current)

      draw_graph(nodes, edges, rad: 10pt, node_fill: fill)
    })
    Passo 6 $-> "dfs"(3)$
  ],
))]

In questo caso l'ordine di visita dei nodi è $[0, 1, 2, 5, 4, 3]$.

Sia nel caso della BFS che nel caso della DFS l'ordine di visita può variare in base all'ordine dei nodi nelle liste di adiacenza e all'implementazione della visita.
Ti invitiamo a pensare in che senso una visita è in ampiezza e l'altra in profondità.

Per il momento diciamo che l'applicazione principale della BFS è trovare la distanza da un nodo verso tutti gli altri in un grafo non pesato.
L'ordine di visita della DFS invece diventerà importante quando parleremo di alberi.

Prima di procedere, diciamo che un grafo è _*connesso*_ se ogni coppia di nodi del grafo è connessa. Non tutti i grafi sono connessi, ma ogni grafo si partiziona naturalmente in _componenti connesse_, cioè sottografi connessi, ma sconnessi l'uno dall'altro.

#figure(
  canvas({
    let node = ((-1, 0), (0, 1.5), (1.5, 0), (3, 1), (4, 3), (5, 1.5), (2, 2.5), (-2, 2.5))
    let edges = ((0, 1), (1, 2), (2, 0), (6, 5), (3, 6), (6, 4))
    let fill = (
      "0": rgb("#9aff6c"),
      "1": rgb("#9aff6c"),
      "2": rgb("#9aff6c"),
      "3": rgb("#ffac8b"),
      "4": rgb("#ffac8b"),
      "5": rgb("#ffac8b"),
      "6": rgb("#ffac8b"),
      "7": rgb("#5be4ff"),
    )
    draw_graph(node, edges, node_fill: fill, rad: 10pt)
  }),
  caption: [Le componenti connesse sono evidenziate con colori diversi.]
)

Ora che sappiamo visitare il grafo, possiamo anche contare il numero di isole su una mappa, come nel problema #crossref(<graph_problems>, "/chapters/4_editorials/graph_problems.typ", [Find the Treasure (ois_islands)]).

Un'altra applicazione delle visite è dire se un grafo contiene o meno dei _cicli_, cioè dei cammini che partono e arrivano allo stesso nodo senza passare due volte per lo stesso arco, o ancora l'ordinamento topologico di un grafo diretto aciclico, che tratteremo più avanti.


==== BFS multi-sorgente

Una variante piuttosto utile della visita in ampiezza è quella con più sorgenti.
La visita si espande non da una sorgente sola ma da molte di queste. 
Virtualmente, ciò è equivalente a creare un nodo fittizio $s$ connesso ai nodi che vogliamo rendere sorgenti della BFS, per poi fare una BFS da $s$. 
Questa osservazione è sufficiente per dire che la BFS multi-sorgente ha la stessa complessità della BFS normale. 

Questo algoritmo ci permette, ad esempio, di vedere come si propaga un incendio appiccato in più nodi di un grafo contemporaneamente, oppure, dati alcuni nodi speciali, di trovare per ogni nodo del grafo il nodo speciale più vicino.

#figure(
  caption: [Una tipica applicazione della BFS multi-sorgente: trovare la minima distanza da uno dei nodi speciali.]
)[
  #let width = 10
  #let height = 6
  #let sources = ((1, 2), (8, 1), (4, 4))

  #let dist(x, y) = {
    let min-d = 1000
    for (sx, sy) in sources {
      let d = calc.abs(x - sx) + calc.abs(y - sy)
      if d < min-d { min-d = d }
    }
    min-d
  }

  #let cells = {
    for y in range(height) {
      for x in range(width) {
        let d = dist(x, y)
        
        let fill-color = if d == 0 {
          red.lighten(40%)
        } else {
          blue.lighten(15% + d * 18%)
        }

        (grid.cell(
          fill: fill-color,
          align: center + horizon,
          if d == 0 { [*S*] } else { str(d) }
        ),)
      }
    }
  }

  #grid(
    columns: width * (30pt,),
    rows: height * (30pt,),
    stroke: 0.5pt + luma(150),
    ..cells
  )

]

L'implementazione è la stessa di una BFS normale ma all'inizio di inseriscono in coda tutte le sorgenti. 
Se si cerca la distanza occorre assegnare $0$ alla distanza di ciascuna delle sorgenti.

```cpp
for (int v: sorgenti) {
    Q.push(v);
    visitato[v] = true;
}

// BFS normale

```
Alcuni esercizi a riguardo:

#exercise("Voci di Corridoio", "https://territoriali.olinfo.it/task/gossip", diff: 1)
#exercise("Caccia agli Interruttori", "https://territoriali.olinfo.it/task/interruttori", diff: 1)
#exercise("Monsters", "https://cses.fi/problemset/task/1194", diff: 2)
#exercise("Espansione del danno", "https://territoriali.olinfo.it/task/espanditutto", diff: 3)

=== Cammini minimi: L'algoritmo di Dijkstra

Consideriamo ora grafi pesati, cioè dove ogni arco ha un _peso_ (o _costo_) associato.

In questo caso, nella lista di adiacenza memorizziamo anche il peso di ogni arco come segue.
```cpp
vector<vector<pair<int, int>>> adj(n);   // {nodo di arrivo, peso dell'arco}
for (int i = 0, a, b, w; i < m; i++) {
    cin >> a >> b >> w;                   // arco a->b di peso w
    adj[a].push_back({b, w});
}
```

Che te ne fai di un grafo pesato?
Pensa a Google Maps che calcola il percorso migliore per andare da casa tua al panificio: in questo caso il peso di un arco è il tempo necessario per percorrerlo e tu vuoi arrivare al panificio nel minor tempo possibile.

Il problema, più in astratto, è: dato un grafo pesato, un nodo sorgente $s$ e un nodo obiettivo $t$, determina la lunghezza del minimo cammino da $s$ a $t$.

In un grafo non pesato, ogni arco ha lo stesso costo (ad esempio $1$) e il problema si risolve facilmente con una BFS. In generale la questione si complica.
Viene in soccorso l'algoritmo di Dijkstra (pronunciato "Daikstra"), che funziona in modo simile alla BFS, ma invece di usare una coda usa una _coda di priorità_ per processare prima i nodi più vicini alla radice. In questo modo, quando si processa un nodo, si è sicuri di aver trovato il cammino più corto per raggiungerlo.

Ricordiamo che la coda di priorità, per noi `priority_queue`, supporta le seguenti operazioni:
- `push(x)`: inserisce l'elemento $x$ nella coda, complessità $cal(O)(log n)$ con $n$ numero di elementi nella coda;
- `top()`: restituisce l'elemento massimo, complessità $cal(O)(1)$;
- `pop()`: rimuove l'elemento massimo, complessità $cal(O)(log n)$.

Normalmente le code a priorità hanno in cima l'elemento massimo, ma noi siamo interessati a quello con chiave (la distanza) minima.

Per ovviare a questo problema possiamo inserire le distanze cambiate di segno (sconsigliato, è facile dimenticarsi dei segni meno in giro) o specificare, quando dichiariamo la coda, come ordinarla.

Segue un'implementazione dell'algoritmo di Dijkstra.

```cpp
// #include <le solite librerie>
#include <array>
#include <queue>

int main() {
    // leggi il grafo
    constexpr ll INF = 1e15;
    int sorgente = 0;

    vector<ll> dist(n, INF);
    priority_queue<pair<ll, int>,
                    vector<pair<ll, int>>,
                    greater<>> Q;  // {dist[u], u}

    dist[sorgente] = 0;
    Q.push({0, sorgente});

    while (!Q.empty()) {
        auto [d, u] = Q.top();
        Q.pop();

        if (d > dist[u])
        continue;

        for (auto [v, w]: adj[u]) {
            if (d + w < dist[v]) {
                dist[v] = d + w;
                Q.push({dist[v], v});
            }
        }
    }

    for (int i = 0; i < n; i++)
        cout << "La distanza minima da " << sorgente << " a " << i << " e' " << dist[i] << "\n";
}
```
#example[][
  Nel grafo sotto raffigurato, utilizzando il nodo $0$ come sorgente, l'array $"dist"$ conterrà i seguenti valori al termine dell'esecuzione: $[0, 6, 2, 5, 9, 7, 9]$.
  
  #let bg_color = context block.fill
  #figure(
    canvas({
      let nodes = ((0.25, 1.5), (1.5, 0), (1.5, 3), (2.75, 1.5), (4, 0), (4, 3), (5.25, 1.5))
      let edges = ((0, 1, 7), (0, 2, 2), (2, 3, 3), (1, 3, 1), (2, 5, 5), (1, 4, 3), (3, 6, 8), (4, 6, 2), (5, 6, 2))

      draw_graph(nodes, edges, rad: 10pt, node_fill: ("0": rgb("#8dffd7")), bg_color: example_bg)
    })
  )

  Per come è strutturato l'algoritmo, i nodi verranno estratti dalla coda in ordine di distanza dalla sorgente, in questo caso nell'ordine $[0, 2, 3, 1, 5, 4, 6]$.
  Poiché l'algoritmo esegue al più un inserimento per arco del grafo, la nostra implementazione ha complessità $cal(O)(M log N)$.
]

#include "minimum_spanning_tree.typ"

// TODO: === Ordinamento topologico (direi nella sezione OII non terry)
=== Problemi consigliati

#exercise("Message Route", "https://cses.fi/problemset/task/1667", diff: 1)
#exercise("Building Roads", "https://cses.fi/problemset/task/1666", diff: 1)
#exercise("Cammino minimo", "https://training.olinfo.it/task/mincammino", diff: 1)
#exercise("Counting Roads", "https://cses.fi/problemset/task/1192", diff: 2)
#exercise("Monsters", "https://cses.fi/problemset/task/1194", diff: 2)
#exercise("Episodio II: un lungo viaggio", "https://training.olinfo.it/task/oii_bus", diff: 3)
#exercise("Arte nei corridoi", "https://training.olinfo.it/task/oii_corridoi", diff: 3)
