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
  - `connect(i, j)`: crea un arco non diretto tra `i` e `j`;
  - `are_connected(i, j)`: restituisce `1` se `i` e `j` sono nella stessa componente connessa, `0` altrimenti.
][]

=== Approccio 1: ricalcolare la connettività

Rappresentiamo il grafo tramite una lista di adiacenza e ricalcoliamo ad ogni query il valore richiesto:
- `connect(i, j)` inserisce due archi nella lista di adiacenza, quindi costa $cal(O)(1)$;
- `are_connected(i, j)` esegue una BFS (o una DFS) da `i` e restituisce `1` se raggiunge `j`, altrimenti `0`. Nel caso peggiore visita tutti i nodi e tutti gli archi della componente, quindi costa $cal(O)(N + M)$, dove $M$ è il numero di archi aggiunti finora.

Con $Q$ operazioni, il caso pessimo costa $cal(O)(Q(N + Q))$, che per $N, Q <= 10^6$ è ben oltre il limite di tempo. Serve qualcosa di più furbo.

=== Approccio 2: DSU

Usiamo una DSU. Con le opportune ottimizzazioni, entrambe le operazioni avranno costo ammortizzato $cal(O)(alpha(N))$ che, per ogni valore realistico di $N$, è al più 4: in pratica si comportano come operazioni costanti.

L'idea è mantenere, per ogni componente connessa, un nodo rappresentante. Definiamo una funzione `find(i)` che per ogni nodo `i` restituisce il rappresentante della sua componente. Due nodi sono connessi se e solo se hanno lo stesso rappresentante:
- `are_connected(i, j)` diventa `return find(i) == find(j)`;
- `connect(i, j)` collega le componenti di `i` e `j`. Basta scegliere uno dei due rappresentanti, diciamo $i$, come rappresentante della nuova componente e fare in modo che $j$ non sia più rappresentato da sé stesso ma da $i$.

Spostiamo ora la nostra attenzione su `find(i)`.
È possibile aggiornarla velocemente rappresentando ogni componente connessa come un albero di cui il rappresentate è la radice. 

Rappresentiamo le componenti con un array `parent` di $N$ interi. All'inizio ogni nodo è rappresentante di sé stesso:

```cpp
vector<int> parent(N);
for (int i = 0; i < N; i++) parent[i] = i;
```

L'array `parent` può essere riempito in modo equivalente con la funzione `std::iota` fornita dalla STL, nella libreria `numeric`.

```cpp
iota(parent.begin(), parent.end(), 0);
```

Ogni componente è un albero e la sua radice è la radice dell'albero.
Se un nodo non è una radice, `parent[i]` è il nodo successivo nel cammino verso il rappresentante; le radice hanno `parent[i] = i`. 
Per trovare il rappresentate di `i` seguiamo i puntatori finché non arriviamo a un nodo che punta a sé stesso:

```cpp
int find(int i) {
    while (parent[i] != i) i = parent[i];
    return i;
}
```

A questo punto le due operazioni sono immediate:

```cpp
bool are_connected(int i, int j) { return find(i) == find(j); }
void connect(int i, int j) { if (find(i) != find(j)) parent[find(j)] = find(i); }
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
  #text(size: 0.8em, font: "JetBrains Mono")[
    parent = \[#parent.map(str).join(", ")\] \
    root   = \[#root.map(str).join(", ")\]
  ]
]

#figure(
  box(inset: 1em, grid(
    columns: (1fr, 1fr),
    rows: 3,
    gutter: 3em,
    align: center + horizon,
    dsu-step([#text("1. ")*Inizio*], (0, 1, 2, 3, 4, 5), (0, 1, 2, 3, 4, 5), ()),
    dsu-step([#text("2. ")#text(size: .9em, font: "JetBrains Mono")[connect(0, 1)]], (0, 0, 2, 3, 4, 5), (0, 0, 2, 3, 4, 5), ((1, 0),)),
    dsu-step([#text("3. ")#text(size: .9em, font: "JetBrains Mono")[connect(2, 3)]], (0, 0, 2, 2, 4, 5), (0, 0, 2, 2, 4, 5), ((1, 0), (3, 2))),
    dsu-step([#text("4. ")#text(size: .9em, font: "JetBrains Mono")[connect(1, 2)]], (0, 0, 0, 2, 4, 5), (0, 0, 0, 0, 4, 5), ((1, 0), (2, 0), (3, 2))),
    dsu-step([#text("5. ")#text(size: .9em, font: "JetBrains Mono")[connect(4, 5)]], (0, 0, 0, 2, 4, 4), (0, 0, 0, 0, 4, 4), ((1, 0), (2, 0), (3, 2), (5, 4))),
    dsu-step([#text("6. ")#text(size: .9em, font: "JetBrains Mono")[connect(0, 4)]], (0, 0, 0, 2, 0, 4), (0, 0, 0, 0, 0, 0), ((1, 0), (2, 0), (3, 2), (4, 0), (5, 4))),
  )),
  caption: [Esempio di DSU. I nodi verdi sono le root delle componenti.],
)

#v(5pt)
La forma della foresta dipende dall'ordine delle unioni: la figura mostra una sequenza favorevole, ma non è sempre così.

Il costo di `are_connected` e `connect` è dominato dal costo di `find`. Nel caso pessimo la foresta può diventare una catena lunga $N$: con la convenzione `parent[find(j)] = find(i)`, la sequenza

```cpp
connect(1, 0); connect(2, 1); connect(3, 2); ...
```

crea la catena $0 -> 1 -> 2 -> dots -> N - 1$. Allora `find(0)` percorre $N - 1$ puntatori e costa $cal(O)(N)$. Una sequenza di $Q$ operazioni può quindi costare $cal(O)(N Q)$, che è decisamente troppo.

L'idea per migliorare la complessità è semplice: dobbiamo mantenere gli alberi più bassi possibile.

=== Ottimizzazioni

Due idee rendono la DSU efficiente: mantenere gli alberi bassi e comprimere i cammini.

==== Union by size

Manteniamo per ogni root la dimensione `size[r]` della sua componente. Quando uniamo due componenti, attacchiamo la root dell'albero più piccolo sotto quella dell'albero più grande:

```cpp
vector<int> size(N, 1);

void connect(int i, int j) {
    int root_i = find(i), root_j = find(j);
    if (ri == rj) return;
    if (size[root_i] < size[root_j]) 
        swap(root_i, root_j);
    parent[root_j] = root_i;
    size[root_i] += size[root_j];
}
```

`size[i]` ha significato solo se `i` è un rappresentate; per gli altri nodi può essere lasciato stare. 
Con questa regola, la profondità di un nodo aumenta di $1$ solo quando la sua componente viene unita a una componente almeno grande quanto la sua, quindi la dimensione della componente almeno raddoppia.
Un nodo può essere spostato in questo modo al più $log_2 N$ volte, quindi la profondità è al più $log_2 N$ e `find` costa $cal(O)(log N)$.

(In alcuni libri o articoli, al posto della dimensione viene usato il _rango_, ovvero un limite superiore all'altezza dell'albero, ma l'esito è uguale)

==== Path compression

Anche con union by size, ogni `find` percorre un cammino di lunghezza $cal(O)(log N)$. Possiamo sfruttare questi attraversamenti: quando `find(i)` arriva alla radice, facciamo puntare direttamente al rappresentate tutti i nodi visitati.

```cpp
int find(int i) {
    if (parent[i] == i) return i;
    parent[i] = find(parent[i]);
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
      let nodes = ((0.8, 3), (-0.8, 2), (0.8, 1), (-0.8, 0))
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
  [_Prima:_ `find(3)` _percorre $3 -> 2 -> 1 -> 0$._],
  [_Dopo: i nodi visitati puntano direttamente a $0$, il rappresentante._],
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

L'implementazione che useremo contiene entrambe le ottimizzazioni. `connect` restituisce `true` se le due componenti sono state unite e `false` se erano già connesse. `components` contiene il numero di componenti connesse e `component_size(i)` restituisce la dimensione della componente di `i`.
```cpp
struct DSU {
    vector<int> parent, size;
    int components;

    DSU(int n) : parent(n), size(n, 1), components(n) {
        iota(parent.begin(), parent.end(), 0);
    }

    int find(int i) {
        if (parent[i] == i) return i;
        return parent[i] = find(parent[i]);
    }

    bool connect(int i, int j) {
        int ri = find(i), rj = find(j);
        if (ri == rj) return false;
        if (size[ri] < size[rj]) swap(ri, rj);
        parent[rj] = ri;
        size[ri] += size[rj];
        components--;
        return true;
    }

    bool are_connected(int i, int j) { return find(i) == find(j); }

    int component_size(int i) { return size[find(i)]; }
};
```

Una forma alternativa per scrivere la funzione `find` in modo più conciso è la seguente, che fa uso dell'operatore ternario.

```cpp
int find(int i) {
    return parent[i] == i ? i : parent[i] = find(parent[i]);
}
```

=== Applicazioni

La DSU è utile ogni volta che serve mantenere una partizione che cambia solo per unioni:
- *MST (Kruskal)*: si ordinano gli archi per peso e si aggiunge un arco solo se `connect(u, v)` restituisce `true`, cioè se collega due componenti diverse.
- *Informazioni aggregate*: si possono mantenere somma, minimo, massimo o altre informazioni per componente, aggiornandole quando si uniscono due root.
- *Varianti avanzate*: una DSU con parità gestisce i grafi bipartiti; una DSU con rollback permette di annullare un'unione, etc.


=== Problemi consigliati

#exercise("Connessioni di rete", "https://training.olinfo.it/task/connessioni", diff: 1)
#exercise("Road Construction", "https://cses.fi/problemset/task/1676", diff: 1)
#exercise("Network Breakdown", "https://cses.fi/problemset/task/1677", diff: 3)
