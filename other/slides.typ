#import "@preview/polylux:0.4.0": *
#import themes.clean: *

// --- CONFIGURAZIONE ---
#set text(font: "Roboto", size: 20pt)
#show raw: set text(font: "Fira Code", size: 0.85em)

#show: clean-theme.with(
  footer: [Guida alle Olimpiadi di Informatica - Programmazione Dinamica],
  short-title: [Olinfo 2025],
)

// --- TITOLO ---
#title-slide(
  title: [Guida alle Olimpiadi di Informatica],
  subtitle: [Capitolo 1: Programmazione Dinamica],
  authors: ([M. Arcari, L. Ferrari, F. Vercellesi, L. Versari]),
  date: [25 Novembre 2025],
)

// --- SLIDE 1 ---
#slide(title: "Cos'è la Programmazione Dinamica?")[
  La DP è una tecnica per risolvere problemi complessi scomponendoli in sottoproblemi più semplici. Si applica principalmente a:

  1. **Problemi di Ottimizzazione**
     - Trovare la soluzione migliore (minimo costo, massimo guadagno).
  
  2. **Problemi di Conteggio**
     - Contare il numero di modi per soddisfare una condizione.

  *Concetto chiave:* **Memoizzazione**. Non ricalcolare mai lo stesso sottoproblema due volte!
]

// --- SLIDE 2 ---
#slide(title: "Esempio: Rod Cutting")[
  **Il Problema:**
  Hai una barra di lunghezza $N$. Puoi tagliarla in pezzi di lunghezza $i$, ognuno con un prezzo $p_i$. Massimizza il guadagno totale.

  **Definizione Ricorsiva:**
  Sia $op("ricavo")(L)$ il massimo guadagno per una barra lunga $L$.
  
  $op("ricavo")(L) = max_(1 <= i <= L) { p_i + op("ricavo")(L-i) }$
  
  Caso base: $op("ricavo")(0) = 0$.
]

// --- SLIDE 3 ---
#slide(title: "Rod Cutting: Codice")[
  Usiamo un array `memo` per salvare i risultati (Memoization).

  ```cpp
  // Versione Memoizzata (Top-Down)
  ll ricavo(int L) {
      if (L == 0) return 0;
      if (memo[L] != -1) return memo[L]; // Già calcolato
      
      ll ans = 0;
      for (int i = 1; i <= L; i++) {
          ans = max(ans, p[i] + ricavo(L - i));
      }
      return memo[L] = ans;
  }
  ```
  Complessità: $O(N^2)$. Senza memoizzazione sarebbe $O(2^N)$!
]

// --- SLIDE 4 ---
#slide(title: "Approccio Iterativo (Bottom-Up)")[
  Invece della ricorsione, possiamo riempire la tabella dal basso verso l'alto.

  ```cpp
  vector<ll> dp(N + 1, 0);

  for (int L = 1; L <= N; L++) {     // Per ogni lunghezza
      for (int i = 1; i <= L; i++) { // Prova ogni taglio
          dp[L] = max(dp[L], p[i] + dp[L - i]);
      }
  }
  ```
  
  Questo evita il rischio di *Stack Overflow* per $N$ grande.
]

// --- SLIDE 5 ---
#slide(title: "Coin Combinations I (CSES)")[
  **Problema:** Modi per ottenere somma $X$ con monete date.
  *Nota:* L'ordine conta ($2+1 \neq 1+2$).

  **Soluzione:**
  Per ogni somma possibile $y$, proviamo ad aggiungere ogni moneta.

  ```cpp
  dp[0] = 1;
  for (int y = 1; y <= X; y++) {   // Ciclo esterno: SOMMA
      for (int c : coins) {        // Ciclo interno: MONETE
          if (y >= c) {
              dp[y] = (dp[y] + dp[y - c]) % MOD;
          }
      }
  }
  ```
]

// --- SLIDE 6 ---
#slide(title: "Coin Combinations II (CSES)")[
  **Problema:** Modi per ottenere somma $X$.
  *Nota:* L'ordine NON conta (Sottoinsiemi: $\{1, 2\}$ è uguale a $\{2, 1\}$).

  **Il Trucco:** Scambiamo l'ordine dei cicli!
  
  ```cpp
  dp[0] = 1;
  for (int c : coins) {            // Ciclo esterno: MONETE
      for (int y = 1; y <= X; y++) { // Ciclo interno: SOMMA
          if (y >= c) {
              dp[y] = (dp[y] + dp[y - c]) % MOD;
          }
      }
  }
  ```
  Questo forza l'uso delle monete in un ordine specifico, evitando duplicati.
]

// --- SLIDE 7 ---
#slide(title: "Longest Common Subsequence (LCS)")[
  Date due stringhe $A$ e $B$, trovare la sottosequenza comune più lunga.
  
  Stato: $dp[i][j]$ è la LCS considerando $A[1\dots i]$ e $B[1\dots j]$.

  $ dp[i][j] = cases(
    1 + dp[i-1][j-1] & "se " A[i] == B[j],
    max(dp[i-1][j], dp[i][j-1]) & "se " A[i] != B[j]
  ) $
]

// --- SLIDE 8 ---
#slide(title: "LCS: Codice C++")[
  ```cpp
  for (int i = 1; i <= n; i++) {
      for (int j = 1; j <= m; j++) {
          if (a[i] == b[j]) {
              dp[i][j] = 1 + dp[i-1][j-1];
          } else {
              dp[i][j] = max(dp[i-1][j], dp[i][j-1]);
          }
      }
  }
  cout << dp[n][m] << endl;
  ```
  Per ricostruire la stringa, si parte da $(n,m)$ e si "torna indietro" seguendo le decisioni migliori.
]

// --- SLIDE 9 ---
#slide(title: "Conclusioni ed esercizi")[
  **Consigli Pratici:**
  - Definisci chiaramente lo "stato" (cosa descrive la situazione corrente?).
  - Cerca i casi base.
  - Scrivi prima la ricorrenza su carta.

  **Esercizi (Training Olinfo & CSES):**
  - `LCS`, `Knapsack` (Classici)
  - `poldo` (LIS - Longest Increasing Subsequence)
  - `fermata` (Olimpiadi Italiane a Squadre)
  - `preoii_yutaka`
]
