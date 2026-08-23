#import "/templates/page.typ": project
#import "/utils/render.typ": is-web

#let render = if is-web { project.with(title: "Debug") } else { it => it }
#show: render

#import "/utils/problems.typ": *
#import "/utils/examples.typ": *
#import "/utils/tables.typ": *
#import "/utils/draw_graph.typ": *
#import "/utils/cetz.typ": canvas
#import "/utils/tdtr.typ": *
#import "/utils/code.typ": code, local
#import "/utils/ref.typ": crossref
#import "/utils/palette.typ": *

== Debug <debug-page>
=== Formattazione del testo

Questo è *grassetto*, questo _corsivo_, questo #underline[sottolineato], questo #strike[barrato], questo #overline[con sopralinea], questo #smallcaps[maiuscoletto].

Stili combinati: *_grassetto e corsivo_*, #strong[#emph[annidato]], #underline[*sottolineato grassetto*].

Colori: #text(fill: rgb("#d32f2f"))[rosso], #text(fill: rgb("#2e7d32"))[verde], #text(fill: rgb("#1565c0"))[blu], #text(fill: orange)[arancio].

Apici e pedici: $x^(2)$, $"H"_2"O"$, $a_i$, $2^(2^(3))$.

Maiuscole accentate e simboli: à è é ì ò ù, Ångström Å, æ, œ, ç Ç, ß, ø Ø.

Un #link("https://olinfo.it")[link esterno], e un riferimento interno via #crossref(<complexity>, "/chapters/1_terry/complexity.typ", [complessità computazionale]).

=== Liste

- Primo elemento di una lista puntata
- Secondo elemento
  - Sotto-elemento annidato
  - Un altro sotto-elemento
- Terzo elemento

+ Primo elemento numerato
+ Secondo elemento numerato
  1. Sotto-elemento numerato
  2. Ancora un sotto-elemento
+ Terzo elemento numerato

/ Termine: definizione di un termine in una term list.

=== Matematica

Matematica inline: $cal(O)(n log n)$, $N <= 10^6$, $a_i in [0, 10^9]$, $sqrt(n)$, $Pi r^2$, $e^(i pi) + 1 = 0$.

Equazione in blocco:

$ sum_(k=1)^(n) k = (n(n+1))/2 $

Equazioni allineate su più righe:

$ f(n) &= n + f(n/2) \
       &= n + n/2 + n/4 + dots + 1 \
       &= cal(O)(n) $

=== Simboli ed elementi

Operatori: $sum product integral integral.cont partial nabla infinity plus.minus minus.plus times dot.op div circle bullet angle degree$.

Relazioni: $< > <= >= != approx equiv prop tilde <== ==> <=>$.

Insiemi: $in in.not subset subset.eq supset supset.eq union inter emptyset$.

Logica: $and or not forall exists$.

Lettere greche: $alpha beta gamma delta epsilon zeta eta theta lambda mu nu xi pi rho sigma tau phi chi psi omega $ e maiuscole $Gamma Delta Theta Lambda Xi Pi Sigma Phi Psi Omega$.

Frecce: $-> <- <-> => <=> |-> arrow.t arrow.b arrow.r.double.l$.

Frazioni e radici: $a/b$, $frac(a, b)$, $binom(n, k)$, $root(3, 8) = 2$, $sqrt(a^2 + b^2)$.

Matrici e casi:

$ mat(1, 2, 3; 4, 5, 6; 7, 8, 9) $

$ mat(delim: "(", a, b; c, d) $

$ cases(x & "se" & x >= 0, -x & "altrimenti") $

Limiti e sommatorie con limiti:

$ lim_(x -> 0) (sin x)/x = 1 quad "e" quad product_(i=1)^(n) i = n! $

Accenti: $dot(x) dot.double(x) hat(x) vec(x) tilde(x) bar(x) acute(x) grave(x)$.

Testo + simboli: $"risposta" = sum_(i=0)^(n-1) "peso"[i]$.

=== Allineamenti e layout

#align(left)[Testo allineato a sinistra.]
#align(center)[Testo centrato.]
#align(right)[Testo allineato a destra.]

#align(center)[
  #text(weight: "bold")[Centrato in grassetto] \
  e una seconda riga centrata.
]

#block(fill: example_bg, inset: 1em, radius: 0.4em, stroke: 1pt + luma(200))[
  Questo è un #box[blocco] con sfondo, bordo arrotondato e rientro.
]

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 1em,
  align: center,
  [Cella 1], [Cella 2], [Cella 3],
  [Cella 4], [Cella 5], [Cella 6],
)

=== Tabelle

#table(
  columns: (auto, auto, auto),
  align: (center, center, center),
  inset: 6pt,
  stroke: 0.5pt + luma(200),
  [*A*], [*B*], [*A + B*],
  [1], [2], [3],
  [4], [5], [9],
)

#op-table(
  op-row([`size()`], [$cal(O)(1)$], [Restituisce il numero di elementi.]),
  op-row([`push(x)`], [$cal(O)(1)$], [Inserisce `x` in fondo.]),
  op-row([`pop()`], [$cal(O)(1)$], [Rimuove l'ultimo elemento.]),
)

=== Codice

Codice con nome del file:

#code(header: [*debug.cpp*])
```cpp
#include <bits/stdc++.h>
using namespace std;

int main() {
    int n;
    cin >> n;
    vector<int> a(n);
    for (int &x : a) cin >> x;
    sort(a.begin(), a.end());
    for (int x : a) cout << x << " ";
    cout << endl;
}
```

#code(header: [*script.sh*])
```sh
g++ -O2 -std=c++17 debug.cpp -o debug
./debug
```

Codice senza nome del file:

```cpp
for (int i = 0; i < n; i++)
    for (int j = 0; j < m; j++)
        dp[i][j] = 0;
```

```output
0  2  0  0
0  0  3  0
7  5  0  1
```

=== Elementi "example" e "problem"

#example[Esempio con titolo][
  Un esempio con un titolo, che contiene del testo e magari una formula $a^2 + b^2 = c^2$.
]

#example[][
  Un esempio _senza_ titolo, per verificare il caso in cui il titolo è vuoto.
]

#problem("Problema di prova", url: "https://training.olinfo.it", lbl: "problema-debug", tags: ("oii", "2013"))[
  Questo è un problema di prova con un testo, dei tag e un collegamento.
  Quando $N = 3$ e $M = 2$, la risposta è $5$.
][
  Ecco una soluzione di prova, con del codice e una formula $cal(O)(N log N)$.

  ```cpp
  int solve() { return 42; }
  ```

  La soluzione termina in tempo costante.
]

#problem("Problema senza soluzione", tags: ("cses",))[
  Un problema che non ha una soluzione allegata: il campo `solution` è vuoto.
][]

=== Grafi (cetz + draw_graph)

#figure(
  canvas({
    let nodes = ((0, 0), (2, 2), (-1, 2), (3, 0))
    let edges = ((0, 1, 2), (0, 2, 1), (1, 2, 3), (1, 3, 5))
    draw_graph(nodes, edges, rad: 10pt)
  }),
  caption: [Un grafo non diretto e pesato.]
)

#canvas({
  let nodes = ((0, -1.5), (1, -0.5), (2.5, -0.5), (3.5, -1.5), (2.5, -2.5), (1, -2.5))
  let edges = ((0, 1), (0, 5), (1, 2), (2, 4), (3, 2), (4, 3), (5, 1), (5, 2), (5, 4))
  draw_graph(
    nodes,
    edges,
    rad: 10pt,
    directed: true,
    node_fill: ("0": rgb("#ff9595"), "5": rgb("#8adcff")),
  )
})

=== Alberi (tdtr)

#figure(
  tidy-tree-graph(
    spacing: (10pt, 20pt),
    node-inset: 5pt,
    draw-node: (defocus: 0),
  )[
    - $"rec"(2, [])$
      + $1$
      - $"rec"([1])$
        + $2$
        - $[1, 2]$
      + $2$
      - $"rec"([2])$
        + $1$
        - $[2, 1]$
  ],
  caption: [Un albero di ricorsione.]
)

=== Note a piè di pagina

Un testo con una nota#footnote[Questa è una nota a piè di pagina, con $cal(O)(1)$ incluso.].
