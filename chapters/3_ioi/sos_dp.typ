#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#import "../../utils/problems.typ": *


== Sum over Subsets DP

Consideriamo il seguente problema.
#problem("Bit Problem", url: "https://cses.fi/problemset/task/1654", lbl: "bit-problem", tags: ("cses",),
[
  Sono dati $M <= 10^6$ interi a $N = 20$ bit. Ci chiediamo, per ogni elemento $x$, il numero di elementi $y$ tali che $x | y = x$.
]
)


Osserviamo che vale $x | y = x <==> y subset.eq x$, con $x$, $y$ visti come insiemi delle posizioni dei bit $1$.
Sia allora $a[x]$ la frequenza di $x$ nell'array. Per ogni elemento $x$, la risposta è la _sum over subsets_ $"sos"[x] := sum_(y subset.eq x) a[y]$.
Implementare questa riformulazione del problema, senza ulteriori idee, porta a una soluzione $cal(O)(4^N)$.

#codly(
	header: [*Approccio naive $cal(O)(4^N)$*],
)
```cpp
int n = 20;
vector<int> a(1 << n);
vector<int> sos(1 << n);
for (int x = 0; x < (1 << n); ++x)
    for (int y = 0; y < (1 << n); ++y)
        if (x | y == x)
            sos[x] += a[y];
```

Si può fare meglio di così: per ogni $x$, posso iterare solo sugli $y subset.eq x$. In questo modo il numero totale di iterazioni è uguale a $S = \#{(x,y) | y subset.eq x subset.eq {1, ..., N}} = 3^N$.


#codly(
	header: [*Approccio $cal(O)(3^N)$*],
)
```cpp
for (int x = 1; x < (1 << n); ++x) {
    for (int y = x; y >= 0; y = (y - 1) & x) {
        sos[x] += a[y];
        if (y == 0)
            break;
    }
}
```
*Esercizi:*
+ dimostrare l'uguaglianza $\#{(x,y) | y subset.eq x subset.eq {1, ..., N}} = 3^N$;
+ capire perché il secondo `for` itera su tutti e soli i sottoinsiemi di $x$.

Purtroppo nel nostro caso $cal(O)(3^N)$ è ancora troppo lento. Abbiamo bisogno di nuove idee: consideriamo un problema apparentemente scollegato.

=== Somme prefisse bidimensionali

È data una griglia le cui celle contengono degli interi. Per ogni cella $(i,j)$, calcolare la somma dei numeri contenuti nelle celle $(x,y)$ con $x <= i$ e $y <= j$.

Si procede calcolando le somme prefisse prima per riga, poi per colonna sulla nuova griglia che contiene le somme prefisse di ogni riga. Ci si può convincere che alla fine in ogni cella $(i,j)$ si trova la risposta. Provare per credere, riportiamo un esempio su una griglia $4 times 5$.
  
#local(number-format: none)[
#grid(
	columns: (1fr, 1fr, 1fr),
	gutter: 1em,
	[
```
0  2  0  0
0  0  3  0
7  5  0  1
0  0  0  1
```
	],
	[
```
0  2  2  2
0  0  3  3
7 12 12 13
0  0  0  1
```
	],
	[
```
0  2  2  2
0  2  5  5
7 14 17 18
7 14 17 19
```
	]
)
]

*Esercizio:* (scollegato) Esprimere la somma di un generico rettangolo di vertici opposti $(i_1,j_1), (i_2, j_2)$ nella griglia iniziale come somma/differenza di elementi della griglia finale.

Lo stesso approccio funziona per un numero arbitrario di dimensioni e -- tenetevi forte -- il problema di partenza si può formulare esattamente in questi termini!
Nel nostro caso la griglia è $N$-dimensionale e ogni coordinata è $0$ o $1$. (Equivalentemente, lavoriamo sui vertici dell'ipercubo in $N$ dimensioni.) Ogni elemento di ${0, dots, 2^N - 1}$ corrisponde a una $N$-upla di coordinate binarie, quindi un punto sulla griglia. Vale $y subset.eq x$ se e solo se le coordinate di $y$ sono minori o uguali delle coordinate di $x$ (proprio come nelle somme prefisse bidimensionali).

#codly(
	header: [*Approccio $cal(O)(N dot 2^N)$*],
)
```cpp
vector<int> sos(1 << n); // inizialmente sos[i] = a[i]
for (int i = 0; i < n; ++i)
    for (int mask = 0; mask < (1 << n); ++mask)
        if (mask & (1 << i))
            sos[mask] += sos[mask ^ (1 << i)];
```

Allo step $i$-esimo, per ogni cella sommiamo le celle precedenti nella $i$-esima direzione, dunque se l'$i$-esimo bit è $0$ non sommiamo nulla, se è $1$ sommiamo l'elemento precedente sulla riga generalizzata, vale a dire $"sos"["mask" xor 2^i]$.

*Esercizo:* rispondere anche alle ultime due domande di #link("https://cses.fi/problemset/task/1654")[Bit Problem].

*Problema:* (avanzato) #link("https://oj.uz/problem/view/JOI18_snake_escaping")[JOI18 -- Snake Escaping].
// facciamo una sezione apposta per gli Hint?
// Hint: [spoiler]data una stringa $w \in \{0, 1, ?\}^L$, qual è la massima frequenza del simbolo che appare meno volte?[/spoiler]
