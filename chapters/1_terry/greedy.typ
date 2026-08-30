#import "/templates/page.typ": project
#import "/utils/render.typ": is-web

#let render = if is-web { project.with(title: "Problemi greedy") } else { it => it }
#show: render

#import "../../utils/problems.typ": *
#import "../../utils/exercises.typ": *


== Problemi greedy

Come suggerisce il nome, nei problemi che vedremo tra poco la strategia vincente è comportarsi da avari, ovvero in ogni momento scegliere la soluzione localmente ottima.
Analizziamo ad esempio la seguente situazione:

#problem("Gelati costosi", url: "https://training.olinfo.it/task/pre-egoi-gelato", lbl: "gelati-costosi")[
    Ci servono $C$ soldi per comprare il gelato e $N$ nostri amici sono disposti a prestarcene un po'. 
    L'$i$-esimo amico ci può prestare al massimo $P_i$ soldi.
    Qual è il numero minimo di amici a cui dobbiamo chiedere in prestito dei soldi per poter prendere il gelato?
][
  È un problema abbastanza semplice di cui sappiamo delineare intuitivamente una strategia risolutiva: chiedo ogni volta all'amico che mi dà più soldi finché non arrivo ad avere $C$ soldi.

  Questa strategia si rivela essere quella ottimale! Di seguito l'implementazione:

  ```cpp
  int presta(int N, int C, vector<int> P) {
      sort(begin(P), end(P));
      int risposta = 0;
      while (C > 0) {
          risposta++;
          C -= P.back();
          P.pop_back();
      }
      return risposta;
  }
  ```

  La lezione che ne traiamo è che, in certi problemi, a una scelta _localmente ottima_ formulata nel modo corretto (in questo caso chiedere ogni volta all'amico che ci dà più soldi) corrisponde una soluzione _globalmente ottima_ (che per questo problema significa minimizzare il numero di amici a cui chiedere).
]

Un possibile criterio che ci suggerisce che il problema si possa risolvere in modo greedy è che le scelte che facciamo siano indipendenti tra loro. 
In questo caso chiedere a un amico non pone vincoli sugli amici ai quali potremo chiedere successivamente.

Ad ogni modo, il miglior metro per capire se a un problema si possa applicare un approccio greedy è l'esperienza.
Vediamo quindi altri problemi:

#problem("Viaggio in taxi", url: "https://training.olinfo.it/task/ois_taxi", lbl: "viaggio-in-taxi", tags: ("ois", "2014-15"))[
    Dobbiamo passare per $N$ città in fila (numerate da $0$ a $N - 1$), equidistanti tra loro, e arrivare alla fine nella città numero $N$. 
    Nella città $i$ è presente un taxi che ci può portare alla città successiva $i + 1$ a un costo di $C_i$ soldi. 
    Arrivati alla città successiva, se non siamo arrivati alla città $N$, possiamo scegliere se proseguire prendendo il taxi presente in quella città per $C_(i + 1)$ soldi o rimanere sullo stesso taxi, che però aumenterà di $1$ soldo il suo prezzo per ogni città successiva alla propria città di partenza.
][
  Facendo un esempio per capire meglio il testo, se nella prima città il taxi costa $3$ soldi, possiamo pagare $3$ per prenderlo e andare alla seconda città.
  Se nella seconda città il taxi costa $5$, possiamo scegliere se prendere quel taxi pagando $5$ o rimanere sul nostro taxi pagando questa volta $4$.
  Se rimaniamo sul nostro taxi, alla stazione successiva pagheremo $5$, e così via.

  Anche in questo problema la strategia intuitiva di prendere sempre il taxi che ci costa meno funziona perché in ogni caso entrambi aumenterebbero il loro prezzo di $1$ soldo a ogni stazione successiva.
  Quindi se il taxi $A$ costa meno del taxi $B$ in una certa città, costerà di meno anche in tutte le successive.

  ```cpp
  int viaggia(int N, vector<int> C) {
      int costo_totale = 0;
      int costo_attuale = INT_MAX;
      for (int i = 0; i < N; i++) {
          if (costo_attuale > C[i])
              costo_attuale = C[i];
          costo_totale += costo_attuale;
          costo_attuale += 1;
      }
      return costo_totale;
  }
  ```
]

#problem("Mozzarelle di bufala", url: "https://training.olinfo.it/task/oii_bufale", lbl: "mozzarelle-di-bufala", tags: ("oii", "2013"))[
    Ci sono $N$ mozzarelle ($N$ è un numero pari). 
    Alla $i$-esima mozzarella Monica dà il voto $M_i$ e Paola il voto $P_i$. 
    Dobbiamo dividere le mozzarelle in due gruppi da $N/2$ ciascuno in modo da massimizzare la somma dei voti nel rispettivo gruppo, cioè la somma dei voti che Monica dà alle sue $N/2$ mozzarelle + i voti che Paola dà alle altre $N/2$ mozzarelle.
][
  In questo caso il primo approccio greedy che viene in mente potrebbe essere quello di ordinare le mozzarelle per uno dei due voti -- diciamo quello di Monica -- per poi assegnare le prime $N/2$ a Monica e le restanti a Paola.

  Questa strategia non funziona perché non stiamo tenendo conto di entrambi i voti: supponiamo di avere solo due mozzarelle; la prima vale $10$ per Monica e $9$ per Paola e la seconda vale $8$ per Monica e $2$ per Paola.
  Seguendo la precedente strategia finiremmo per assegnare la prima a Monica ottenendo somma $12$ quando è ottimale il contrario, riuscendo ad ottenere somma $17$.

  Da questa osservazione ci potrebbe venire in mente di dividere le mozzarelle in base a quanto cambia assegnarla a Monica anziché a Paola.
  Una mozzarella che vale $10$ per la prima e $9$ per la seconda è meno rilevante di una che vale $8$ per la prima e $2$ per la seconda.

  Per fare ciò ordiniamo le mozzarelle per la differenza tra il voto che dà Monica e quello che dà Paola.

  Posto $D_i = M_i - P_i$, le mozzarelle con $D_i$ alto sono preferite da Monica rispetto a Paola; viceversa, se $D_i$ è piccolo, sarà più conveniente assegnarle a Paola. Questa soluzione si rivela essere ottimale.
  ```cpp
  long long solve(int N, int* M, int* P) {
      vector<pair<int, int>> D(N);
      for (int i = 0; i < N; i++) {
          D[i] = {M[i] - P[i], i};
      }
      sort(begin(D), end(D));

      long long somma = 0;
      for (int i = 0; i < N; i++) {
          int idx = D[i].second;
          if (i < N / 2) {
              somma += P[idx];
          } else {
              somma += M[idx];
          }
      }
      return somma;
  }
  ```

  *Note sull'implementazione:*

  - $D$ contiene anche l'indice cui la differenza si riferisce in modo da poter risalire alla mozzarella una volta ordinate le differenze.
  - $D$ è ordinato in ordine crescente, quindi le prime mozzarelle saranno quelle con $D_i$ più basso, da assegnare a Paola.
  - Curiosità: sarebbe possibile risolvere il problema in $cal(O)(N)$ utilizzando l'algoritmo `std::nth_element` della STL per trovare il valore della differenza secondo cui dividere le mozzarelle.
]

I problemi greedy possono apparire semplici, tuttavia in certi casi trovare la strategia localmente ottima non è per nulla banale (vedi gli esercizi suggeriti).

=== Problemi consigliati
#exercise("Bus Excursion", "https://training.olinfo.it/task/ois_excursion2", diff: 1)
#exercise("Library of Binaria", "https://training.olinfo.it/task/ois_binaria", diff: 2)
#exercise("Il pozzo", "https://training.olinfo.it/task/pozzo", diff: 3)
