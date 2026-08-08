#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *


== Complessità computazionale <complexity>

Dati due algoritmi che risolvono lo stesso problema, siamo interessati a capire quale dei due sia il migliore in base alle nostre necessità. Poiché il nostro algoritmo deve risolvere il problema in un dato tempo, vogliamo quantificarne l'_efficienza_.

È ragionevole assumere il tempo impiegato sia proporzionale al numero di operazioni eseguite. Il fattore di proporzionalità cambia da macchina a macchina, per questo conviene dare una stima _asintotica_ del numero di operazioni. In altre parole, analizziamo come cresce il numero di operazioni al crescere della dimensione dell'input, ignorando fattori costanti.
#footnote[Classicamente questa si esprime in numero di bit. Nei nostri casi cosa intendiamo sarà chiaro dal contesto.]

Sia $g(n)$ il massimo numero di operazioni di un dato algoritmo al variare degli input di dimensione $n$. Se $g(n)$ cresce non più velocemente di $n^2$, si dice che "$g$ è O grande di $n^2$", scritto $g(n) in cal(O)(n^2)$ o con un abuso di notazione $g(n) = cal(O)(n^2)$.#footnote[Formalmente, data $f : NN -> NN$ si definisce la classe di funzioni
$ cal(O)(f(n)) = { g: NN -> NN | exists n_0, c in NN thick "tali che" thick forall n >= n_0 thick g(n) <= c f(n) }. $]

Per esempio le funzioni che a $n$ associano rispettivamente $n$, $n + 4$, $3 n + 17$ e $42 + (-1)^n$ appartengono tutte alla classe $cal(O)(n)$, ma di queste solo $42 + (-1)^n$ appartiene a $cal(O)(1)$.

Per completezza definiamo anche le classi $Omega(f(n))$ e $Theta(f(n))$ ponendo $g in Omega(f(n))$ sse $f in cal(O)(g(n))$ e $g in Theta(f(n))$ sse allo stesso tempo $g in cal(O)(f(n))$ e $g in Omega(f(n))$.

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
                sum += a[i];
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
