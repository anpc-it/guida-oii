#import "/templates/page.typ": project
#import "/utils/render.typ": is-web

#let render = if is-web { project.with(title: "Complessità computazionale") } else { it => it }
#show: render

// (nessuna dipendenza non-standard)


== Complessità computazionale <complexity>

Dati due algoritmi che risolvono lo stesso problema, siamo interessati a capire quale dei due sia il migliore in base alle nostre necessità. Poiché il nostro algoritmo deve risolvere il problema in un dato tempo, vogliamo quantificarne l'_efficienza_.

È ragionevole assumere il tempo impiegato sia proporzionale al numero di operazioni eseguite. Il fattore di proporzionalità cambia da macchina a macchina, per questo conviene dare una stima _asintotica_ del numero di operazioni. In altre parole, analizziamo come cresce il numero di operazioni al crescere della dimensione dell'input, ignorando fattori costanti.
#footnote[Classicamente questa si esprime in numero di bit. Nei nostri casi cosa intendiamo sarà chiaro dal contesto.]

Sia $g(n)$ il massimo numero di operazioni di un dato algoritmo al variare degli input di dimensione $n$. Se $g(n)$ cresce non più velocemente di $n^2$, si dice che "$g$ è O grande di $n^2$", scritto $g(n) in cal(O)(n^2)$ o con un abuso di notazione $g(n) = cal(O)(n^2)$.//#footnote[Formalmente, data $f : NN -> NN$ si definisce la classe di funzioni
//$ cal(O)(f(n)) = { g: NN -> NN | exists n_0, c in NN thick "tali che" thick forall n >= n_0 thick g(n) <= c f(n) }. $]
// 

Formalmente, una funzione $g(n)$ si dice $cal(O)(f(n))$ se esistono due costanti $c$ e $n_0$ tali che $g(n) < c dot f(n)$ per tutti gli $n > n_0$.

Per esempio le funzioni che a $n$ associano rispettivamente $n$, $n + 4$, $3 n + 17$ e $42 + (-1)^n$ appartengono tutte alla classe $cal(O)(n)$, ma di queste solo $42 + (-1)^n$ appartiene a $cal(O)(1)$.

//Per completezza definiamo anche le classi $Omega(f(n))$ e $Theta(f(n))$ ponendo $g in Omega(f(n))$ sse $f in cal(O)(g(n))$ e $g in Theta(f(n))$ sse allo stesso tempo $g in cal(O)(f(n))$ e $g in Omega(f(n))$.

Facciamo degli esempi. Dato un array di $n$ interi $a_0, a_1, ..., a_(n - 1)$, consideriamo il problema di trovare la massima somma di un sottoarray#footnote[Ricorda che un sottoarray di un array $a = [a_0, ..., a_(n - 1)]$ è un'array del tipo $[a_l, ..., a_r]$ per qualche scelta di $0 <= l <= r < n$.] (anche vuoto) di $a$.

#grid(
  columns: (1fr, 1fr),
  gutter: 20pt,
  align: left + horizon,
  [
    Un primo approccio implementa né più né meno della definizione del problema. Il programma a destra itera su tutti i sottoarray, ne calcola la somma e sceglie il valore massimo. Il numero totale di interazioni è proporzionale a $n^3$, quindi il codice a destra ha complessità $cal(O)(n^3)$.
  ],
  [
    ```cpp
    LL ans = 0;
    for (int i = 0; i < n; ++i) {
        for (int j = i; j < n; ++j) {
            LL sum = 0;
            for (int k = i; k <= j; ++k)
                sum += a[k];
            ans = max(ans, sum);
        }
    }
    ```
  ],
  [
    L'approccio precedente si può migliorare notando che la somma del sottoarray $a_i, ..., a_(j + 1)$ si ottiene con un'operazione a partire dalla somma del sottoarray $a_i, ..., a_j$. L'implementazione a sinistra elimina il ciclo `for` più interno, abbassando la complessità a $cal(O)(n^2)$.
  ],
  [
    ```cpp
    LL ans = 0;
    for (int i = 0; i < n; ++i) {
        LL sum = 0;
        for (int j = i; j < n; ++j) {
            sum += a[j];
            ans = max(ans, sum);
        }
    }
    ```
  ],
  [
      Possiamo fare meglio di così e risolvere il problema in tempo lineare. Posto $p_i := a_0 + ... + a_i$ la somma del prefisso che termina con $a_i$, vale $a_i + ... + a_j = p_j - p_(i - 1)$. A $j$ fissato, la somma $p_j - p_i$ è massima quando $p_i$ è minima. Una soluzione itera su tutti i possibili $j$, mantenendo la somma prefissa corrente e la minima tra le somme prefisse precedenti. Questo approccio ha complessità $cal(O)(n)$.
  ],
  [
    ```cpp
    LL ans = 0;
    LL prf = 0, min_prf = 0;
    for (int i = 0; i < n; ++i) {
        prf += a[i];
        min_prf = min(min_prf, prf);
        ans = max(ans, prf - min_prf);
    }
    ```
  ],
)

Per il momento non serve capire a fondo gli algoritmi appena esposti ma basta comprendere che possono esistere più approcci diversi per rispondere ad una stessa richiesta e alcuni sono più efficienti di altri. 

Non sempre c'è una singola soluzione migliore ma valutarne la complessità permette di capire quale strategia adottare sulla base delle limitazioni del problema.

Osserva infine che lo stesso tipo di analisi si può applicare anche alla memoria utilizzata oltre che al numero di operazioni eseguite.

Determina per esercizio la complessità dei seguenti pezzi di codice.

#grid(
  columns: (1fr, 1fr),
  column-gutter: 20pt,
  align: left + horizon,
  [
    ```cpp
    for (int i = 0; i < n; ++i) {
        int cur = i;
        while (cur != 0)
            cur /= 2;
    }
    ```
  ],
  [
    ```cpp
    int x = 0;
    for (int i = 1; i <= n; ++i) {
        for (int j = i; j <= n; j += i) {
            ++x;
        }
    }
    ```
  ]
)

=== Esempi notevoli

Spesso ci si trova a dover stimare la complessità di un algoritmo in situazioni in cui la struttura di alcuni cicli rende non evidente quanto il numero di iterazioni cresca velocemente.
Ecco alcuni dei casi più comuni:

- Iterare $N$ volte, poi $N / 2$, poi $N / 4$ e così via ogni volta dimezzando il numero di iterazioni è $cal(O)(N)$ perché $N + N/2 + N/4 + N/8 + dots + 1 approx 2N$.

- Iterare $N + N/2 + N/3 + N/4 + dots 1$ volte è $cal(O)(N log N)$ dal momento che la $sum_(i = 1)^N N/i approx N ln N$.

```cpp
for (int i = 1; i <= N; i++) {
    for (int j = i; j <= N; j += i) {
        // Questo blocco viene eseguito O(N log N) volte
    }
}
```

- Iterare $sum_(p <= N, p "primo")(N / p)$ dove $p$ è un primo è $cal(O)(N log log N)$, che nella pratica è quasi lineare dal momento che $log log 10^9 approx 3$.

- Altri fatti utili da conoscere sono che il numero di fattori primi di un numero è $cal(O)(log N)$ e che il numero di primi è $cal(O)(N / (ln N))$.

In generale puoi tenere a mente la tabella che segue come riferimento per la complessità target data la grandezza di $N$.

#figure(
  table(
    columns: (auto, auto, auto),
    align: (center + horizon, center + horizon, left + horizon),
    stroke: 0.5pt,
    inset: 8pt,
    
    table.header(
      [*Limite di $N$*], [*Complessità Attesa*], [*Esempi Tipici di Algoritmi*]
    ),
    
    [$N <= 11$], [$cal(O)(N!)$], [Permutazioni, Ricerca completa],
    [$N <= 22$], [$cal(O)(2^N dot N)$], [Bitmask DP],
    [$N <= 100$], [$cal(O)(N^4)$ o $cal(O)(N^3)$], [Floyd-Warshall, DP cubiche o quartiche],
    [$N <= 1000$], [$cal(O)(N^2)$ o $cal(O)(N^2 log N)$], [DP quadratiche, Grafi densi],
    [$N <= 10^5$ o $2 dot 10^5$], [$cal(O)(N log N)$], [Ordinamento, Segment Tree, Dijkstra],
    [$N <= 10^6$ o $10^7$], [$cal(O)(N)$ o $cal(O)(N log log N)$], [Two Pointers, Sliding Window, Crivello],
    [$N <= 10^(18)$], [$cal(O)(log N)$ o $cal(O)(1)$], [Ricerca Binaria sull'output, Matematica],
  )
)

Non preoccuparti se non conosci gli algoritmi citati nella tabella, li imparerai man mano con la lettura di questa guida.
In generale puoi tenere a mente che in un secondo puoi fare circa $10^8$ operazioni elementari.
