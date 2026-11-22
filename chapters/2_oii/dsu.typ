#import "/templates/page.typ": project
#import "/utils/render.typ": is-web

#let render = if is-web { project.with(title: "DSU (Disjoint Set Union)") } else { it => it }
#show: render

#import "../../utils/problems.typ": *
#import "../../utils/exercises.typ": exercise
#import "../../utils/cetz.typ": canvas
#import "../../utils/draw_graph.typ": *


== DSU (Disjoint Set Union) <dsu>

La _DSU_ (_Disjoint Set Union_), chiamata anche _Union-Find_, è una struttura dati che mantiene una partizione di un insieme in sottoinsiemi disgiunti. Supporta due operazioni: unire due sottoinsiemi e verificare se due elementi appartengono allo stesso sottoinsieme. È una delle strutture dati più usate nella programmazione competitiva.

Vediamo un esempio di problema e come risolverlo con una DSU.

=== Il problema

#problem("Componenti connesse", lbl: "dsu-components")[
  Ci vengono dati $N$ nodi numerati da $0$ a $N - 1$, ognuno isolato dagli altri. Dobbiamo supportare le seguenti operazioni:
  - `merge(i, j)`: crea un arco non diretto tra `i` e `j`;
  - `are_connected(i, j)`: restituisce `1` se `i` e `j` sono nella stessa componente connessa, `0` altrimenti.
][]

=== Approccio 1: ricalcolare la connettività

Rappresentiamo il grafo tramite una lista di adiacenza e ricalcoliamo ad ogni query il valore richiesto:
- `merge(i, j)` inserisce due archi nella lista di adiacenza, quindi costa $cal(O)(1)$;
- `are_connected(i, j)` esegue una BFS (o una DFS) da `i` e restituisce `1` se raggiunge `j`, altrimenti `0`. Nel caso peggiore visita tutti i nodi e tutti gli archi della componente, quindi costa $cal(O)(N + M)$, dove $M$ è il numero di archi aggiunti finora.

Con $Q$ operazioni, il caso pessimo costa $cal(O)(Q(N + Q))$, che per $N, Q <= 10^6$ è ben oltre il limite di tempo. Serve qualcosa di più furbo.

=== Approccio 2: DSU

Usiamo una DSU. Con le opportune ottimizzazioni, entrambe le operazioni avranno costo ammortizzato $cal(O)(alpha(N))$, che per ogni valore realistico di $N$ è al più 4: in pratica si comportano come operazioni costanti.

L'idea è mantenere, per ogni componente connessa, un nodo rappresentante che chiameremo _root_. Definiamo una funzione `root(i)` (spesso chiamata `find(i)` in altre implementazioni) che per ogni nodo `i` restituisce la root della sua componente. Due nodi sono connessi se e solo se hanno la stessa root:
- `are_connected(i, j)` diventa `return root(i) == root(j)`;
- `merge(i, j)` collega le componenti di `i` e `j`, quindi ha lo stesso effetto di unire `root(i)` e `root(j)`. Basta scegliere una delle due root come rappresentante della nuova componente e far diventare l'altra sua figlia.

Spostiamo ora la nostra attenzione su `root(i)`.
È possibile aggiornarla velocemente rappresentando ogni componente connessa come un albero e non più come un grafo (a questo punto il significato di _root_ diventa apparente).

Rappresentiamo le componenti con un array `parent` di $N$ interi. All'inizio ogni nodo è root di sé stesso:

```cpp
vector<int> parent(N);
for (int i = 0; i < N; i++) parent[i] = i;
```

Ogni componente è un albero e la sua root è la radice dell'albero.
Se un nodo non è una root, `parent[i]` è il nodo successivo nel cammino verso la root; le root hanno `parent[i] = i`. 
Per trovare la root di `i` seguiamo i puntatori finché non arriviamo a un nodo che punta a sé stesso:

```cpp
int root(int i) {
    while (parent[i] != i) i = parent[i];
    return i;
}
```

A questo punto le due operazioni sono immediate:

```cpp
bool are_connected(int i, int j) {
    return root(i) == root(j);
}

void merge(int i, int j) {
    int ri = root(i), rj = root(j);
    if (ri != rj) parent[rj] = ri;
}
```

Se le root sono diverse, colleghiamo una root all'altra e i due alberi diventano un'unica componente. Se sono uguali, l'arco è ridondante e non cambia nulla. La scelta di quale root diventa figlia dell'altra è arbitraria in questa versione; tra poco la ottimizzeremo.


#let dsu-nodes = ((0, 2.7), (-2.1, 1.4), (0, 1.4), (0, 0.1), (2.1, 1.4), (2.1, 0.1))

#let dsu-step(label, parent, root, edges) = [
  #text(size: 0.9em)[#label]
  #v(0.1em)
  #canvas({
    let fill = (:)
    for i in range(6) {
      fill += (str(i): if root.at(i) == i { rgb("#9aff6c") } else { rgb("#ffac8b") })
    }
    draw_graph(dsu-nodes, edges, directed: true, rad: 9pt, node_fill: fill)
  })
  #v(0.2em)
  #text(size: 0.8em, font: "DejaVu Sans Mono")[
    parent = \[#parent.map(str).join(", ")\] \
    root   = \[#root.map(str).join(", ")\]
  ]
]

#figure(
  grid(
    columns: (1fr, 1fr),
    rows: 3,
    gutter: 1.2em,
    align: center + horizon,
    dsu-step([#text("1.")#h(0.3em)*Inizio*], (0, 1, 2, 3, 4, 5), (0, 1, 2, 3, 4, 5), ()),
    dsu-step([#text("2.")#h(0.3em)#text(font: "DejaVu Sans Mono")[merge(0, 1)]], (0, 0, 2, 3, 4, 5), (0, 0, 2, 3, 4, 5), ((1, 0),)),
    dsu-step([#text("3.")#h(0.3em)#text(font: "DejaVu Sans Mono")[merge(2, 3)]], (0, 0, 2, 2, 4, 5), (0, 0, 2, 2, 4, 5), ((1, 0), (3, 2))),
    dsu-step([#text("4.")#h(0.3em)#text(font: "DejaVu Sans Mono")[merge(1, 2)]], (0, 0, 0, 2, 4, 5), (0, 0, 0, 0, 4, 5), ((1, 0), (2, 0), (3, 2))),
    dsu-step([#text("5.")#h(0.3em)#text(font: "DejaVu Sans Mono")[merge(4, 5)]], (0, 0, 0, 2, 4, 4), (0, 0, 0, 0, 4, 4), ((1, 0), (2, 0), (3, 2), (5, 4))),
    dsu-step([#text("6.")#h(0.3em)#text(font: "DejaVu Sans Mono")[merge(0, 4)]], (0, 0, 0, 2, 0, 4), (0, 0, 0, 0, 0, 0), ((1, 0), (2, 0), (3, 2), (4, 0), (5, 4))),
  ),
  caption: [Esempio di DSU. I nodi verdi sono le root delle componenti.],
)

#v(5pt)
La forma della foresta dipende dall'ordine dei merge: la figura mostra una sequenza favorevole, ma non è sempre così.

Il costo di `are_connected` e `merge` è dominato dal costo di `root`. Nel caso pessimo la foresta può diventare una catena lunga $N$: con la convenzione `parent[rj] = ri`, la sequenza

```cpp
merge(1, 0); merge(2, 1); merge(3, 2); ...
```

crea la catena $0 -> 1 -> 2 -> dots -> N - 1$. Allora `root(0)` percorre $N - 1$ puntatori e costa $cal(O)(N)$. Una sequenza di $Q$ operazioni può quindi costare $cal(O)(N Q)$, che è decisamente troppo.

L'idea per migliorare la complessità è semplice: dobbiamo mantenere gli alberi più bassi possibile.

=== Ottimizzazioni

Due idee rendono la DSU efficiente: mantenere gli alberi bassi e comprimere i cammini.

==== Union by size

Manteniamo per ogni root la dimensione `size[r]` della sua componente. Quando uniamo due componenti, attacchiamo la root dell'albero più piccolo sotto quella dell'albero più grande:

```cpp
vector<int> size(N, 1);

void merge(int i, int j) {
    int ri = root(i), rj = root(j);
    if (ri == rj) return;
    if (size[ri] < size[rj]) swap(ri, rj);
    parent[rj] = ri;
    size[ri] += size[rj];
}
```

`size[i]` ha significato solo se `i` è una root; per gli altri nodi può essere lasciato stare. 
Con questa regola, la profondità di un nodo aumenta di $1$ solo quando la sua componente viene unita a una componente almeno grande quanto la sua, quindi la dimensione della componente almeno raddoppia.
Un nodo può essere spostato in questo modo al più $log_2 N$ volte, quindi la profondità è al più $log_2 N$ e `root` costa $cal(O)(log N)$.

(In alcuni libri o articoli, al posto della dimensione viene usato il _rango_, ovvero un limite superiore all'altezza dell'albero, ma l'esito è uguale)

==== Path compression

Anche con union by size, ogni `root` percorre un cammino di lunghezza $cal(O)(log N)$. Possiamo sfruttare questi attraversamenti: quando `root(i)` arriva alla root, facciamo puntare direttamente alla root tutti i nodi visitati.

```cpp
int root(int i) {
    if (parent[i] == i) return i;
    parent[i] = root(parent[i]);
    return parent[i];
}
```
Consigliamo di prendere un attimo per digerire il funzionamento di questa funzione.

#figure(grid(
  columns: (1fr, 1fr),
  rows: 2,
  gutter: 1.5em,
  align: center + horizon,
  [
    #canvas({
      let nodes = ((0, 3), (-0.8, 1.5), (0.8, 0), (-0.8, -1.5))
      let edges = ((1, 0), (2, 1), (3, 2))
      let fill = (
        "0": rgb("#9aff6c"),
        "1": rgb("#ffac8b"),
        "2": rgb("#ffac8b"),
        "3": rgb("#ffac8b"),
      )
      draw_graph(nodes, edges, directed: true, rad: 9pt, node_fill: fill)
    })
  ],
  [
    #canvas({
      let nodes = ((0, 3), (-1.6, 1), (0, 1), (1.6, 1))
      let edges = ((1, 0), (2, 0), (3, 0))
      let fill = (
        "0": rgb("#9aff6c"),
        "1": rgb("#ffac8b"),
        "2": rgb("#ffac8b"),
        "3": rgb("#ffac8b"),
      )
      draw_graph(nodes, edges, directed: true, rad: 9pt, node_fill: fill)
    })
  ],
  [_Prima: `root(3)` percorre $3 -> 2 -> 1 -> 0$._],
  [_Dopo: i nodi visitati puntano direttamente alla root $0$._],
))

==== Complessità finale

#figure(
  table(
    columns: (auto, auto),
    align: (left, center),
    table.header([*Versione*], [*Costo per operazione*]),
    [Nessuna ottimizzazione], [$cal(O)(N)$],
    [Solo union by size], [$cal(O)(log N)$],
    [Solo path compression], [$cal(O)(log N)$ ammortizzato],
    [Union by size + path compression], [$cal(O)(alpha(N))$ #footnote[La funzione $alpha$ è l'inversa della funzione di Ackermann. Vale $alpha(10^100) < 5$, quindi per i nostri scopi è praticamente costante.]],
  ),
  caption: [Complessità delle varie versioni della DSU.],
)

=== Implementazione

L'implementazione che useremo contiene entrambe le ottimizzazioni. `merge` restituisce `true` se le due componenti sono state unite e `false` se erano già connesse. `components` contiene il numero di componenti connesse e `component_size(i)` restituisce la dimensione della componente di `i`.
```cpp
struct DSU {
    vector<int> parent, size;
    int components;

    DSU(int n) {
        parent.resize(n);
        size.assign(n, 1);
        components = n;
        for (int i = 0; i < n; i++) parent[i] = i;
    }

    int root(int i) {
        if (parent[i] == i) return i;
        return parent[i] = root(parent[i]);
    }

    bool are_connected(int i, int j) {
        return root(i) == root(j);
    }

    bool merge(int i, int j) {
        int ri = root(i), rj = root(j);
        if (ri == rj) return false;
        if (size[ri] < size[rj]) swap(ri, rj);
        parent[rj] = ri;
        size[ri] += size[rj];
        components--;
        return true;
    }

    int component_size(int i) {
        return size[root(i)];
    }
};
```
=== Applicazioni

La DSU è utile ogni volta che serve mantenere una partizione che cambia solo per unioni:
- *MST (Kruskal)*: si ordinano gli archi per peso e si aggiunge un arco solo se `merge(u, v)` restituisce `true`, cioè se collega due componenti diverse.
- *Informazioni aggregate*: si possono mantenere somma, minimo, massimo o altre informazioni per componente, aggiornandole quando si uniscono due root.
- *Varianti avanzate*: una DSU con parità gestisce i grafi bipartiti; una DSU con rollback permette di annullare un'unione, etc.


=== Problemi consigliati

#exercise("Road Construction", "https://cses.fi/problemset/task/1676", diff: 1)
#exercise("Network Breakdown", "https://cses.fi/problemset/task/1677", diff: 3)
