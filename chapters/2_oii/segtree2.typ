#import "/templates/page.typ": project
#import "/utils/render.typ": is-web

#let render = if is-web { project.with(title: "Segment tree con lazy propagation") } else { it => it }
#show: render

#import "../../utils/problems.typ": *
#import "../../utils/ref.typ": crossref
#import "../../utils/cetz.typ": canvas
#import "../../utils/palette.typ": *
#import "@preview/cetz:0.4.2": draw

#let lazy-yellow = rgb("#ffff66")
#let lazy-active = rgb("#f5a79f")
#let lazy-query = rgb("#ef8b8b")
#let lazy-green = rgb("#4caf50")
#let lazy-blue = rgb("#a9c4e4")
#let lazy-indicator = rgb("#8aee8a")

// Nodi del segment tree, dal livello della radice a quello delle foglie.
#let lazy-pos = (
  (0, 4.5),
  (-3.4, 3), (3.4, 3),
  (-5.1, 1.5), (-1.7, 1.5), (1.7, 1.5), (5.1, 1.5),
  (-5.95, 0), (-4.25, 0), (-2.55, 0), (-0.85, 0),
  (0.85, 0), (2.55, 0), (4.25, 0), (5.95, 0),
)

#let lazy-edges = (
  (0, 1), (0, 2),
  (1, 3), (1, 4), (2, 5), (2, 6),
  (3, 7), (3, 8), (4, 9), (4, 10),
  (5, 11), (5, 12), (6, 13), (6, 14),
)

#let lazy-leaves = range(7, 15)
#let lazy-node-size = (1.45, 0.72) // in centimetri, come le coordinate di CeTZ

#let draw-lazy-tree(labels, fills: (:), indicators: (:), highlight: none, bottom: none) = {
  for (a, b) in lazy-edges {
    draw.line(lazy-pos.at(a), lazy-pos.at(b), stroke: 0.7pt + black)
  }

  if highlight != none {
    let (from, to) = highlight
    let y = lazy-node-size.at(1) / 2 + 0.12
    draw.rect(
      (lazy-pos.at(from).at(0) - lazy-node-size.at(0) / 2 - 0.1, -y),
      (lazy-pos.at(to).at(0) + lazy-node-size.at(0) / 2 + 0.1, y),
      radius: 1pt,
      stroke: 1.5pt + lazy-green,
      fill: none,
    )
  }

  for i in range(labels.len()) {
    let fill = fills.at(str(i), default: if i in lazy-leaves { lazy-yellow } else { white })
    draw.content(lazy-pos.at(i), box(
      width: lazy-node-size.at(0) * 1cm,
      height: lazy-node-size.at(1) * 1cm,
      fill: fill,
      stroke: 0.7pt + black,
      inset: 0pt,
      align(center + horizon)[#text(size: 10pt)[#labels.at(i)]],
    ))
  }

  // Indicatore dell'update lazy: blu se spento, verde con "+5" se acceso.
  for i in range(labels.len()) {
    let p = lazy-pos.at(i)
    let c = (p.at(0) + lazy-node-size.at(0) / 2, p.at(1) + lazy-node-size.at(1) / 2)
    let indicator = indicators.at(str(i), default: none)
    if indicator == none {
      draw.circle(c, radius: 4pt, fill: lazy-blue, stroke: 0.7pt + black)
    } else {
      draw.circle(c, radius: 6pt, fill: lazy-indicator, stroke: 0.7pt + black)
      draw.content(c, text(size: 8pt)[#indicator])
    }
  }

  if bottom != none {
    draw.content((0, -1.1), text(size: 13pt)[#bottom])
  }
}


== Segment tree con lazy propagation <segtree2>

Abbiamo visto che un #crossref(<segtree>, "/chapters/2_oii/segtree.typ", [segment tree]) permette query su range e update su un solo elemento, o viceversa.

Supponiamo di avere questo problema:
#problem("Range sum con range add", lbl: "range-add")[
  Ci è dato un array $A$ di $N$ interi ($N <= 10^6$) e dobbiamo eseguire $Q$ operazioni ($Q <= 10^6$): o una query sulla somma del range $[l, r)$, oppure aggiungere $X$ agli elementi nel range $[l, r)$.
][]
possiamo ancora usare un segment tree?

Se manteniamo un segment tree che permette solo point update, aumentare tutti gli elementi di un range costerebbe $cal(O)(N)$ update da $cal(O)(log N)$ ciascuno, ovvero $cal(O)(N log N)$. Ma abbiamo detto che costruire da capo il segment tree impiega $cal(O)(N)$. C'è qualcosa che non va: se facciamo gli update in $cal(O)(N)$ allora possiamo tenere le somme prefisse dell'array, che permettono di sommare un range in $cal(O)(1)$.

Possiamo fare di meglio? Ovviamente sì.

=== Perché "lazy"?

L'idea principale è la seguente:

#box(fill: example_bg, inset: 8pt, radius: 3pt)[Un update su range modifica $cal(O)(N)$ nodi, ma abbiamo detto che ogni query ne visita al massimo $cal(O)(log N)$: possiamo quindi pensare di modificare i nodi man mano che questi vengono visitati da una query.]

Se un range è rappresentato da un insieme di segmenti, allo stesso modo di una query, per un update raggiungiamo i nodi corrispondenti con una DFS e modifichiamo il valore di quel nodo secondo quanto richiesto: se ad esempio stiamo incrementando di 5 e raggiungiamo un nodo corrispondente a un range totalmente incluso nell'intervallo dell'update, possiamo stabilire che il valore di quel nodo dovrà essere incrementato di 5 moltiplicato per la lunghezza del range, visto che ogni elemento viene incrementato di 5.

#figure(canvas({
  draw-lazy-tree((
    "77", "29", [28$+$4$times$5], "9", [10$+$2$times$5], "15", "13",
    "3", "6", "8", "2", "5", "10", "7", "6",
  ), fills: (
    "2": lazy-active,
    "4": lazy-active,
  ), indicators: (
    "2": "5",
    "4": "5",
  ), highlight: (9, 14), bottom: "+5")
}))

Nell'immagine, i nodi interessati dall'update sono colorati in rosa. È stato aggiunto un indicatore a ciascun nodo: quando è "acceso" significa che quel nodo è stato modificato e, quando verrà visitato, l'update dovrà essere propagato ai figli.

Nel frattempo, ogni volta che termina la chiamata ricorsiva sui figli, il valore del nodo viene aggiornato alla somma dei figli, in modo che anche i nodi sopra vengano aggiornati.

Come per le query, la complessità dell'update sarà $cal(O)(log N)$.

Quando una query utilizzerà il valore di quel nodo non ci sono problemi, ma cosa succede se vengono visitati nodi nel suo sottoalbero, che quindi non sono ancora stati modificati?

=== Propagazione dell'update

Visitare un nodo implica aver visitato quelli che stanno sopra. Di conseguenza, quando incontriamo un nodo ancora da aggiornare, modifichiamo il suo valore e propaghiamo sui figli l'update, controllando prima di non essere in una foglia. Questa operazione richiede tempo costante perché il numero di figli è sempre 2 e, siccome ciascuna query visita $cal(O)(log N)$ nodi, dovremo effettuare al massimo $cal(O)(log N)$ update ogni volta. Questo garantisce la stessa efficienza di un segment tree "normale", ma permette di fare update su range.

#figure(canvas({
  draw-lazy-tree((
    "77", "29", "48", "9", "20", [15$+$2$times$5], [13$+$2$times$5],
    "3", "6", "8", "2", "5", "10", "7", "6",
  ), fills: (
    "1": lazy-query,
    "5": lazy-query,
  ), indicators: (
    "4": "5",
    "5": "5",
    "6": "5",
  ), highlight: (7, 12))
}))

Nell'esempio sopra la query interessa i nodi evidenziati in rosa. Quello a sinistra era già stato modificato durante l'update, mentre nell'altro caso per arrivare al nodo che ci interessa dobbiamo passare per un nodo modificato. Quello che facciamo allora è propagare l'update ai due figli e proseguire con la visita.

Come detto in precedenza, propagare l'update ha complessità $cal(O)(1)$, quindi la complessità della query rimane invariata.

=== Implementazione

Una prima differenza è che, siccome per ogni nodo dovremo tenere più informazioni (la somma e l'eventuale update da propagare), risulta conveniente creare una `struct node` come segue:

```cpp
struct node {
    long long sum = 0;
    long long lazy_update = 0;
};
```

quindi modificheremo leggermente anche il costruttore e la funzione `build`. Per il primo dovremo ricordarci di creare un `vector<node>`, mentre quando costruiamo l'albero andremo a modificare l'attributo `sum` (ad esempio `st[i].sum = A[left]`).

La vera novità è la procedura `propagate`.

```cpp
// Riceve un nodo e propaga l'update
void propagate(int i, int left, int right) {

    if (st[i].lazy_update == 0) return; // Nulla da propagare

    // Aggiungiamo l'incremento moltiplicato per la lunghezza del range
    st[i].sum += (right - left) * st[i].lazy_update;

    if (right - left > 1) { // Se non è una foglia si propaga ai figli l'update
        st[2*i].lazy_update += st[i].lazy_update;
        st[2*i+1].lazy_update += st[i].lazy_update;
        // L'update viene sommato a quello dei figli, in caso fossero già
        // presenti altri update da propagare in quei nodi
    }
    // Si resetta l'update lazy del nodo
    st[i].lazy_update = 0;
}
```

Questa procedura verrà chiamata ogni volta che si accede a un nodo facendo una query o un update. Quello che fa è aggiornare un nodo al valore corretto dopo l'update e propagare ai figli il valore da aggiungere.

Per le query ci basterà chiamare `propagate (i, left, right)` come prima cosa, mentre l'update deve essere modificato e reso più simile a una query:

```cpp
void update(int i, int left, int right, int update_left, int update_right, long long val) {
    // Prima di guardare il nodo propago eventuali update
    propagate(i, left, right);

    if (update_left >= right || update_right <= left) {
        return; // Fuori dal range
    }
    if (left >= update_left && right <= update_right) {
        // Il range è totalmente incluso
        // Aggiungo l'update lazy e lo propago in modo da aggiornare il valore del nodo
        st[i].lazy_update = val;
        propagate(i, left, right);
        return;
    }
    // Nel caso generico ricorro sui figli
    int mid = (left + right) / 2;
    update(2*i, left, mid, update_left, update_right, val);
    update(2*i+1, mid, right, update_left, update_right, val);

    // Aggiorno alla somma dei figli
    st[i].sum = st[2*i].sum + st[2*i+1].sum;
}
```

=== Implementazione completa

Ecco l'implementazione completa in C++:

```cpp
struct segtree {

    struct node {
        long long sum = 0;
        long long lazy_update = 0;
    };

    int N;
    vector<node> st;

    long long build (int i, int left, int right, vector<long long> &A) {
        if (right - left == 1) {
            return st[i].sum = A[left];
        }
        int mid = (left + right) / 2;
        st[i].sum = build(2*i, left, mid, A) +
                build(2*i+1, mid, right, A);
        return st[i].sum;
    }

    segtree (vector<long long> &A) {
        N = A.size();
        st.resize (4*N);
        build(1,0,N,A);
    }

    void propagate (int i, int left, int right) {
        if (st[i].lazy_update == 0) return;
        st[i].sum += (right - left) * st[i].lazy_update;
        if (right - left > 1) {
            st[2*i].lazy_update += st[i].lazy_update;
            st[2*i+1].lazy_update += st[i].lazy_update;
        }
        st[i].lazy_update = 0;
    }

    void update (int i, int left, int right, int update_left, int update_right, long long val) {
        propagate (i, left, right);
        if (update_left >= right || update_right <= left) {
            return;
        }
        if (left >= update_left && right <= update_right) {
            st[i].lazy_update = val;
            propagate(i, left, right);
            return;
        }
        int mid = (left + right) / 2;
        update (2*i, left, mid, update_left, update_right, val);
        update (2*i+1, mid, right, update_left, update_right, val);
        st[i].sum = st[2*i].sum + st[2*i+1].sum;
    }

    void update (int update_left, int update_right, long long val) {
        update (1, 0, N, update_left, update_right, val);
    }

    long long query (int i, int left, int right, int query_left, int query_right) {
        propagate (i, left, right);
        if (query_left >= right || query_right <= left) {
            return 0;
        }
        if (left >= query_left && right <= query_right) {
            return st[i].sum;
        }
        int mid = (left + right) / 2;
        return query (2*i, left, mid, query_left, query_right) +
               query (2*i+1, mid, right, query_left, query_right);
    }

    long long query (int query_left, int query_right) {
        return query (1, 0, N, query_left, query_right);
    }
};
```
