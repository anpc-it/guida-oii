#import "/templates/page.typ": project
#import "/utils/render.typ": is-web

#let render = if is-web { project.with(title: "Segment tree") } else { it => it }
#show: render

#import "../../utils/problems.typ": *
#import "../../utils/palette.typ": *
#import "../../utils/cetz.typ": canvas
#import "@preview/cetz:0.4.2": draw

#let seg-yellow = rgb("#ffff66")
#let seg-update = rgb("#f5a79f")
#let seg-query = rgb("#ef8b8b")
#let seg-green = rgb("#4caf50")

// Nodi del segment tree, dal livello della radice a quello delle foglie.
#let seg-pos = (
  (0, 4.5),
  (-3.4, 3), (3.4, 3),
  (-5.1, 1.5), (-1.7, 1.5), (1.7, 1.5), (5.1, 1.5),
  (-5.95, 0), (-4.25, 0), (-2.55, 0), (-0.85, 0),
  (0.85, 0), (2.55, 0), (4.25, 0), (5.95, 0),
)

#let seg-edges = (
  (0, 1), (0, 2),
  (1, 3), (1, 4), (2, 5), (2, 6),
  (3, 7), (3, 8), (4, 9), (4, 10),
  (5, 11), (5, 12), (6, 13), (6, 14),
)

#let seg-leaves = range(7, 15)
#let seg-node-size = (1.45, 0.72) // in centimetri, come le coordinate di CeTZ

// Etichetta di un nodo aggiornato, per esempio "43 -> 47".
#let upd(from, to) = [$#from -> #to$]

#let draw-segtree(labels, fills: (:), query: none) = {
  for (a, b) in seg-edges {
    draw.line(seg-pos.at(a), seg-pos.at(b), stroke: 0.7pt + black)
  }

  if query != none {
    let (from, to) = query
    let y = seg-node-size.at(1) / 2 + 0.12
    draw.rect(
      (seg-pos.at(from).at(0) - seg-node-size.at(0) / 2 - 0.1, -y),
      (seg-pos.at(to).at(0) + seg-node-size.at(0) / 2 + 0.1, y),
      radius: 3pt,
      stroke: 1.5pt + seg-green,
      fill: none,
    )
  }

  for i in range(labels.len()) {
    let fill = fills.at(str(i), default: if i in seg-leaves { seg-yellow } else { white })
    draw.content(seg-pos.at(i), box(
      width: seg-node-size.at(0) * 1cm,
      height: seg-node-size.at(1) * 1cm,
      fill: fill,
      stroke: 0.7pt + black,
      inset: 0pt,
      align(center + horizon)[#text(size: 10pt)[#labels.at(i)]],
    ))
  }
}


== Segment tree <segtree>

Partiamo dal considerare il seguente problema:

#problem("Range sum con point update", lbl: "range-sum")[
  Ci è dato un array $A$ di $N$ interi ($N <= 10^6$) e dobbiamo eseguire $Q$ operazioni ($Q <= 10^6$): o una query sulla somma del range $[l, r)$, oppure la modifica dell'$i$-esimo elemento dell'array.
][]

*Approccio 1*

Query $cal(O)(N)$ e update $cal(O)(1)$

La prima idea che viene in mente è implementare le richieste in maniera naive, modificando gli elementi nell'array e sommando gli interi di un range con un ciclo `for`. Ci si accorge presto che questa soluzione risulta troppo lenta. Nel caso pessimo (se tutte le operazioni fossero query di somma sull'intero array) verrebbero eseguite circa $10^12$ operazioni: ben oltre quello che ci serve per non fare TLE.

*Approccio 2*

Query $cal(O)(1)$ e update $cal(O)(N)$

Un approccio più sofisticato ma comunque inefficiente è precalcolare le somme prefisse dell'array, in modo da poter rispondere velocemente alle query di somma. Tuttavia, modificare un elemento comporta la modifica di tutte le somme prefisse dalla posizione dell'elemento in poi. Il caso pessimo (solo update sul primo elemento) ha la stessa complessità del precedente approccio, di conseguenza anche questo si rivela poco efficace.

*Approccio 3*

Query $cal(O)(log N)$ e update $cal(O)(log N)$

L'approccio migliore per questo tipo di problema è utilizzare il segment tree. Si tratta di una struttura dati molto utilizzata quando si devono eseguire query e update su un array. Le operazioni possono essere eseguite sia su un solo elemento (point update/point query) sia su range di elementi contigui (range update/range query). Ciascuna di queste operazioni, siano esse su range o su singoli elementi, ha complessità $cal(O)(log N)$.
Il problema descritto sopra richiede point update e range sum.

=== I segment tree

Un'idea che può venire in mente è di salvarsi la somma di alcuni dei range per non doverli ricalcolare da capo ogni volta. Se questa cosa viene fatta in maniera corretta può portare a un significativo miglioramento delle prestazioni. Per quanto riguarda gli update, vorremmo anche fare in modo di non dover modificare troppi "range precalcolati". Spesso la cosa migliore per massimizzare l'efficienza è trovare un compromesso tra query e update.

Il modo migliore di capire come è fatto un segment tree è vederne una rappresentazione schematica:

#figure(canvas({
  draw-segtree((
    "43", "19", "24", "9", "10", "11", "13",
    "3", "6", "8", "2", "1", "10", "7", "6",
  ))
}))

Gli elementi in giallo sono quelli dell'array originale e ogni altro nodo contiene la somma dei due nodi sottostanti.

- Se la dimensione dell'array iniziale è $N$, ci serviranno $N + N/2 + N/4 + dots + 1 approx 2N$ nodi.
- La profondità del percorso dalla radice a ciascuna delle foglie è $cal(O)(log N)$.
- Ciascun nodo contiene la somma delle foglie del suo sottoalbero, che corrisponde a un sottoarray di lunghezza $2^k$ dell'array originale.

Vediamo nel dettaglio come avvengono le varie operazioni.

==== Update

Se vogliamo modificare l'$i$-esimo elemento ci accorgiamo che i nodi del segment tree da aggiornare sono solo quelli del percorso dalla radice all'$i$-esima foglia. Siccome la profondità dell'albero è $log_2 N$, la complessità dell'update sarà per l'appunto $cal(O)(log N)$.

#figure(canvas({
  draw-segtree((
    upd(43, 47), "19", upd(24, 28), "9", "10", upd(11, 15), "13",
    "3", "6", "8", "2", upd(1, 5), "10", "7", "6",
  ), fills: (
    "0": seg-update,
    "2": seg-update,
    "5": seg-update,
    "11": seg-update,
  ))
}))

I nodi evidenziati in rosa sono quelli interessati dall'update: in questo caso è stato cambiato il quinto elemento, che è diventato $5$, e il valore dei nodi tra la foglia e la radice (compresi) è stato modificato di conseguenza.

==== Query

Per quanto riguarda la somma di un range, il nostro obiettivo è non dover iterare su tutti gli elementi del range, ma sfruttare i range di cui conosciamo la somma per "comporre" il range interessato. È facilmente dimostrabile (ma non necessario agli scopi di questa introduzione) che il numero di nodi che compone un range è al più $2 log N$.

#figure(canvas({
  draw-segtree((
    "47", "19", "28", "9", "10", "15", "13",
    "3", "6", "8", "2", "5", "10", "7", "6",
  ), fills: (
    "2": seg-query,
    "4": seg-query,
  ), query: (9, 14))
}))

Nell'immagine il range della query è composto dagli ultimi 6 elementi nel riquadro verde, ma notiamo che bastano i due nodi evidenziati in rosso per ottenere la somma richiesta.

=== Implementazione

I segment tree sono di fatto alberi binari completi e di profondità $log N$. Di conseguenza è possibile memorizzarli all'interno di un singolo array lungo circa $2N$. Tuttavia, siccome la lunghezza dell'array non è sempre una potenza di due, possiamo utilizzare un array lungo $4N$ ed essere sicuri che vada bene per qualsiasi $N$.

In questa implementazione il segment tree è 1-based, cioè la radice si trova in posizione 1 dell'array. Prendendo in considerazione il nodo $i$-esimo, il suo figlio sinistro sarà in posizione $2i$ e il destro in posizione $2i + 1$. Il padre del nodo $i$ sarà in posizione $floor(i / 2)$. Inoltre, i range saranno in formato *incluso-escluso* (ovvero $[l, r)$ indica gli elementi $l, l+1, ..., r-1$).

Per semplicità implementativa, è bene scrivere una classe (o struct) `segtree` per mantenere ordine e facilitare l'eventuale debugging.

```cpp
struct segtree {
    int N; // Dimensione dell'array originale
    vector<long long> st; // Vettore in cui memorizziamo i dati dell'albero
};
```

==== `build`

Complessità: $cal(O)(N)$

Il costruttore della classe riceve l'array su cui vorremo effettuare le operazioni e ridimensiona l'array del segment tree a $4N$.

```cpp
segtree(vector<long long> &A) {
    N = A.size();
    st.resize (4*N); // 4N va sempre bene

    build(1,0,N,A);
}
```

Successivamente chiama la funzione ricorsiva `build`, che costruisce ricorsivamente il segment tree.

```cpp
// Funzione ricorsiva che costruisce un range del segment tree e restituisce la somma del range
long long build(int i, int left, int right, vector<long long> &A) {

    if (right - left == 1) { // Caso base
        return st[i] = A[left];
    }

    // Divido a metà il range e costruisco ricorsivamente

    int mid = (left + right) / 2;
    st[i] = build(2*i, left, mid, A) +
            build(2*i+1, mid, right, A);

    // Restituisco la somma di questo range
    return st[i];
}
```

La costruzione ricorsiva prende come parametri l'indice `i` del nodo del segment tree e gli estremi `left` (incluso) e `right` (escluso) del range $["left", "right")$ che stiamo costruendo. *Il range si riferisce all'array di interi su cui facciamo le operazioni*: ciò significa che il nodo $i$ conterrà la somma del range $["left", "right")$ di $A$. L'ultimo parametro è infatti l'array $A$, che è importante passare per riferimento con `&`, evitando di generarne una copia a ogni chiamata.

*Caso base:* il range è lungo 1, cioè contiene la somma di un solo elemento di $A$ (cioè `A[left]`); possiamo quindi assegnare il valore e restituirlo.

*Caso generale:* dividiamo a metà il range e costruiamo ricorsivamente le due metà. Il valore del nodo sarà quindi la somma dei due range in cui l'abbiamo diviso (i valori restituiti dalle chiamate ricorsive).

Per dividere un range a metà troviamo il punto medio `mid` facendo la media (approssimata per difetto) di `left` e `right`. La posizione `mid` sarà il primo elemento della metà a destra. La metà sinistra ricorre sul range $["left", "mid")$, mentre quella destra su $["mid", "right")$.

==== `update`

Complessità: $cal(O)(log N)$

Anche l'update avviene con una funzione ricorsiva. Un dettaglio che può semplificare il successivo utilizzo del segment tree è scrivere una procedura che viene chiamata dall'esterno con due soli parametri (posizione e nuovo valore), la quale chiama una procedura omonima interna con tutti i parametri necessari (vedi il codice).

```cpp
// Funzione ricorsiva che modifica il valore di un elemento e tutti i nodi interessati
void update(int i, int left, int right, int pos, long long val) {
    if (right - left == 1) { // Caso base
        st[i] = val;
        return;
    }

    // Ricorro sulla metà in cui si trova l'elemento da modificare
    int mid = (left + right) / 2;

    if (pos < mid) { // Sta nella metà sinistra
        update(2*i, left, mid, pos, val);
    } else { // Sta nella metà destra
        update(2*i+1, mid, right, pos, val);
    }

    // Aggiorno il valore del nodo come somma dei figli
    st[i] = st[2*i] + st[2*i+1];
}

void update(int pos, long long val) {
    update(1, 0, N, pos, val);
}
```

I parametri sono simili alla funzione `build`, ma al posto dell'array abbiamo `pos`, che indica l'indice dell'elemento che vogliamo modificare, e `val` il nuovo valore.

Il caso base è sempre il range lungo 1: se il nodo si riferisce a un solo elemento (quello che vogliamo modificare), cambiamo il suo valore.

Nel caso generale dividiamo sempre a metà il range, ma al posto di ricorrere su entrambi i figli ricorriamo sul sinistro se l'elemento da modificare sta nella prima metà, sul destro altrimenti.

Dopo la chiamata ricorsiva aggiorniamo il valore del nodo facendo la somma dei valori dei figli (uno dei quali sarà stato modificato dall'update).

==== `query`

Complessità: $cal(O)(log N)$

Le query su un range hanno una struttura leggermente diversa ed è meno intuitivo il motivo per cui la complessità rimane logaritmica. Accenno una possibile dimostrazione (non formale) che può benissimo essere ignorata.

#box(fill: example_bg, inset: 8pt, radius: 3pt)[*Spunto di dimostrazione:* supponiamo che la funzione ricorra sulle due metà e che nessuna delle due sia un caso base. A questo punto entrambi i range avranno sempre uno dei due estremi inclusi nel range della query e, di conseguenza, da quel momento in poi ad ogni chiamata una delle due metà arriva a un caso base. Se `mid` non è incluso nel range della query, allora una delle due metà avrà intersezione nulla; altrimenti uno dei due range è totalmente incluso. Possiamo concludere che può accadere al più una volta che entrambi i range su cui si ricorre non siano casi base; di conseguenza la complessità è $cal(O)(log N)$.]

```cpp
// Funzione ricorsiva che restituisce la somma del range [query_left,query_right[
long long query(int i, int left, int right, int query_left, int query_right) {
    if (query_left >= right || query_right <= left) {
        // Caso base 1:
        // il range del nodo non ha intersezioni con il range della query
        return 0;
    }
    if (left >= query_left && right <= query_right) {
        // Caso base 2:
        // il range del nodo è totalmente incluso nel range della query
        return st[i];
    }

    // Ricorro sulle due metà
    int mid = (left + right) / 2;

    return query(2*i, left, mid, query_left, query_right) +
           query(2*i+1, mid, right, query_left, query_right);
}

long long query(int query_left, int query_right) {
    return query(1, 0, N, query_left, query_right);
}
```

La funzione `query`, a differenza delle precedenti, ha due casi base:

- il range del nodo non ha intersezioni con quello della query, quindi la somma dell'intersezione è 0;
- il range del nodo interseca totalmente quello della query, quindi ritorniamo la somma del range.

Nel caso generale ricorriamo sulle due metà senza modificare `query_left` e `query_right`, dato che il range della query rimane sempre lo stesso.

=== Quando si può usare un segment tree

I segment tree sono quasi sempre una buona scelta quando si tratta di fare update e query su range, ma non vanno bene per tutte le operazioni. In particolare funzionano con le operazioni dette *associative* (più formalmente con i _monoidi_), come il minimo/massimo, lo $"XOR"$, il prodotto, il $"GCD"$, eccetera.

Se per esempio ci interessasse il massimo in un range al posto della somma, al posto di unire i due figli di un nodo facendone la somma, si prende il massimo dei due:

```cpp
st[i] = max(st[2*i], st[2*i+1]);
```

I segment tree permettono anche di eseguire operazioni più complesse, come trovare il sottoarray di somma massima in un range, trovare il $k$-esimo elemento (salvando le frequenze) o trovare il primo elemento maggiore o uguale a $k$ in un range.

Versioni più elaborate permettono di eseguire query su versioni precedenti della struttura (*persistenti*) o di memorizzare valori in range più ampi (*segment tree sparsi*). Gli utilizzi sono innumerevoli.
