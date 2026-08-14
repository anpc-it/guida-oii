#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#import "../../utils/problems.typ": *


== Programmazione dinamica

In questo capitolo sviluppiamo una tecnica molto potente per affrontare due categorie di problemi che ha senso trattare congiuntamente:
- problemi di *ottimizzazione*, cioè prendere scelte che portino al massimo guadagno (o, equivalentemente, alla minima spesa) possibile;
- problemi di *conteggio*, cioè contare le soluzioni che rispettano una certa condizione.

Consideriamo il seguente esempio pratico.
#problem("Rod Cutting", lbl: "rod-cutting")[
	La Olinfo Srl compra barre di metallo molto lunghe per tagliarle e rivenderne pezzi più corti. Le barre possono essere lunghe un numero intero di metri da $1$ a $N$ e dalla vendita di una barra di $i$ metri si ricavano $p_i$ euro. Effettuare i tagli non ha alcun costo. Aiuta la Olinfo Srl a ricavare il massimo possibile dalla vendita dei pezzi ottenuti da una barra di lunghezza $N$ metri!
][
  Complichiamoci apparentemente la vita: rispondiamo non solo per una barra di lunghezza $N$, ma per tutte le possibili lunghezze $L <= N$.
  Sia allora $"ricavo"(L)$ la risposta al problema per una barra di lunghezza $L$, per esempio $"ricavo"(0) = 0$. Se la Olinfo Srl taglia e vende un pezzo di lunghezza $i$, questa ricava $p_i + "ricavo"(L - i)$ e poiché un pezzo di una qualche lunghezza andrà pur tagliato, per ogni $L >= 1$ vale l'identità
  $ "ricavo"(L) = max{p_i + "ricavo"(L - i) | i = 1, dots, L}. $

  Un'implementazione ingenua di questa ricorrenza è lenta ma corretta.
  ```cpp
  LL ricavo(int L) {
      LL ans = 0;
      for (int i = 1; i <= L; ++i)
          ans = max(ans, p[i] + ricavo(L - i));
      return ans;
  }
  ```

  La soluzione appena descritta è terribilmente inefficiente: calcoliamo un numero esponenziale in $N$ di volte gli stessi valori. Se una volta ottenuti i valori si memorizzassero, ognuno verrebbe calcolato al più una volta. È quindi naturale salvare le risposte ai sottoproblemi una volta calcolate: questa tecnica è detta #emph[memoizzazione]#footnote[No, non è un errore di battitura. Si chiama _memoizzazione_ non _memorizzazione_.].

  Manteniamo opportuni array o mappe (se ci tieni -- sigh -- globali, ma non è necessario) a indicare (a) se abbiamo già calcolato la risposta per un dato $L$ e (b) qual è questa risposta già calcolata
  #footnote[Le due informazioni si possono accorpare se a un valore inutilizzato, come in questo caso $-1$, si dà il significato di "risposta non ancora calcolata".].
  In pratica modifichiamo leggermente l'implementazione della funzione $"ricavo"$.
  ```cpp
  LL ricavo(int L) {
      if (memo[L] != -1)
          return memo[L];
      LL ans = 0;
      for (int i = 1; i <= L; ++i)
          ans = max(ans, p[i] + ricavo(L - i));
      return memo[L] = ans;
  }
  ```

  Un'osservazione tanto semplice ha effetti straordinari sulla complessità, che da esponenziale scende a $cal(O)(N^2)$.

  In questo e altri casi in cui esiste un naturale concetto di "taglia" di un sottoproblema possiamo calcolare le risposte ai vari sottoproblemi in maniera #emph[iterativa]:
  ```cpp
  vector<LL> ricavo(N + 1); // inizializzato a zero
  for (int L = 1; L <= N; ++L)
      for (int i = 1; i <= L; ++i)
          ricavo[L] = max(ricavo[L], p[i] + ricavo[L - i]);
  ```
]

*Esercizio:* capire perché una chiamata a $"ricavo"(N)$ comporta esattamente $2^(N-1)$ chiamate a $"ricavo(0)"$ e un totale di $2^N$ chiamate a $"ricavo"$.

Facciamo un passo indietro e generalizziamo: più spesso di quanto forse non crederesti la soluzione di un problema si ricava più o meno facilmente da soluzioni per istanze "più piccole" dello stesso problema... che a loro volta si spezzano in istanze più piccole e così via, finché non rimangono istanze banali dette #emph[casi base]. Dai casi base, in maniera iterativa o ricorsiva, si costruiscono le soluzioni ai sottoproblemi che intendiamo risolvere. Nota l'analogia con l'induzione matematica.

La programmazione dinamica è un concetto naturale, la sfida è identificare la famiglia di sottoproblemi da risolvere (di cui il problema originale farà parte) e capire come applicarla. Il modo migliore per imparare la programmazione dinamica è vedere qualche esempio e risolvere (da sé) un buon numero di problemi.

*Attenzione!* Nelle sezioni che seguono troverai spiegate le soluzioni di alcuni problemi.

// No: c'è su algobadge
// == Treni
// #problem("Treni", url: "https://training.olinfo.it/task/preoii_treni", lbl: "preoii_treni",
// [
// Adori viaggiare in treno
// Ogni giorno per i prossimi $N$ giorni scegli se prendere un treno della SuperFastTravels#super[(TM)], della HyperFastTravels#super[(C)] o se non viaggiare affatto.
// Conosci per ogni giorno le durate $A_i, B_i$ delle tratte offerte dalle due società, il
// tuo obiettivo è  massimizzare il tempo totale che trascorrerai a bordo sapendo che
// è possibile prendere un treno della seconda solo se il giorno precedente
// non si è preso nessun treno.
// ]
// )

#problem("Coin Combinations I", url: "https://cses.fi/problemset/task/1635", lbl: "coin-comb-I", tags: ("cses",))[
  Dato un sistema monetario di $N$ monete con valore distinti $c_1, dots, c_N$ e una somma $X$, conta modulo $10^9 + 7$ le pile distinte di monete con somma $X$. Due pile composte dalle stesse monete in ordine diverso si considerano distinte.
][
  Una ragionevole famiglia di sottoproblemi da risolvere in questo caso è, a sistema monetario fissato, l'insieme delle istanze con somma obiettivo $Y <= X$. Sia allora $"conta"[Y]$ il numero di modi di ottenere somma $Y$. Quante delle pile con somma $Y$ hanno in cima una moneta di valore $c_i$? Esattamente $"conta"[Y - c_i]$
  #footnote[Sembra vero. Per convincere gli scettici diremmo che l'operazione "aggiungi la moneta $c_i$ in cima" è una corrispondenza biunivoca tra le pile con somma $Y - c_i$ e quelle con somma $Y$ che terminano in $c_i$.].
  Per contare le pile con somma $Y$, quindi, possiamo sommare le pile con somma $Y$ e ultima moneta $c_i$ al variare di $c_i$:

  $
  "conta"[Y] = cases(
    0 & " se " Y < 0,
    1 & " se " Y = 0,
    sum_(i = 1)^(N) "conta"[Y - c_i] & " altrimenti "
  )
  $

  Una possibile implementazione è la seguente:
  ```cpp
  vector<int> conta(x + 1);
  conta[0] = 1;
  for (int y = 1; y <= x; ++y)
      for (int i = 0; i < n; ++i)
          if (y >= c[i])
              conta[y] = (conta[y] + conta[y - c[i]]) % mod;
  ```

  La complessità temporale è $cal(O)(N X)$, quella spaziale $cal(O)(N + X)$.
]

#problem("Coin Combinations II", url: "https://cses.fi/problemset/task/1636", lbl: "coin-comb-II", tags: ("cses",))[
  Come Coin Combinations I, ma conta questa volta i _sottoinsiemi_ di monete: due pile ottenibili l'una dall'altra per permutazione si considerano ora equivalenti.
][
  Cerchiamo innanzitutto una pila rappresentante per ogni sottoinsieme di monete: una scelta ragionevole è quella le cui monete sono ordinate per valore crescente. La famiglia di sottoproblemi in questo caso è "In quanti modi fondamentalmente distinti si ottiene somma $Y$ avendo a disposizione i primi $i$ tipi di monete?" al variare di $Y <= X$, $i <= N$. Fissati i casi base, vale la ricorsione $"conta"[Y][i] = "conta"[Y][i - 1] + "conta"[Y - c_i][i]$. L'implementazione diretta costa $cal(O)(N X)$ tempo e memoria, ma si può fare meglio di così! Se immaginiamo di aggiungere al sistema monetario una moneta alla volta otteniamo una soluzione $cal(O)(N X)$ tempo e $cal(O)(N + X)$ memoria:
  ```cpp
  vector<int> conta(X + 1);
  conta[0] = 1;
  for (int i = 0; i < N; ++i)
      for (int y = c[i]; y <= X; ++y)
          conta[y] = (conta[y] + conta[y - c[i]]) % mod;
  ```

  Alla fine di ogni iterazione del primo `for`, il vettore `conta` contiene ad ogni posizione $Y$ il numero di modi di ottenere $Y$ con le prime $i$ monete. Nota che è importante l'ordine in cui si itera sugli $Y$: se il `for` fosse stato da $X$ a $c[i]$, avremmo risolto il problema con l'ulteriore restrizione di poter usare ogni moneta al più una volta.
]

// book shop (?), cses
*Bonus:* più in generale, qual è la risposta se la $i$-esima moneta si può usare un massimo di $m_i$ volte? Si può fare meglio di complessità temporale $cal(O)(N sum_i m_i)$?
#footnote[La risposta è... non lo so. Sicuramente se tutti gli $m_i$ sono uno in meno di una potenza di due, la risposta è sì.]

#problem("Massima sottosequenza comune", url: "https://cses.fi/problemset/task/3403", lbl: "lcs", tags: ("cses",))[
  Un'array si dice #emph[sottosequenza] di un altro array se il primo si può ottenere dal secondo eliminando alcuni elementi (possibilmente nessuno) senza cambiare l'ordine degli elementi rimanenti.
  Dati due array $a_1, a_2, ..., a_n$ e $b_1, b_2, ..., b_m$ rispettivamente di $n$ e $m$ elementi, si trovi una sottosequenza comune di lunghezza massima.
][
  Preoccupiamoci innanzitutto di trovare la lunghezza.
  Rispondiamo alla domanda per ogni possibile coppia prefisso del primo array e prefisso del secondo array: sia quindi $"lcs"[i][j]$ la lunghezza della massima sottosequenza comune tra i primi $i$ elementi di $a$ e i primi $j$ elementi di $b$.

  Calcoliamo $"lcs"[i][j]$ supponendo di conoscere le risposte ai sottoproblemi più piccoli. Se $a_i = b_j$, non c'è motivo di non includere gli ultimi elementi nella sequenza#footnote[È intuitivo, ma perché? Va dimostrato che per ogni soluzione ottimale, esiste una soluzione almeno altrettanto buona]. Se invece $a_i != b_j$, allora (almeno) uno tra $a_i$ non farà pare della sottosequenza comune, nel cui caso la risposta è una tra $"lcs"[i - 1][j]$ e $"lcs"[i][j - 1]$. In altre parole, vale il seguente:

  $
  "lcs"[i][j] = cases(
    0 & " se " i = 0 " o " j = 0,
    1 + "lcs"[i - 1][j - 1] & " se " a_i = b_j,
    max("lcs"[i - 1][j], "lcs"[i][j - 1]) & " altrimenti"
  )
  $

  Una possibile implementazione è la seguente:
  ```cpp
  vector<vector<int>> lcs(n + 1, vector<int>(m + 1));
  for (int i = 1; i <= n; ++i) {
      for (int j = 1; j <= m; ++j) {
          if (a[i] == b[j])
              lcs[i][j] = 1 + lcs[i - 1][j - 1];
          else
              lcs[i][j] = max(lcs[i][j - 1], lcs[i - 1][j]);
      }
  }
  ```

  Data la matrice $"lcs"$, come ricostruiamo una sottosequenza massimale e non solo la sua lunghezza? In ordine inverso! Manteniamo due indici $i, j$, inizialmente uguali a $n, m$, che indicano i prefissi di cui stiamo calcolando la massima sottosequenza comune. Conoscendo gli array $a_i, b_j$ e i valori di $"lcs"$ possiamo capire la provenienza del valore (ottimo) di $"lcs[i][j]"$ e, nel caso in cui $a_i = b_j$, aggiungere un carattere alla risposta. Una possibile implementazione è la seguente#footnote[quello a riga 16 è un bieco trucco per stampare un a capo a fine output.].

  ```cpp
  int i = n, j = m;
  vector<int> ans;
  while (lcs[i][j]) {
      if (a[i] == b[j]) {
          ans.push_back(a[i]);
          --i, --j;
      } else {
          if (lcs[i][j] == lcs[i - 1][j])
              --i;
          else
              --j;
      }
  }
  reverse(begin(ans), end(ans));
  for (int i = 0; i < lcs[n][m]; ++i)
      cout << ans[i] << " \n"[i == lcs[n][m] - 1];
  ```
]

#problem("Monopoly Board Game", url: "https://training.olinfo.it/task/ois_monopoly", lbl: "ois_monopoly", tags: ("ois", "2022-23"))[
  Giochi a Monopoli su un tabellone circolare di $N$ caselle, numerate da $0$ a $N-1$ con le caselle $N-1$ e $0$ adiacenti.
  Ogni casella ha un valore di imposta $T_i$ associato. Ogni volta che un giocatore atterra su una casella, deve pagare il rispettivo valore di imposta
  (il valore può essere negativo, nel cui caso il giocatore riceve denaro).
  Carlo parte dalla casella $0$ e giocherà $K$ turni di Monopoli. Ogni turno lancia due dadi a 6 facce e avanza della somma dei due valori,
  poi paga l'imposta della casella su cui atterra. Se i due valori dei dadi sono uguali, dopo aver mosso e pagato, lancia nuovamente i dadi.
  Carlo può muovere al massimo tre volte in un singolo turno, dopodiché il suo turno termina automaticamente (anche se i due valori dei dadi sono uguali).
  Poiché non accetti di perdere, hai truccato i dati e controlli l'esito di tutti i lanci. Il tuo obiettivo è massimizzare la quantità di denaro che Carlo perde durante il gioco.
][
  Una valida famiglia di sottoproblemi da risolvere in questo caso è "qual è la risposta per $k$ turni se termino il $k$-esimo turno sulla casella $i$ con $l$ lanci". Alternativamente, il limite di tempo permette una soluzione più lenta ma più semplice i cui stati sono solo le coppie $k$, $i$ con $0 <= k <= K$ e $0 <= i < N$. Un'implementazione del primo approccio si trova #link("https://github.com/franfill1/training.olinfo.it-solutions/blob/master/src/ois_monopoly.cpp")[qui], una del secondo a #link("https://github.com/lorenzo-ferrari/olinfo/blob/main/src/ois_monopoly.cpp")[questo link].

  Invitiamo a notare che per quanto la programmazione dinamica in questione abbia $cal(O)(N K)$ stati, i valori all'$(i+1)$-esimo turno dipendono esclusivamente da quelli all'$i$-esimo turno, quindi la soluzione si può implementare in $cal(O)(N)$ memoria.
]

=== Esercizi consigliati

Innanzitutto ti consigliamo di risolvere i problemi della sezione "dp" su #link("https://training.olinfo.it/algobadge")[algobadge]. Dopodiché, se hai bisogno di altro _classicismo_, proponiamo la sezione "Dynamic Programming" di #link("cses.fi/problemset"). Proponiamo qui sotto problemi più croccanti e di vari livelli di difficoltà (non minori di algobadge).

// preoii_treni e ois_nonna stanno già su algobadge:
// - #link("https://training.olinfo.it/task/preoii_treni")
// - #link("https://training.olinfo.it/task/ois_nonna")
- #link("https://training.olinfo.it/task/tai_cct2")
- #link("https://training.olinfo.it/task/zigzag")
- #link("https://training.olinfo.it/task/preoii_yutaka")
- #link("https://training.olinfo.it/task/oii_coda")
- #link("https://training.olinfo.it/task/oii_bastioni")
- #link("https://training.olinfo.it/task/oii_orticoltura")
- #link("https://cses.fi/problemset/task/1665")[Coding Company]
- #link("https://training.olinfo.it/task/ois_tulips")
- #link("https://training.olinfo.it/task/preoii_pokemongo")


*_Commenti:_* tra quelli elencati, i problemi preferiti della persona che sta scrivendo sono oii_coda e Coding Company, ma anche preoii_yutaka è molto bello. Non tutti i problemi sopra si risolvono pensando esclusivamente in termini di programmazione dinamica. Un esempio: per zigzag e ois_tulips fa comodo avere prima visto #link("https://cses.fi/problemset/task/1645")[Nearest Smaller Values] in $cal(O)(N)$
#footnote[È una tecnica comune a cui vale la pena pensare. Se siete bloccati per troppo tempo, chiedete e il link da cui imparare vi sarà dato.],
// #link("https://cp-algorithms.com/data_structures/stack_queue_modification.html")
che vi apre la piacevolissima strada secondaria di #link("https://cses.fi/problemset/task/1142")[Advertisement] e #link("https://cses.fi/problemset/task/1147")[Maximum Building I]
#footnote[Se vuoi percorrere questa strada, l'unico indizio che ti diamo è: "pensa molto forte al problema precedente".].
