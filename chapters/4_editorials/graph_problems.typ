#import "/templates/page.typ": project
#import "/utils/render.typ": is-web

#let render = if is-web { project.with(title: "Problemi di grafi") } else { it => it }
#show: render

#import "../../utils/problems.typ": *


// non sono in ordine di difficoltà
== Problemi di grafi <graph_problems>

#problem("Find the Treasure", url: "https://training.olinfo.it/task/ois_islands", lbl: "ois_islands", tags: ("OIS", "2020"))[
  È data una mappa $R times C$ in cui ogni casella è mare o terraferma. Un'isola è un insieme di caselle di terraferma connesse tra loro che non tocca il bordo della mappa. Conta le isole.
][
  La tua visita preferita permette di risolvere il problema in $cal(O)(R C)$. Una possibile implementazione è la seguente. Nota l'utilizzo degli array `dx` e `dy` per visitare convenientemente i vicini di ogni cella.

	```cpp
	int main() {
		int r;
		cin >> r;
		int c;
		cin >> c;
		vector<vector<int>> land(r, vector<int>(c));
		for (int i = 0; i < r; i++)
			for (int j = 0; j < c; j++)
				cin >> land[i][j];

		auto exists = [&](int x, int y) -> bool {
			return 0 <= x && x < r && 0 <= y && y < c;
		};

		constexpr array<int, 4> dx{+1, 0,-1, 0};
		constexpr array<int, 4> dy{ 0,+1, 0,-1};
		vector<vector<bool>> vis(r, vector<bool>(c));
		auto dfs = [&](auto&& self, int x, int y) -> void {
			if (!land[x][y])
				return;
			vis[x][y] = true;
			for (int i = 0; i < 4; i++) {
				int nx = x + dx[i];
				int ny = y + dy[i];
				if (exists(nx, ny) && !vis[nx][ny])
					self(self, nx, ny);
			}
		};

		for (int y = 0; y < c; y++) {
			dfs(dfs, 0, y);
			dfs(dfs, r - 1, y);
		}
		for (int x = 0; x < r; x++) {
			dfs(dfs, x, 0);
			dfs(dfs, x, c - 1);
		}

		int count_islands = 0;
		for (int x = 1; x < r - 1; x++)
			for (int y = 1; y < c - 1; y++)
				if (land[x][y] && !vis[x][y]) {
					count_islands++;
					dfs(dfs, x, y);
				}

		cout << count_islands << "\n";
	}
	```
]

#problem("Imprevisti di viaggio", url: "https://training.olinfo.it/task/preoii_grandistazioni", lbl: "preoii_grandistazioni", tags: ("pre-oii", "2024"))[
  Luca si trova sul nodo $0$ di un grafo diretto pesato di $N$ nodi e $M$ archi e deve arrivare al nodo $N - 1$.
  Segue sempre la strada più veloce ma la prima volta che passa per alcuni nodi viene teletrasportato su un nodo diverso.
  È garantito che in ogni momento la scelta ottimale è unica e che da ogni nodo è possibile raggiungere il nodo $N-1$,
  dopo quanto tempo Luca arriverà finalmente a destinazione?
][
  Un primo passo naturale è cercare di capire, per ciascun nodo, qual è la mossa ottimale che Luca fa quando vi si trova.
  Potremmo ripetere l'algoritmo di Dijkstra per ogni nodo di partenza, ma questo richiederebbe tempo $cal(O)(N(N + M log M))$ che è troppo per i limiti del problema.

  Possiamo tuttavia notare il fatto che il percorso minimo dal nodo $x$ al nodo $N-1$ è semplicemente il percorso minimo tra il nodo $N-1$ e il nodo $x$ nel _grafo trasposto_#footnote[Si dice _grafo trasposto_ di un grafo diretto il grafo che ha gli stessi archi orientati nel verso opposto] al contrario. Questo ci permette di calcolare tutti i cammini minimi verso il nodo $N-1$ con una sola applicazione dell'algoritmo di Dijkstra (partendo da $N-1$ sul grafo trasposto) in $cal(O)(N + M log M)$.

  Chiamiamo $S(x)$ il nodo verso cui esce l'arco ottimale uscente da $x$.

  Resta da capire come seguire in fretta il percorso seguito da Luca, che potrebbe essere composto nel caso peggiore da $Theta(N^2)$
  mosse.

  Facciamo alcune osservazioni:

  + Consideriamo l'insieme degli archi che sono la mossa ottimale quando Luca si trova su un qualche nodo del grafo. Siccome la scelta ottimale è sempre unica, questi sono esattamente $N-1$. Inoltre, il grafo composto da questi $N-1$ archi è connesso: comunque siano presi $x$ e $y$ esistono i percorsi da $x$ a $N-1$ e da $y$ a $N-1$ e pertanto esiste un percorso da $x$ a $y$. Siccome questo grafo ha $N-1$ archi ed è connesso, esso è un albero.
  + Di conseguenza se $y$ è un nodo nel percorso minimo tra $x$ e $N - 1$, vale $d(x, y) = d(x, N - 1) - d(y, N - 1)$ dove $d(u,v)$ è la distanza tra i nodi $u$ e $v$.

  Allora, possiamo comprimere i percorsi seguiti da Luca nel seguente modo. Creiamo un nuovo grafo $cal(H)$, inizialmente vuoto sui nodi del grafo originale e ripetiamo il seguente algoritmo fino a quando Luca non è a destinazione:
  + Sia $x$ il nodo in cui si trova Luca e $y$ il nodo più vicino a $N-1$ nella componente connessa di $x$ in $cal(H)$. Luca si sposta in un certo numero di mosse fino ad $y$ e il loro peso totale è $d(x,y)$ che sappiamo calcolare in $cal(O)(1)$ per l'osservazione precedente.
  + Luca si muove seguendo le regole a partire dal nodo $y$. Qualunque cosa succeda (sia che venga teletrasportato sia che segua l'arco ottimale) sappiamo che d'ora in poi Luca prenderà l'arco ottimale se si trova su $y$, quindi possiamo aggiungere l'arco $(y, S(y))$ a $cal(H)$.

  Notiamo che una singola iterazione di questo algoritmo richiede $cal(O)(alpha(N))$ usando una DSU e che dopo $N$ iterazioni sicuramente Luca avrà raggiunto la destinazione. Pertanto tutto il ciclo richiede $cal(O)(N alpha(N))$.
]

#problem("Attenti all'incendio", url: "https://training.olinfo.it/task/oii_incendio", lbl: "oii_incendio", tags: ("oii", "2018"))[
  Su una griglia $N times N$ sono stati appiccati $M$ incendi che all'inizio occupano ciascuno una singola casella.
  Ogni secondo, ogni casella in fiamme mette in fiamme anche le quattro caselle adiacenti. Qual è l'ultimo momento in cui
  esiste un percorso da $(0, 0)$ a $(N - 1, N - 1)$ che non passa per nessuna casella in fiamme?
][
  L'osservazione cruciale è che affinché le fiamme ostruiscano completamente il percorso esse collegare ininterrotamente un punto sul lato "basso" o sul lato "sinistro" con un punto sul lato "alto" o sul lato "destro" della griglia.

	Allora è naturale costuire il un grafo sulle $M$ caselle inizialmente incendiate più due nodi speciali che rappresentano i bordi della griglia e in cui:
	+ Due caselle inizialmente incendiate sono collegate da un arco di peso pari al tempo minimo dopo cui gli incendi generati dalle due caselle si toccano (che è possibile calcolare in $cal(O)(1)$)
	+ Ogni casella è collegata a ciascun bordo con un arco di peso pari al tempo minimo dopo cui l'incendio generato da essa raggiunge quel bordo (anche questo si può calcolare in $cal(O)(1)$)

	A questo punto si può usare l'algoritmo di Dijkstra per trovare la minima distanza tra i due bordi, con l'accortezza di usare il massimo e non la somma dei pesi degli archi come peso di un percorso#footnote[Questa variante dell'algoritmo è nota come algoritmo di Prim e lasciamo come esercizio al lettore la dimostrazione della sua correttezza, così come quella del fatto che l'albero dei cammini minimi trovato questo algoritmo sia un MST].
	Questa soluzione tuttavia ha complessità $cal(O)(M^2 log M)$ che è leggermente troppo lenta per i limiti del problema.

	Analizziamo dunque due possibili implementazioni dell'algoritmo di Dijkstra su un grafo con $V$ nodi ed $E$ archi:
	+ Tenere i nodi in una priority queue, che richiede nel caso pessimo $Theta(E)$ inserzioni nella priority queue e ha complessità $cal(O)((V + E)log E)$
	+ Scorrere i nodi a ogni iterazione per trovare quello a distanza minima, che ha complessità $cal(O)(V^2 + E)$

  Notiamo come la seconda possibilità sia in realtà la migliore#footnote[In realtà esiste una terza opzione asintoticamente migliore di entrambe che fa uso dei Fibonacci Heap per ottenere complessità asintotica $cal(O)(E + V log V)$. Seppure di interesse teorico, questa implementazione è difficoltosa e poco utile nella pratica per via dell'elevato fattore costante] per grafi _densi_, cioè grafi in cui $E approx V^2$. Siccome questo è esattamente il nostro caso, la complessità è abbassata a $cal(O)(M^2)$.
]

#problem("Codex Botanicus", url: "https://training.olinfo.it/task/oii_botanicus", lbl: "oii_botanicus", tags: ("oii", "2024"))[
  Dato un albero di $N$ radicato in $0$, si vuole staccare alcuni nodi dall'albero in modo che:
  - Il nodo $0$ non venga staccato e i nodi non staccati siano tutti connessi;
  - Tutte le foglie siano alla stessa _profondità_ (cioè alla stessa distanza dal nodo $0$).
  Determinare qual è il minimo numero di nodi che è necessario staccare dall'albero.
][
  Ha senso affrontare il problema provando a fissare qualche quantità. Proviamo a fissare l'altezza delle foglie che vengono lasciate, cioè a chiederci quanti nodi al minimo vanno staccati se alla fine le foglie sono tutte ad altezza $h$. La risposta è che basta e bisogna staccare i nodi:
  + che sono a profondità maggiore di $h$, altrimenti ovviamente esisterebbero foglie troppo profonde
  + che hanno nel proprio sottoalbero solo foglie a profondità minore di $h$, altrimenti esisterebbero foglie troppo poco profonde.

  Questo ci dice che ogni nodo $0 <= i < N$ ha due grandezze caratteristiche: la sua profondità $A_i$ e la massima profondità di una sua foglia $B_i$ e che esso può restare nell'albero finale se e solo se $A_i <= h <= B_i$.

  Il problema si riduce, dopo aver calcolato $A_i$ e $B_i$, a trovare l'altezza $h$ per cui passa il maggior numero di segmenti $[A_i, B_i]$ che si risolve in modo abbastanza semplice in $cal(O)(N)$.

  Anche il calcolo di $A_i$ e $B_i$ è una semplice programmazione dinamica in $cal(O)(N)$.
]

#problem("Arte nei corridoi", url: "https://training.olinfo.it/task/oii_corridoi", lbl: "oii_corridoi", tags: ("oii", "2023"))[
  Dato un grafo pesato di $N$ nodi e $M$ archi, e rispondere a $Q$ richieste del tipo:
  - Dopo aver abbassato i pesi degli archi di al più $K$ in totale (e senza mai rendere negativo alcun peso), qual è il minimo peso di un percorso che va dal nodo $0$ al nodo $2$ passando dal nodo $1$?
][]
