#import "../../utils/problems.typ": *
#import "@preview/cetz:0.4.2": *
#import "@preview/cetz-plot:0.1.2": *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *



== Alberi

Dopo aver introdotto i grafi e alcuni algoritmi utili per ricavare informazioni da essi, vale la pena concentrarsi su un tipo particolare di grafo: l'_albero_.

#figure(
  canvas({
    import "../../utils/draw_graph.typ": *
    
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

    draw_graph(nodes, edges)
  }),
  caption: [Un esempio di albero con $6$ nodi],
)

Un albero è un grafo connesso con esattamente $N - 1$ archi, dove $N$ è il numero di nodi.

// forse direi "un grafo è un albero se vale una delle seguenti definizioni equivalenti: ..."
Questo fatto implica diverse proprietà, la più importante delle quali è che gli alberi non contengono cicli#footnote([Si può dimostrare facilmente per induzione.]). 
Ciò implica a sua volta che tra due nodi dell'albero esiste un solo cammino che li collega. 
È bene notare che vale anche l'implicazione inversa, cioè se un grafo è connesso e aciclico, allora è un albero ed ha esattamente $N - 1$ archi.

Grazie all'unicità del cammino tra ogni coppia di nodi, spesso un problema su alberi si risolve in maniera più efficiente rispetto allo stesso problema su grafi generici.
Ad esempio, puoi trovare il cammino più breve (nonché l'unico!) tra due nodi con una _DFS_ o una _BFS_, anche nel caso in cui gli archi hanno un peso.

Quando un nodo ha grado $1$, ovvero ha un solo arco uscente, viene detto _foglia_. Nell'albero in figura, le foglie sono i nodi $2$, $3$ e $5$. 
Tutti gli alberi con più di un nodo contengono sempre almeno $2$ foglie. 

=== Alberi radicati

Molti algoritmi su albero prevedono la scelta di un nodo speciale, detto _radice_, per dare un ordine all'albero. Se non viene specificata la radice nel testo del problema, la sua scelta è arbitraria#footnote([Solitamente si usa il nodo $0$ o, in contesti $1$-based, il nodo $1$.]).

La scelta di una radice permette di definire per tutti i nodi a meno della radice un nodo _genitore_ (in inglese _parent node_). Il genitore del nodo $i$ è l'ultimo nodo che si visita muovendosi dalla radice al nodo $i$. 
Si dice inoltre che un nodo $j$ è _figlio_ del nodo $i$ se $i$ è il genitore di $j$.

Nell'albero sopra illustrato, prendendo come radice il nodo $0$, si ha per esempio che i nodi $2$ e $3$ sono figli del nodo $1$, mentre il nodo $4$ è il genitore del nodo $5$.
L'array $P$ tale per cui $P[i]$ contiene il genitore del nodo $i$ (o $-1$ se il nodo $i$ è la radice) è detto _parent array_. 
Il parent array dell'albero sopra, radicato in $0$, sarebbe $[-1, 0, 1, 1, 0, 4]$.

La profondità di un nodo è il numero di archi che lo separano dalla radice. La profondità della radice è $0$. Nell'esempio sopra, i nodi $1$ e $4$ sono a profondità $1$ mentre i nodi $2, 3$ e $5$ sono a profondità $2$.
I nodi a profondità massima in un albero sono sempre foglie.

Gli _antenati_ di un nodo $i$ sono i nodi sul cammino dalla radice fino al nodo stesso. Gli antenati del nodo $5$ nell'esempio sopra sono i nodi $4$ e $1$. Il più basso antenato comune di due nodi $i$ e $j$, in inglese _lowest common ancestor_ (_LCA_), è il nodo $k$ alla massima profondità che è antenato sia di $i$ che di $j$: diremo $"LCA"(i, j) = k$. 
Se $i$ è antenato di $j$, l'_LCA_ è $i$. Vice versa se $j$ è antenato di $i$.
Nell'esempio sopra $"LCA"(2, 3) = 1$, $"LCA"(2, 5) = 0$ e $"LCA"(0, 3) = 0$.

Trovare l'_LCA_ tra due nodi è estremamente utile per svolgere numerose query su albero. Vedremo in futuro come calcolarlo in maniera efficiente.

Un ultimo concetto utile nell'ambito degli alberi radicati è quello di _sottoalbero_: il sottoalbero di un nodo $i$ è l'insieme di tutti i nodi che hanno $i$ tra gli antenati, $i$ compreso.

=== Alberi particolari

Alcuni tipi di albero particolari assumono nomi specifici:

#grid(
  columns: (1fr, 1fr, 1fr),
  rows: 2,
  gutter: 2em,
  align: center,
  [
    #import "../../utils/draw_graph.typ": *
    #canvas({

      let rad = 20pt * calc.sqrt(2)
      let N = 4
      let nodes = ()
      let edges = ()

      for i in range(N) {
        nodes.push((i * rad, i * rad))
        if i > 0 { 
          edges.push((i - 1, i)) 
        }
      }

      draw_graph(nodes, edges, rad: 10pt)
    })
  ],[
    #import "../../utils/draw_graph.typ": *
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
      let nodes = ((0, 0), (-1, -1.5), (1, -1.5), (-1.5, -3), (-0.5, -3), (0.5, -3), (1.5, -3))
      let edges = ((0, 1), (0, 2), (1, 3), (1, 4), (2, 5), (2, 6))

      draw_graph(nodes, edges, rad: 10pt)
    })
  ],
  [_Linea con $4$ nodi_],
  [_Stella con centro $0$_],
  [_Abero binario completo con $7$ nodi_],
)

//#align(center)[
//  #import "../../utils/draw_graph.typ": *
//  #canvas({
//    let nodes = ((0, 0), (0, 3), (3, 0), (-3, 0), (0, -3), (-3, -3), (3, -3), (-3, 3), (3, 3))
//    let edges = ((0, 1), (0, 2), (0, 3), (0, 4), (1, 7), (2, 8), (4, 6), (3, 5))
//    draw_graph(nodes, edges)  
//  })
//]

Le _linee_ sono alberi in cui ogni nodo ha grado $1$ o $2$; questa condizione è sufficiente a verificare che l'albero sia una linea.
Le _stelle_ hanno un solo nodo con grado maggiore di $1$. Questo nodo è detto _centro_ della stella e tutti gli altri nodi sono adiacenti ad esso. 
Negli _alberi binari_ ogni nodo ha al più due figli. Spesso questo tipo di albero viene utilizzato per strutture dati come _segment tree_ e _alberi binari di ricerca_. 

=== Visite su albero

Come per i grafi generici, un albero può essere esplorato attraverso _BFS_ e _DFS_. 

```cpp
void dfs(int i, int parent) {
    // esploro il nodo i
    for (int j: adj[i])
        if (j != parent)
            dfs(j, i);
}
```

Poiché esploriamo un albero, non è necessario tenere traccia dei nodi visitati ed è sufficiente non risalire verso il genitore. L'ordine in cui si visitano i nodi attraverso una visita in profondità è detto _dfs-order_. Per come funziona la _DFS_, il dfs-order trasforma sottoalberi in sottoarray. Il dato di un dfs-order e, per ogni nodo, il relativo sottoarray è detto _albero linearizzato_#footnote[Tieni a mente questo concetto per quando saremo capaci di svolgere operazioni interessanti su sequenze di numeri.].

Vediamo un problema in cui serve visitare ricorsivamente l'albero.

#problem("Convegno Aziendale", url: "https://training.olinfo.it/task/mat_convegno", lbl: "convegno")[
  Ci viene dato l'albero delle gerarchie tra gli $N$ dipendenti di un'azienda e siamo interessati al numero di coppie di dipendenti $(a, b)$ tali che $a$ è antenato di $b$ nella gerarchia.
]

Al posto di provare tutte le coppie, possiamo fissare $a$. 
Per un dato $a$, il numero di coppie che ci interessano è dato dalla dimensione del sottoalbero di $a$ tolto il nodo $a$ stesso. 
Notiamo che il sottoalbero è ben definito dal momento che l'albero è radicato.

Sia $S_i$ la dimensione del sottoalbero del nodo $i$. 
Per calcolarla sommiamo gli $S_j$ dove $j$ è un nodo figlio di $i$.

È chiaro che questo tipo di calcolo vada eseguito ricorsivamente dal momento che per calcolare la dimensione del sottoalbero di un nodo devo aver prima calcolato quella dei figli. 

```cpp
vector<vector<int>> adj;
int totale = 0;

int dfs(int i) {
    int sottoalbero = 0;
    for (int j: adj[i]) {
        sottoalbero += dfs(j);
    }
    totale += sottoalbero;
    return sottoalbero + 1;
}

int coppie(int N, int* C) {
    adj.resize(N);
    int root;
	  for (int i = 0; i < N; i++) {
        if (C[i] != -1) {
            adj[C[i]].push_back(i);
        } else {
            root = i;
        }
    }
    dfs(root);
    return totale;
}
```
