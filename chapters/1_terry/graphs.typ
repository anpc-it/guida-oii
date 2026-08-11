#import "../../utils/problems.typ": *
#import "@preview/cetz:0.4.2": *
#import "@preview/cetz-plot:0.1.2": *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#import "../../utils/draw_graph.typ": *


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

Sono grafi gli incroci di una città collegati dalle strade, gli esami necessari per laurearsi e le dipendenze del tipo "l'esame $a$ va dato prima dell'esame $b$", l'insieme dei vostri amici e le relazioni di amicizia tra di loro e tanti altri oggetti. 

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
    for (int v: adj[u]) {
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

Ora che sappiamo visitare il grafo, possiamo anche contare il numero di isole su una mappa, come nel problema #link(<graph_problems>)[Find the Treasure (ois_islands)].

Un'altra applicazione delle visite è dire se un grafo contiene o meno dei _cicli_, cioè dei cammini che partono e arrivano allo stesso nodo senza passare due volte per lo stesso arco, o ancora l'ordinamento topologico di un grafo diretto acilico, che tratteremo più avanti.

=== Cammini minimi: L'algoritmo di Dijkstra

Consideriamo ora grafi pesati, cioè dove ogni arco ha un _peso_ (o _costo_) associato.

In questo caso, nella lista di adiacenza memorizziamo anche il peso di ogni arco come segue.
```cpp
vector<vector<pair<int, int>>> adj(n);   // {nodo di arrivo, peso dell'arco}
for (int i = 0, a, b, w; i < m; ++i) {
    cin >> a >> b >> w;                   // arco a->b di peso w
    adj[a].push_back({b, w});
}
```

Che te ne fai di un grafo pesato?
Pensa a Google Maps che calcola il percorso migliore per andare da casa tua al panificio: in questo caso il peso di un arco è il tempo necessario per percorrerlo e tu vuoi arrivare al panificio nel minor tempo possibile.

#problem("Cammino Minimo", url: "training.olinfo.it/task/mincammino2", lbl: "dijkstra",
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

Normalmente le code a priorità hanno in cima l'elemento massimo, ma noi siamo interessato a quello con chiave (la distanza) minima.
Per ovviare a questo problema possiamo inserire le distanze cambiate di segno (sconsigliato, è facile dimenticarsi dei segni meno in giro) o specificare, quando dichiariamo la coda, come ordinarla. 

Segue un'implementazione dell'algoritmo di Dijkstra.

```cpp
// #include <le solite librerie>
#include <array>
#include <queue>

int main() {
    // leggi il grafo
    constexpr LL INF = 1e15;
    int sorgente = 0;

    vector<LL> dist(n, INF);
    priority_queue<pair<LL, int>,
                   vector<pair<LL, int>>,
                   greater<>> Q;  // {dist[u], u}

    dist[sorgente] = 0;
    Q.push({0, sorgente});

    while (!Q.empty()) {
        auto [d, u] = Q.top();
        Q.pop();

        if (d > dist[u]) // importante
            continue;

        for (auto [v, w]: adj[u]) {
            if (d + w < dist[v]) {
                dist[v] = d + w;
                Q.push({dist[v], v});
            }
        }
    }

    for (int i = 0; i < n; ++i)
        cout << "La distanza minima da " << sorgente << " a " << i << " è " << dist[i] << "\n";
}
```

Nel grafo sotto raffigurato, utilizzando il nodo $0$ come sorgente, l'array $"dist"$ conterrà i seguenti valori al termine dell'esecuzione: $[0, 6, 2, 5, 9, 7, 9]$.

#figure(
  canvas({
    let nodes = ((0.25, 1.5), (1.5, 0), (1.5, 3), (2.75, 1.5), (4, 0), (4, 3), (5.25, 1.5))
    let edges = ((0, 1, 7), (0, 2, 2), (2, 3, 3), (1, 3, 1), (2, 5, 5), (1, 4, 3), (3, 6, 8), (4, 6, 2), (5, 6, 2))

    draw_graph(nodes, edges, rad: 10pt, node_fill: ("0": rgb("#8dffd7")))
  })
)

Per come è strutturato l'algoritmo, i nodi verranno estratti dalla coda in ordine di distanza dalla sorgente, in questo caso nell'ordine $[0, 2, 3, 1, 5, 4, 6]$.

Poiché l'algoritmo esegue al più un inserimento per arco del grafo, la nostra implementazione ha complessità $cal(O)(M log N)$.

=== Minimo albero ricoprente
Immagina di dover progettare la rete elettrica dell'attuale Repubblica Ceca in modo tale che ogni luogo di interesse sia collegato, anche non direttamente, a ogni altro luogo di interesse, minimizzando la lunghezza totale dei collegamenti. Puoi convincerti facilmente che questo problema si formula naturalmente come segue in termini di grafi.

Dato un grafo $G(V, E)$ connesso e pesato, un albero ricoprente è un sottografo connesso che contiene tutti i nodi di $G$ e non contiene cicli.

#problem("Minimum Spanning Tree (MST)", lbl: "mst")[
  Dato un grafo pesato, trova un albero ricoprente di peso totale minimo.
]

Questo problema si affronta sostanzialmente in tre modi: l'algoritmo di Prim, l'algoritmo di Kruskal e l'algoritmo di Borùvka. Trattiamo i primi due.

==== Algoritmo di Prim

L'algoritmo funziona nel seguente modo. Inizialmente si aggiunge un nodo arbitrario all'albero,
dopodiché, per $N - 1$ volte, si aggiunge un arco di peso minimo che connetta un nuovo nodo all'albero.
Il sottografo risultante è un albero ricoprente di peso minimo.

Anche se inizialmente non si direbbe, l'implementazione è molto simile a quella di Dijkstra. 
Il cuore del programma cambia come segue.

```cpp
vector<LL> cost(n, INF);
priority_queue<pair<LL, int>,
               vector<pair<LL, int>>,
               greater<>> Q;  // {cost[u], u}

cost[0] = 0;
Q.push({0, 0});

LL peso_totale = 0;

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

Consideriamo il seguente grafo:

#figure(
  canvas({
    let nodes = ((0.25, 1.5), (1.5, 0), (1.5, 3), (2.75, 1.5), (4, 0), (4, 3), (5.25, 1.5))
    let edges = ((0, 1, 7), (0, 2, 2), (2, 3, 3), (1, 3, 1), (2, 5, 5), (1, 4, 8), (3, 6, 4), (4, 6, 2), (5, 6, 2))

    draw_graph(nodes, edges, rad: 10pt)
  })
)

Procediamo passo passo seguendo l'algoritmo di Prim. 
Ogni volta prenderemo l'arco di peso minimo che connette un nodo preso (in rosso) e uno non preso.
Cominceremo scegliendo arbitrariamente il nodo $0$ come nodo preso.

#v(2em)

#[

#let nodes = ((0.25, 1.5), (1.5, 0), (1.5, 3), (2.75, 1.5), (4, 0), (4, 3), (5.25, 1.5))
#for i in range(nodes.len()) {
  nodes.at(i) = scale(nodes.at(i), 0.8)
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
      draw_graph(nodes, edges, rad: 8pt, node_fill: fill)
    })
    Passo $1$: l'arco più piccolo uscente da $0$ è quello verso $2$.
  ],[
    #canvas({
      fill.at("2") = in_color
      fill += ("3": add_color)
      edges += ((2, 3, 3),)
      draw_graph(nodes, edges, rad: 8pt, node_fill: fill)
    })
    Passo $2$: ora l'albero è composto da $0$ e $2$, l'arco minimo uscente è $2->3$ con peso $3$.
  ],[
    #canvas({
      fill.at("3") = in_color
      fill += ("1": add_color)
      edges += ((1, 3, 1),)
      draw_graph(nodes, edges, rad: 8pt, node_fill: fill)
    })
    Passo $3$: l'arco uscente minimo è $3->1$ con peso $1$.
  ],[
    #canvas({
      fill.at("1") = in_color
      fill += ("6": add_color)
      edges += ((3, 6, 4),)
      draw_graph(nodes, edges, rad: 8pt, node_fill: fill)
    })
    Passo $4$: l'arco uscente minimo è $3->6$ con peso $4$.
  ],[
    #canvas({
      fill.at("6") = in_color
      fill += ("4": add_color)
      edges += ((4, 6, 2),)
      draw_graph(nodes, edges, rad: 8pt, node_fill: fill)
    })
    Passo $5$: l'arco uscente minimo è $6->4$ con peso $2$.
  ],[
    #canvas({
      fill.at("4") = in_color
      fill += ("5": add_color)
      edges += ((5, 6, 2),)
      draw_graph(nodes, edges, rad: 8pt, node_fill: fill)
    })
    Passo $6$: l'arco uscente minimo è $6->5$ con peso $2$.
  ],
))]

#v(2em)

Abbiamo ottenuto l'albero che desideravamo. 
Di questo ora sappiamo dire il costo totale (14 in questo caso) e da quali archi è composto. 

==== Algoritmo di Kruskal

L'algoritmo di Kruskal si basa sulla seguente proprietà: dato un albero ricoprente, questo ha peso totale minimo se e soltanto se, per ogni ciclo, gli archi rimasti nell'albero non sono più pesanti di quelli rimossi.

Se la proprietà sopra ti sembra intuitiva, possiamo occuparci dell'algoritmo di Kruskal.
L'albero ricoprente contiene inizialmente i nodi del grafo, ma non contiene archi. L'algoritmo processa gli archi uno alla volta in ordine crescente di peso, e li aggiunge all'albero se e soltanto se questi non creano un ciclo, cioè se connettono due componenti prima non connesse.

// TODO: disegno di esempio

Una domanda naturale è come facciamo a controllare che due nodi siano in componenti diverse ed eventualmente ad unire queste componenti? Viene in soccorso una delle nostre strutture dati preferite: la cosiddetta Union-Find, o DSU.

Per il momento limitiamoci a vedere un esempio con lo stesso grafo usato in precedenza:

#v(2em)

#[

#let nodes = ((0.25, 1.5), (1.5, 0), (1.5, 3), (2.75, 1.5), (4, 0), (4, 3), (5.25, 1.5))
#for i in range(nodes.len()) {
  nodes.at(i) = scale(nodes.at(i), 0.8)
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
      draw_graph(nodes, edges, rad: 8pt)
    })
    Passo $1$: l'arco più piccolo in assoluto è $1->3$ con peso $1$.
  ],[
    #canvas({
      edges += ((0, 2, 2),)
      draw_graph(nodes, edges, rad: 8pt)
    })
    Passo $2$: l'arco (uno dei tre) più piccolo ora è $0->2$ con peso $2$.
  ],[
    #canvas({
      edges += ((6, 5, 2),)
      draw_graph(nodes, edges, rad: 8pt)
    })
    Passo $3$: prendiamo ora l'arco $5->6$ di peso $2$.
  ],[
    #canvas({
      edges += ((6, 4, 2),)
      draw_graph(nodes, edges, rad: 8pt)
    })
    Passo $4$: anche l'arco $4->6$ di peso $2$ viene preso.
  ],[
    #canvas({
      edges += ((2, 3, 3),)
      draw_graph(nodes, edges, rad: 8pt)
    })
    Passo $5$: possiamo aggiungere l'arco $2->3$ di peso $3$.
  ],[
    #canvas({
      edges += ((3, 6, 4),)
      draw_graph(nodes, edges, rad: 8pt)
    })
    Passo $6$: l'ultimo arco che prendiamo è $3->6$ con peso $4$.
  ],
))]

#v(2em)

Gli ultimi due archi in ordine di peso non connettono nodi che non siano già connessi fra loro, dunque non prendiamo altri archi.

Notare che gli archi sono stati aggiunti in ordine di peso e che, a differenza di prim, stavamo connettendo più gruppi di nodi contemporaneamente.

L'albero risultante da questo altro algoritmo è lo stesso di Prim ma non è sempre così.
La garanzia che abbiamo è che entrambi producano un albero ricoprente il cui peso è minimo tra tutti i possibili alberi ricoprenti.

// TODO: === Ordinamento topologico (direi nella sezione OII non terry)

