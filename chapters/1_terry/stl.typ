#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#import "../../utils/problems.typ": *

#let vrow(fn, complexity, desc) = (fn, complexity, desc)

#let vtable(..rows) = {
  let cells = (
    [#text(weight: "semibold")[Funzione]],
    [#text(weight: "semibold")[Complessità]],
    [#text(weight: "semibold")[Descrizione]],
  )
  for row in rows.pos() {
    cells = cells + row
  }
  table(
    columns: (auto, auto, 1fr),
    gutter: 0em,
    ..cells,
  )
}


== Standard Template Library (STL)

=== Introduzione

La Standard Template Library (abbr. STL) è una collezione di algoritmi, strumenti e _strutture dati_ pensate per essere facilmente integrate nel codice. Nell'ambiente della programmazione competitiva vengono spesso utilizzate per via della loro semplicità d'uso e velocità nell'implementazione. La documentazione della STL è disponibile su #link("https://www.cppreference.com"), da cui è anche possibile consultare la complessità temporale delle operazioni sulle strutture.

Tutte le funzionalità della STL sono racchiuse dal namespace `std`. Per comodità possiamo includere all'inizio del codice tutto il namespace tramite `using namespace std;`, in modo da scrivere, per esempio, `vector<int>` invece di `std::vector<int>`. Inoltre, ogni funzionalità della STL è racchiusa in una libreria che andrà importata all'inizio del file. Ad esempio, `vector` sta nella libreria `<vector>`, `sort` sta in `<algorithm>`, e così via. Anche qui possiamo semplificarci la vita usando la libreria `<bits/stdc++.h>` che include automaticamente _quasi_#footnote("Alcune funzionalità come le PBDS non sono incluse.") tutta la STL. Da ora in avanti, assumeremo che il namespace `std` e `<bits/stdc++.h>` siano stati importati.

=== Struttura dati

Una _Struttura dati_ è un modo intelligente di organizzare informazioni che permetta di supportare determinate operazioni in maniera efficiente. In questo capitolo studiamo come sfruttare al meglio alcune strutture dati già implementate nella libreria standard C++, cioè `vector`, `queue`, `pair`, `set`, `priority_queue`, `map`.

Alcune strutture dati più complesse non sono implementate nella STL, ed andranno perciò implementate a mano. Ci occuperemo di queste strutture nei capitoli futuri.

Inoltre, tutte le strutture della STL supportano queste operazioni:

#vtable(
  vrow([`size()`], [$cal(O)(1)$], [Restituisce il numero di elementi contenuti.]),
  vrow([`empty()`], [$cal(O)(1)$], [Restituisce `true` se la struttura non contiene elementi.]),
)

=== Iteratori 

Un iteratore è un oggetto che punta ad uno specifico elemento della struttura dati. Sotto molti punti di vista è simile ad un puntatore. Gli iteratori sono molto utili e vengono usati dalle funzioni della STL che operano su strutture della STL. Per accedere all'elemento puntato dall'iteratore precediamo esso con un `*`. Vediamo un esempio:

```cpp
vector<int> a = {10, 20, 30};
auto it = a.begin(); // it punta a 10
cout << *it << endl; // stampa 10
++it;                 // it punta a 20
cout << *it << endl;  // stampa 20
```

Possiamo passare all'elemento successivo con `next(it)` (oppure incrementando direttamente l'iteratore con `++it` o `it++`), e a quello precedente con `prev(it)` (oppure `--it`). Inoltre è importante notare che se abbiamo una struttura, ad esempio un vettore `V`, allora `V.begin()` punta al primo elemento del vettore (se esiste), mentre `V.end()` punta all'elemento subito dopo l'ultimo (ovvero a memoria non allocata). Se `V` è vuoto vale `V.begin() == V.end()`.

=== `vector`
inclusa in `<vector>`

`vector` è forse la struttura dati più semplice della STL: può essere pensata come un _array dinamico_, che si ridimensiona automaticamente quando necessario.

// TODO: inserire immagine di un vector
Supporta le seguenti operazioni principali:

#vtable(
  vrow([`push_back(x)`], [$cal(O)(1)$ _ammortizzata_], [Aggiunge `x` in fondo al vettore.]),
  vrow([`pop_back()`], [$cal(O)(1)$], [Rimuove l'ultimo elemento del vettore.]),
  vrow([`at(i)`], [$cal(O)(1)$], [Restituisce un riferimento all'elemento in posizione `i`. Si può ottenere lo stesso effetto (ma senza controllo dei limiti, più veloce) con l'operatore `[i]`.]),
  vrow([`insert(it, x)`], [$cal(O)(N)$ #footnote($N$ + " è il numero di elementi contenuti dentro la struttura dati al momento dell'operazione.")], [Inserisce `x` nella posizione indicata dall'iteratore `it`. Richiede lo spostamento di tutti gli elementi successivi.]),
  vrow([`erase(it)`], [$cal(O)(N)$], [Rimuove l'elemento nella posizione indicata da `it`.]),
  vrow([`clear()`], [$cal(O)(N)$], [Rimuove tutti gli elementi.]),
  vrow([`front()` / `back()`], [$cal(O)(1)$], [Restituiscono un riferimento rispettivamente al primo e all'ultimo elemento.]),
  vrow([`begin()` / `end()`], [$cal(O)(1)$], [Restituiscono iteratori all'inizio e alla fine del vettore.]),
  vrow([`resize(n)`], [$cal(O)(N)$], [Ridimensiona il vettore in modo che contenga `n` elementi. Se `n` è minore della dimensione attuale, gli elementi in eccesso vengono rimossi; se è maggiore, i nuovi elementi vengono inizializzati con il valore di default (o con il valore passato come secondo argomento opzionale `resize(n, val)`). _Nota bene:_ `resize` non rimuove gli elementi già presenti: se `n` è maggiore della dimensione attuale, gli elementi esistenti rimangono invariati e vengono semplicemente aggiunti nuovi elementi in coda, mentre se `n` è minore, i primi `n` elementi vengono mantenuti e solo quelli in eccesso vengono rimossi.]),
)

`push_back` è $cal(O)(1)$ _ammortizzata_ perché, quando il vettore esaurisce lo spazio allocato, la sua capacità viene raddoppiata e tutti gli elementi vengono ricopiati in un nuovo blocco di memoria contiguo, il che ha complessità $cal(O)(N)$. Per risparmiare del tempo, se sappiamo in anticipo quanti elementi avrà il nostro vettore (anche una stima per eccesso va bene), possiamo pre-allocare la memoria per $n$ elementi tramite `reserve(n)`. 

*Nota bene:* alcune operazioni, come `push_back`, `insert` o `erase`, possono invalidare gli iteratori esistenti su un `vector` (ad esempio se il vettore viene ricopiato in un nuovo blocco di memoria durante un ridimensionamento). Usare un iteratore invalidato è un comportamento indefinito.

=== `queue`
inclusa in `<queue>`

// TODO: Immagine di una queue
`queue` è una struttura dati che implementa una coda *FIFO* (_First In, First Out_): l'elemento che viene inserito per primo è anche il primo ad essere rimosso. Permette di eseguire le seguenti operazioni:

#vtable(
  vrow([`push(x)`], [$cal(O)(1)$], [Inserisce l'elemento `x` in fondo alla coda.]),
  vrow([`pop()`], [$cal(O)(1)$], [Rimuove l'elemento in cima alla coda (il primo inserito).]),
  vrow([`front()` / `back()`], [$cal(O)(1)$], [Restituiscono un riferimento rispettivamente al primo e all'ultimo elemento.]),
)

La `queue` permette di rimuovere elementi solo in cima alla coda, non dal fondo.

Vediamo un esempio:

```cpp
queue<int> q;
q.push(1);
q.push(2);
q.push(3);

cout << q.front() << endl; // stampa 1 (il primo inserito)
cout << q.back() << endl;  // stampa 3 (l'ultimo inserito)

q.pop(); // rimuove 1
cout << q.front() << endl; // stampa 2
```

=== `pair`
inclusa in `<utility>`

`pair` non è propriamente una struttura dati, ma un semplice contenitore che raggruppa due valori (anche di tipo diverso) in un unico oggetto. È molto usato insieme ad altre strutture della STL (ad esempio dentro un `vector<pair<int,int>>`). Membri:

- `first`: Il primo valore della coppia.
- `second`: Il secondo valore della coppia.

Si può creare con `make_pair(a, b)` oppure direttamente con la sintassi `{a, b}`.

Inoltre, `pair` supporta il confronto (`<`, `==`, ecc.) nel seguente modo: confronta prima `.first`, e solo in caso di parità confronta `.second`. Questo lo rende molto comodo per essere usato dentro un `set` o per l'ordinamento (`sort`) di un `vector` di coppie.

Vediamo un esempio:

```cpp
pair<int, string> p = {1, "oii"};
cout << p.first << " " << p.second << endl; // stampa: 1 oii

vector<pair<int, int>> v;
v.push_back({3, 1});
v.push_back({1, 2});
v.push_back({1, 1});

sort(v.begin(), v.end());
// dopo il sort: (1,1), (1,2), (3,1) 

```


=== `set`
inclusa in `<set>`

`set` è una struttura dati che immagazzina una serie di elementi in modo ordinato, e permette di eseguire le seguenti operazioni:

#vtable(
  vrow([`insert(x)`], [$cal(O)(log N)$], [Inserisce l'elemento `x` nel set.]),
  vrow([`erase(x)`], [$cal(O)(log N)$], [Rimuove l'elemento `x` dal set. Se `x` non è presente l'operazione non ha effetto.]),
  vrow([`find(x)`], [$cal(O)(log N)$], [Trova l'elemento `x` e restituisce un _iteratore_ ad esso. Se `x` non è presente restituisce un iteratore all'elemento subito dopo l'ultimo.]),
  vrow([`begin()` / `end()`], [$cal(O)(1)$], [Restituiscono iteratori all'inizio e alla fine del `set`. `begin()` punta al primo elemento, `end()` alla posizione subito dopo l'ultimo.]),
  vrow([`clear()`], [$cal(O)(N)$], [Rimuove tutti gli elementi.]),
)

*Nota bene:* `set` salva *una sola copia* degli elementi (ovvero non si possono avere elementi duplicati). Una struttura sostanzialmente identica che supporta questa funzionalità è `multiset`.

Vediamo come usare un set in un semplice esempio:

```cpp
set<int> s;
s.insert(5);
s.insert(1);
s.insert(3);
s.insert(1); // non ha effetto, 1 è già presente

for (int x : s) {
  cout << x << " "; // stampa: 1 3 5 (ordinati)
}
cout << endl;

if (s.find(3) != s.end()) {
  cout << "3 è presente nel set" << endl;
}

s.erase(3);
cout << s.size() << endl; // stampa 2
```

Consideriamo un altro esempio pratico.
#problem("Room Allocation", url: "https://cses.fi/problemset/task/1164", lbl: "room-allocation",
[
    L'Olinfo Hotel vuole ospitare $N$ clienti, l'$i$-esimo dei quali vuole alloggiare in una stanza dal giorno $L_i$ al giorno $R_i$. Una stanza non può essere occupata simultaneamente da più persone (cioè affinché due ospiti possano alloggiare nella stessa stanza, i loro intervalli $[L_i, R_i]$, $[L_j, R_j]$ devono essere disgiunti).
    Qual è il minimo numero di stanze affinché l'Olinfo Hotel possa ospitare tutti? Se la risposta è $K$, stabilisci per ogni ospite un numero di stanza da $1$ a $K$.

    $N <= 2 dot 10^5$, $1 <= L_i <= R_i <= 10^9$.
]
)

Intuitivamente, è ottimale ordinare gli eventi in ordine cronologico, per poi simulare la partenza e l'arrivo di ogni cliente nell'ordine giusto. A questo punto, ogni volta che arriva un cliente, è ottimale assegnargli la stanza libera con numero minimo.

*Esercizio:* dimostra quest'ultimo fatto. In particolare, supponi di dare a un cliente una stanza con numero non minimo. A quel punto, la stanza con numero minimo o rimane sempre inutilizzata (e quindi non stai usando il numero minimo di stanze), oppure viene utilizzata da altri clienti in seguito (in questo caso, trova un'altra configurazione di stanze che funziona).

Come trovare la stanza libera con numero minimo? Se controlliamo le stanze una a una, impieghiamo $cal(O)(N)$ per cliente nel caso pessimo (ad esempio, se l'unica stanza libera è l'ultima): serve una struttura dati più veloce. Un `set` è particolarmente adatto perché supporta l'estrazione dell'elemento minimo in tempo $cal(O)(log N)$.

Vorremmo quindi inizializzare un set che contiene tutte le stanze libere, ma non sappiamo quante sono. In ogni caso, usiamo al massimo $N$ stanze, per cui possiamo inizializzare il set con tutti gli interi da $1$ a $N$. Ora:
- ogni volta che un nuovo cliente arriva, estraiamo (e rimuoviamo) il minimo elemento dal set;
- ogni volta che un cliente lascia l'hotel, aggiungiamo nel set il suo numero di stanza.

*Attenzione:* ogni giorno, è importante processare prima gli arrivi e poi le partenze, altrimenti un cliente potrebbe lasciare una stanza e un altro cliente potrebbe occuparla il giorno stesso.

Segue una possibile implementazione. Nota che stiamo ordinando gli eventi prima per tempo, e a parità di tempo per tipo (prima gli arrivi, poi le partenze).

```cpp
int n; cin >> n;
vector<array<int, 3>> eventi;
for (int i = 0, l, r; i < n; i++) {
    cin >> l >> r;
    eventi.push_back({l, 0, i});
    eventi.push_back({r, 1, i});
}
set<int> libere;
for (int i = 1; i <= n; i++)
    libere.insert(i);

sort(begin(eventi), end(eventi));
vector<int> stanza(n, -1);
for (auto [tempo, tipo, cliente] : eventi) {
    if (tipo == 0) {
        stanza[cliente] = *begin(libere);
        libere.erase(begin(libere));
    } else {
        libere.insert(stanza[cliente]);
    }
}

cout << *max_element(begin(stanza), end(stanza)) << "\n";
for (auto u : stanza)
    cout << u << ' ';
cout << "\n";
```

=== `priority_queue`
inclusa in `<queue>`

`priority_queue` è una struttura dati che immagazzina una serie di elementi e permette di accedere rapidamente al *massimo* tra essi (o al minimo, se configurata opportunamente). Nonostante il nome, una `priority_queue` è più simile ad un `multiset` invece di una `queue`. A differenza di `set`, non mantiene gli elementi ordinati internamente in modo accessibile, e non supporta iteratori né la ricerca di un elemento arbitrario, ma supporta elementi duplicati. Permette di eseguire le seguenti operazioni:

#vtable(
  vrow([`push(x)`], [$cal(O)(log N)$], [Inserisce l'elemento `x` nella coda.]),
  vrow([`pop()`], [$cal(O)(log N)$], [Rimuove l'elemento massimo dalla coda.]),
  vrow([`top()`], [$cal(O)(1)$], [Restituisce (senza rimuoverlo) l'elemento massimo attualmente presente nella coda.]),
)

Sembrerebbe che una `priority_queue` sia semplicemente un `multiset` più debole, ma ha un grande vantaggio: è (circa) 2-5x volte più veloce per quanto riguarda inserzioni e rimozioni.

Vediamo un esempio:

```cpp
priority_queue<int> pq;
pq.push(3);
pq.push(1);
pq.push(4);
pq.push(1); // duplicato, va bene

cout << pq.top() << endl; // stampa 4 (il massimo)
pq.pop();
cout << pq.top() << endl; // stampa 3

// per ottenere una min-priority_queue:
priority_queue<int, vector<int>, greater<int>> pq_min;
pq_min.push(3);
pq_min.push(1);
pq_min.push(4);
cout << pq_min.top() << endl; // stampa 1 (il minimo)
```


=== `map`
inclusa in `<map>`

`map` è una struttura dati che immagazzina una serie di coppie chiave-valore, mantenute ordinate in base alla chiave. Si può pensare come un `set` in cui ad ogni elemento (la chiave) è associato anche un valore. Permette di eseguire le seguenti operazioni:

#vtable(
  vrow([`insert({k, v})`], [$cal(O)(log N)$], [Inserisce la coppia chiave-valore. Se la chiave `k` è già presente, `insert` non ha effetto, mentre `[k] = v` sovrascrive il valore associato.]),
  vrow([`erase(k)`], [$cal(O)(log N)$], [Rimuove la coppia con chiave `k`. Se `k` non è presente l'operazione non ha effetto.]),
  vrow([`find(k)`], [$cal(O)(log N)$], [Trova la chiave `k` e restituisce un _iteratore_ alla coppia corrispondente. Se `k` non è presente restituisce un iteratore all'elemento subito dopo l'ultimo (cioè uguale a `end()`).]),
  vrow([`[k]`], [$cal(O)(log N)$], [Restituisce (o crea, se non esiste) un riferimento al valore associato alla chiave `k`. _Attenzione_: accedere con `[k]` a una chiave non presente la _inserisce automaticamente_ nella mappa con un valore di default.]),
  vrow([`begin()` / `end()`], [$cal(O)(1)$], [Restituiscono iteratori all'inizio e alla fine della `map` (in ordine di chiave crescente).]),
  vrow([`clear()`], [$cal(O)(N)$], [Rimuove tutti gli elementi.]),
)

Dereferenziando un iteratore di `map` si ottiene una `pair<K, V>`, dove `.first` è la chiave e `.second` è il valore.

Vediamo un esempio:

```cpp
map<string, int> m;
m["oii"] = 3;
m["oia"] = 5;
m.insert({"egoi", 7});

cout << m["oii"] << endl; // stampa 3

for (pair<string, int> p : m) { // p.first è la chiave, p.second il valore 
  cout << p.first << ": " << p.second << endl; // ordine alfabetico delle chiavi
}

if (m.find("oia") != m.end()) {
  cout << "oia è presente" << endl;
}

m.erase("oia");
cout << m.size() << endl; // stampa 2

cout << m["swerc"] << endl; // stampa 0 e inserisce "swerc" con valore 0
```


/*
A volte possiamo combinare due strutture dati per ottenere una struttura dati più potente. Consideriamo il seguente esempio.

#problem("Sorting Queries", url: "https://atcoder.jp/contests/abc217/tasks/abc217_e", lbl: "sorting-queries",
[
  Dato un array inizialmente vuoto $A$, supporta $Q$ query dei seguenti tipi:
  - `1 x`: inserisci $x$ alla fine di $A$;
  - `2`: stampa l'elemento all'inizio di $A$, e cancellalo;
  - `3`: ordina $A$ in ordine crescente.
  
  $Q <= 2 dot 10^5$, $0 <= x <= 10^9$.
]
)

Partiamo da un problema più semplice: cosa succede se ogni volta che inseriamo un elemento subito dopo ordiniamo $A$ in ordine crescente? In quel caso, le operazioni diventerebbero:

- `1+3 x`: inserisci $x$ in $A$, mantenendolo ordinato;
- `2`: stampa il minimo di $A$, e cancellalo.

...per cui basterebbe usare un set. Anzi, poiché dobbiamo supportare rimozioni solo dell'elemento minimo, anche solo una coda di priorità.

Tuttavia nel problema iniziale abbiamo un prefisso crescente di elementi seguito da alcuni elementi "in coda", i quali attendono una query di tipo `3` per entrare nel prefisso crescente. Idea! Possiamo spezzare $A$ in un prefisso gestito con una coda di priorità, e un suffisso gestito con una coda.

In particolare le operazioni diventano:

- `1 x`: inserisci $x$ alla fine della queue;
- `2`: se la coda di priorità non è vuota, stampa l'elemento minimo nella priority queue e cancellalo, altrimenti stampa l'elemento all'inizio della queue e cancellalo;
- `3`: rimuovi tutti gli elementi dalla queue e travasali nella coda di priorità.

Le query di tipo `3` possono sembrare lente (dopo tutto una singola query potrebbe richiedere $cal(Theta)(Q log Q)$, se la queue contiene $cal(Theta)(Q)$ elementi). Tuttavia ogni elemento viene versato al più una volta nella coda di priorità, indi per cui le query di tipo `3` richiedono _complessivamente_ $cal(O)(Q log Q)$, che va bene.
*/
// rivisto fino a qui

// Nel seguente problema, vedremo un esempio di programmazione dinamica ottimizzata con una coda di priorità.
// 
// #problem("Learning to Paint", url: "https://codeforces.com/problemset/problem/1942/D", lbl: "learning-to-paint",
// [
//   Vuoi colorare alcune caselle in una striscia di $N$ caselle. In questo modo si formano alcuni blocchi massimali colorati $[L_i, R_i]$. Per ognuno di questi blocchi, il tuo punteggio aumenta di $A[L_i][R_i]$. Quali sono i $K$ massimi punteggi che puoi ottenere? (Non sono necessariamente distinti) 
// 
//   $N <= 10^3$, $K <= min(2^N, 5 dot 10^3)$, $-10^6 <= A[i][j] <= 10^6$
// ]
// )
// 
// Partiamo nuovamente da un problema più semplice: trovare solo il massimo punteggio ($K = 1$). In questo caso è sufficiente calcolare $"dp"[i] =$ massimo punteggio colorando solo le caselle fino a $i$. Per ogni $i$, abbiamo due casi:
// 
// - non colorare $i$ (punteggio $"dp"[i-1]$);
// - colorare $i$: in quel caso, scegliamo anche l'estremo $j$ del blocco a cui appartiene $i$ (punteggio $"dp"[j-2] + A[j][i]$).
// 
// Dato che per ogni $i$ proviamo $cal(O)(N)$ valori di $j$, impieghiamo $cal(O)(N^2)$ in tutto.
// 
// Adesso vogliamo risolvere il problema per $K$ generico. Possiamo iniziare salvando $"dp"[i]$ un vector contenente i $K$ massimi punteggi (ordinati in ordine decrescente) che possiamo ottenere colorando solo le caselle fino a $i$. Purtroppo, se per ogni $i$ iteriamo su $j < i$ e scorriamo tutto il vector $"dp"[j-2]$, impieghiamo almeno $cal(O)(N K)$ per ogni $i$, e almeno $cal(O)(N^2K)$ in tutto.
// 
// Notiamo che la maggior parte degli elementi dei vector $"dp"[j]$ sono inutili: ci basta trovare i $K$ elementi con $"dp"[j-2]["pos"] + A[j][i]$ massimo. In particolare, il massimo dovrà avere $"pos" = 0$ (perché i $"dp"[j-2]$ sono ordinati in ordine decrescente). Quindi inizialmente i candidati massimi sono quelli con $"pos" = 0$ (che sono solo $cal(O)(N)$); poi, se $"dp"[j-2][0] + A[j][i]$ è un massimo, sblocchiamo il candidato $"dp"[j-2][1] + A[j][i]$.
// 
// Quindi in ogni momento abbiamo $N$ candidati, e dobbiamo trovare il massimo, e in base alla sua posizione aggiungere un nuovo candidato, cioè quello con $"pos"$ successiva. Tutto questo può essere fatto con una priority queue.
// 
// Per ogni $i$, inseriamo $cal(O)(N+K)$ elementi nella priority queue, impiegando $cal(O)((N+K) log N)$. Quindi la soluzione è $cal(O)(N(N+K) log N)$.
// 
// Ecco un'implementazione. Nota che
// 
// - se inizializziamo $A[i+1][i] = 0$, non ci serve gestire i casi "non coloriamo $i$" e "coloriamo $i$" separatamente;
// - per comodità, vogliamo accedere a $"dp"[-1]$, e possiamo farlo usando questo trucco: https://codeforces.com/blog/entry/70472
// 
// ```cpp
//     int n, k; cin >> n >> k;
//     vector a(n + 2, vector<int>(n + 2, 0));
//     for (int i = 1; i <= n; i++) {
//         for (int j = i; j <= n; j++) {
//             cin >> a[i][j];
//         }
//     }
// 
//     vector<vector<int>> DP(n + 2);
//     auto dp = [&](int x) -> vector<int>& {
//         return DP[x + 1];
//     };
// 
//     dp(-1).push_back(0);
//     for (int i = 0; i <= n; i++) {
//         priority_queue<array<int, 3>> pq;
//         for (int j = 1; j <= i + 1; j++) {
//             pq.push({dp(j - 2).front() + a[j][i], j, 0});
//         }
//         while (!pq.empty() && dp(i).size() < k){
//             auto [val, j, pos] = pq.top(); pq.pop();
//             dp(i).push_back(val); pos++;
//             if (pos < dp(j - 2).size()) {
//                 pq.push({dp(j - 2)[pos] + a[j][i], j, pos});
//             }
//         }
//     }
// 
//     for (auto u : dp(n)) cout << u << ' ';
//     cout << nl;
// ```
// 
// === Stack e nearest smaller element
// 
// #problem("Heavy Intervals", url: "https://codeforces.com/problemset/problem/1909/C", lbl: "heavy-intervals",
// [
//   Dati $N$ intervalli $[L_i, R_i]$ con costo $C_i$ per unità di lunghezza, puoi permutare gli $L_i$ tra loro, puoi permutare gli $R_i$ tra loro, e puoi permutare i $C_i$ tra loro. Alla fine vuoi ottenere intervalli validi (con $L_i <= R_i$) minimizzando il costo totale $sum C_i (R_i - L_i)$.
// 
//   $N <= 10^5$, $1 <= L_i <= R_i <= 2 dot 10^5$, $1 <= C_i <= 10^7$
// ]
// )
// 
// Intuitivamente, conviene assegnare $C_i$ più piccoli a intervalli più corti. Inoltre, più sono "sbilanciate" le lunghezze, più diminuisce il costo. Quindi possiamo iterare sugli estremi degli intervalli in ordine crescente di posizione, e ogni volta che troviamo un estremo destro lo accoppiamo con l'estremo sinistro più vicino.
// 
// *Esercizio*: dimostra la correttezza di quanto appena enunciato.
// 
// L'idea sopra può essere simulata facilmente con un set, ma in realtà in questo caso è sufficiente usare uno stack che contiene gli estremi sinistri non ancora accoppiati.
// 
// - Quando troviamo un estremo destro, lo accoppiamo con l'elemento in cima allo stack, che rimuoviamo dallo stack;
// - quando troviamo un estremo sinistro, lo inseriamo in cima allo stack.
// 
// In pratica, invece dello stack possiamo usare un vector (che supporta tutte le operazioni di uno stack, con la stessa complessità).
// 
// ```cpp
//     int n; cin >> n;
//     vector<array<int, 2>> eventi;
//     vector<int> c(n, 0);
//     for (int i = 1; i <= n; i++) {
//         int l; cin >> l; eventi.push_back({l, 0});
//     }
//     for (int i = 1; i <= n; i++) {
//         int r; cin >> r; eventi.push_back({r, 1});
//     }
//     for (int i = 0; i < n; i++) cin >> c[i];
// 
//     sort(eventi.begin(), eventi.end());
//     sort(c.begin(), c.end());
// 
//     vector<int> st, lunghezze;
//     for (auto [pos, tipo] : eventi) {
//         if (tipo == 0) {
//             st.push_back(pos);
//         } else {
//             lunghezze.push_back(pos - st.back());
//             st.pop_back();
//         }
//     }
// 
//     sort(lunghezze.rbegin(), lunghezze.rend());
//     LL ans = 0;
//     for (int i = 0; i < n; i++) ans += (LL)lunghezze[i] * c[i];
//     cout << ans << "\n";
// ```
// 
// #problem("Advertisement", url: "https://cses.fi/problemset/task/1142", lbl: "advertisement",
// [
//   Una recinzione è costituita da $N$ blocchi verticali. La larghezza di ciascun blocco è $1$ e l'altezza dell'$i$-esimo blocco è $A_i$.
//   Vuoi fissare un cartellone pubblicitario rettangolare (con i lati paralleli a quelli dei blocchi) alla recinzione. Qual è l'area massima che può avere il cartellone?
// 
//   $N <= 2 dot 10^5, 1 <= A_i <= 10^9$
// ]
// )
// 
// Il lato superiore del cartellone deve toccare uno dei bordi dei blocchi (altrimenti possiamo estendere il cartellone). Dato che abbiamo $N$ blocchi, una possibile idea è provarli tutti. Cosa succede se il cartellone tocca il bordo superiore dell'$i$-esimo blocco?
// 
// Possiamo estendere il cartellone a destra e a sinistra, finché non incontriamo un blocco di lunghezza $< A_i$. Quindi dobbiamo trovare, per ogni $i$, i valori $< A_i$ più vicini a $i$, alla sua sinistra e alla sua destra. Questo è un problema standard che si può risolvere in vari modi.
// 
// - Possiamo usare un set che contiene gli indici dei valori più piccoli. Iteriamo sugli $A_i$ in ordine crescente di valore, inserendo la posizione $i$ nel set; nel frattempo, possiamo controllare l'elemento subito dopo $i$ nel set, che corrisponde alla posizione dell'elemento $< A_i$ più vicino a $i$ alla sua destra.
// - Possiamo ottenere una soluzione ancora più efficiente usando uno stack, come illustrato qui: #link("https://cp-algorithms.com/data_structures/stack_queue_modification.html")
// 
// === Problemi consigliati
// 
// Se hai bisogno di _classicismo_, proponiamo la sezione "Sorting and Searching" di #link("cses.fi/problemset"). Proponiamo qui sotto problemi più croccanti e di vari livelli di difficoltà (non minori di algobadge)
// #footnote[Se hai già visto tutti gli esercizi consigliati, probabilmente questa lezione non fa per te.]. In fondo alla pagina riportiamo un hint per ogni problema.
// 
// - #link("https://training.olinfo.it/task/ois_reading")[ois_reading - Reading Papers]#footnote[Simulando il processo dal giorno $0$ al giorno $L-1$, non è detto che convenga leggere il paper con più pagine (potrebbero esserci paper più corti ma più "urgenti"). Invece, cosa succede simulando al contrario?]
// - #link("https://codeforces.com/problemset/problem/1654/C")[1654C - Alice and the Cake]#footnote[Considera la fetta massima: puoi decidere se tagliarla o no.]
// - #link("https://codeforces.com/problemset/problem/1474/C")[1474C - Array Destruction]#footnote[Prima o poi devi eliminare il massimo elemento; in realtà devi eliminarlo subito.]
// - #link("https://codeforces.com/problemset/problem/1896/D")[1896D - Ones and Twos]#footnote[Quali somme pari / dispari puoi ottenere?]
// - #link("https://training.olinfo.it/task/oii_condomini")[oii_condomini - Case de lo commune]#footnote[Fissato il palazzo con altezza massima, quali sono gli altri palazzi panoramici? Usa nearest smaller element.]
// - #link("https://training.olinfo.it/task/oii_ristorante")[oii_ristorante - Ordine online]#footnote[Niente hint  (ma ci sono tantissime soluzioni diverse).]
