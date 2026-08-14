#import "@preview/cetz:0.4.2": canvas, draw
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#import "@preview/tdtr:0.6.1" : *
#import "../../utils/problems.typ": *

== Ricorsione e ricerca completa

In quasi tutti i problemi, l'obiettivo è svolgere una computazione richiesta nel modo più efficiente possibile.
Può capitare che, o perché non abbiamo abbastanza idee o perché non è possibile fare di meglio, ci interessi scrivere una soluzione che esplori tutte le possibilità compatibili con la struttura del problema.
Questo è possibile principalmente attraverso funzioni ricorsive, ovvero funzioni che chiamano loro stesse.
Facciamo un esempio di funzione ricorsiva:

```cpp
int somma_primi_n_numeri(int n) {
    if (n == 0)
        return 0;
    return n + somma_primi_n_numeri(n - 1);
}
```

Questa funzione vuole evidentemente calcolare la somma dei primi $n$ numeri (con $n >= 0$)#footnote[È ovviamente possibile eseguire lo stesso calcolo con un ciclo `for` o con la formula nota $n(n + 1) / 2$.]. 
È possibile dividere il corpo della funzione in due parti principali: 

- Il caso base: $n = 0$ è la più piccola istanza del problema e siamo in grado di risolverlo senza ulteriori calcoli.
- Il caso generale: $n > 0$ e quindi possiamo dire che la somma dei numeri da $0$ a $n$ è uguale a $n$ più la somma dei numeri da $0$ a $n - 1$.

Questa funzione ha complessità $cal(O)(n)$ perché chiamare `somma_primi_n_numeri(n)` comporta la chiamata della stessa funzione con parametro $n-1$, poi $n-2$ e così via fino a $0$.

Un altro esempio è la funzione per calcolare il fattoriale mostrata nel #link(<factorial>)[capitolo introduttivo al C++].

In entrambi questi esempi è presente un caso base e un caso generale.
Una funzione ricorsiva senza caso base non terminerebbe mai l'esecuzione e continuerebbe a chiamarsi all'infinito.
È buona pratica che il caso base di una funzione ricorsiva sia quanto più semplice ed elementare possibile.

Un altro esempio comune di funzione ricorsiva è quella che definisce i numeri fibonacci, in cui ogni termine è la somma dei due precedenti. 
Si prendono come casi base $"fib"(0) = 0$ e $"fib"(1) = 1$.

```cpp
int fib(int n) {
    if (n <= 1) 
       return n;
    return fib(n - 1) + fib(n - 2);
}
```

In questo caso però la complessità non è più lineare in $n$ ma esponenziale#footnote[Vedremo in un capitolo successivo come rendere questa funzione lineare in $n$.].

Ci sono casi in cui la ricerca completa è l'unico modo per risolvere un problema: un esempio è stampare tutti gli array di lunghezza $n$ composti da soli numeri (eventualmente anche ripetuti) da $1$ a $k$.

#grid(
  columns: (2fr, 1fr),
  column-gutter: 20pt,
  [
    ```cpp
    void rec(int n, int k, vector<int> V) {
        if (V.size() == n) {
            for (int v: V) 
                cout << v << ' ';
            cout << '\n';
            return;
        }
        for (int x = 1; x <= k; x++) {
            V.push_back(x);
            rec(n, k, V);
            V.pop_back();
        }
    }
    ```
  ],
  [
    ```output
1 1 1 
1 1 2 
1 2 1 
1 2 2 
2 1 1 
2 1 2 
2 2 1 
2 2 2  
    ```
  ]
)

L'output mostrato a fianco è l'output della chiamata `rec(3, 2, {})`;
Il vettore $V$ passato tra i parametri è un vettore di appoggio che riempiremo con le varie chiamate (notare che, con qualche accorgimento, è possibile passare $V$ per riferimento per non crearne una copia a ogni chiamata).

Se $V$ è grande $n$ abbiamo finito.
Diversamente vogliamo mettere uno alla volta tutti i possibili valori alla fine di $V$ ricorrendo poi sulla restante parte dell'array.
Per rendere più chiaro lo schema delle chiamate ricorsive è possibile farne una rappresentazione ad albero in cui ogni nodo è una chiamata e ogni foglia contiene uno dei possibili array generati.
Per semplicità sono omessi i parametri $n$ e $k$ nelle chiamate successive alla prima. 

#figure(
  tidy-tree-graph(
    spacing: (10pt, 20pt),
    node-inset: 5pt,
    draw-node: (defocus: 0),
  )[
    - $"rec"(3, 2, [])$
      + $1$
      - $"rec"([1])$
        + $1$
        - $"rec"([1, 1])$
          + $1$
          - $"rec"([1, 1, 1])$
            - $[1, 1, 1]$
          + $2$
          - $"rec"([1, 1, 2])$
            - $[1, 1, 2]$
        + $2$
        - $"rec"([1, 2])$
          + $1$
          - $"rec"([1, 2, 1])$
            - $[1, 2, 1]$
          + $2$
          - $"rec"([1, 2, 2])$
            - $[1, 2, 2]$
      + $2$
      - $"rec"([2])$
        + $1$
        - $"rec"([2, 1])$
          + $1$
          - $"rec"([2, 1, 1])$
            - $[2, 1, 1]$
          + $2$
          - $"rec"([2, 1, 2])$
            - $[2, 1, 2]$
        + $2$
        - $"rec"([2, 2])$
          + $1$
          - $"rec"([2, 2, 1])$
            - $[2, 2, 1]$
          + $2$
          - $"rec"([2, 2, 2])$
            - $[2, 2, 2]$
  ],
  caption: [Lo schema ad albero delle chiamate ricorsive.]
)

Notiamo che gli array vengono generati in ordine lessicografico se i valori vengono localmente aggiunti in ordine lessicografico.

#problem("Numero della cabala", url: "https://training.olinfo.it/task/ois_cabala", lbl: "cabala", tags: ("ois", "2016"))[
  Un numero è bello se ha al massimo $N <= 18$ cifre, è composto solo dalle cifre $3$, $6$ e $9$, non ci sono due cifre adiacenti uguali.
  Siamo interessati al massimo resto di un numero bello diviso per $M$.
][
  Un'osservazione utile è che scelta la prima cifra tra le $3$ disponibili, ogni cifra successiva ha solo due possibilità perché non può essere uguale a quella prima.
  Questo abbassa la complessità della ricerca completa da $cal(O)(3^N)$ a $cal(O)(2^N)$.

  Ora basta generare tutti i numeri belli.
  Visto che il problema ha più testcase, è riportata solo la funzione `solve(int N, int M)` che risolve un singolo testcase.

  ```cpp
  long long resto_massimo, limite;

  void rec(long long x, long long M) {
      if (x >= limite) return;
      resto_massimo = max(resto_massimo, x % M);

      int ultima_cifra = x % 10;
      for (int cifra: {3, 6, 9})
          if (ultima_cifra != cifra)
              rec(10 * x + cifra, M);
  }
  int solve(int N, long long M) {
      resto_massimo = 0;
      limite = pow(10, N);
      rec(0, M);
      return resto_massimo;
  }
  ```
]

Si lascia come esercizio il problema #link("https://training.olinfo.it/task/ois_solitario")

Un altro esempio classico di problema che si risolve ricorsivamente è quello della torre di Hanoi.

#problem("Tower of Hanoi", url: "https://cses.fi/problemset/task/2165/", lbl: "tower-of-hanoi", tags: ("cses",))[
  Ci sono 3 pile numerate da 1 a 3. 
  All'inizio ci sono $N$ dischi nella pila di sinistra di dimensione, partendo da sopra, $1, 2, dots, N$.
  Possiamo spostare solo il disco in cima per ogni pila a patto che la pila di destinazione sia vuota o abbia in cima un disco più grande di quello che spostiamo. 
  Vogliamo stampare una sequenza di mosse per ricreare la pila di dischi a destra nel minimo numero di mosse.
][
  A prima vista sembra un problema complesso, ma ragionando "ricorsivamente" si semplifica notevolmente.

  Facciamo finta di saper risolvere il problema per qualsiasi $n$, cioè di saper spostare $n <= N$ dischi da una pila di partenza a una di arrivo.
  Allora ci basterà spostare i primi $N - 1$ dischi dalla prima alla seconda pila in modo da liberare il disco più grande.
  A questo punto spostiamo il più grande da sinistra a destra e infine spostiamo i primi $N - 1$ dal centro a destra.

  Quando spostiamo i primi $N - 1$ non ci dobbiamo preoccupare dei dischi sotto perché sono più grandi.
  Il numero di mosse totali è $2^N - 1$.
  Si può semplicemente contare man mano che si fanno o notando che $"mosse"(N) = "mosse"(N-1) + 1 + "mosse"(N-1)$ e che $"mosse"(1)=1$.

  ```cpp
  void hanoi(int n, int from, int to) {
      if (n == 1) {
          cout << from << " " << to << "\n";
          return;
      }
      hanoi(n - 1, from, 6 - from - to);
      hanoi(1, from, to);
      hanoi(n - 1, 6 - from - to, to);
  }
  ```
  La chiamata `hanoi(N, 1, 3)` risolve il problema.
  Per individuare la pila di appoggio viene usata la formula $6 - "from" - "to"$.
]
