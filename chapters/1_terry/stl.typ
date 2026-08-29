#import "/templates/page.typ": project
#import "/utils/render.typ": is-web
#import "/utils/exercises.typ": exercise

#let render = if is-web { project.with(title: "Standard Template Library (STL)") } else { it => it }
#show: render

#import "../../utils/problems.typ": *
#import "../../utils/tables.typ": *


== Standard Template Library (STL) <stl>

=== Introduzione

La Standard Template Library (abbr. STL) è una collezione di algoritmi, strumenti e _strutture dati_ pensate per essere facilmente integrate nel codice. Nell'ambiente della programmazione competitiva vengono spesso utilizzate per via della loro semplicità d'uso e velocità nell'implementazione. La documentazione della STL è disponibile su #link("https://www.cppreference.com"), da cui è anche possibile consultare la complessità temporale delle operazioni sulle strutture.

Tutte le funzionalità della STL sono racchiuse dal namespace `std`. Per comodità possiamo includere all'inizio del codice tutto il namespace tramite `using namespace std;`, in modo da scrivere, per esempio, `vector<int>` invece di `std::vector<int>`. Inoltre, ogni funzionalità della STL è racchiusa in una libreria che andrà importata all'inizio del file. Ad esempio, `vector` sta nella libreria `<vector>`, `sort` sta in `<algorithm>`, e così via. Anche qui possiamo semplificarci la vita usando la libreria `<bits/stdc++.h>` che include automaticamente _quasi_#footnote("Alcune funzionalità come le PBDS non sono incluse.") tutta la STL. Da ora in avanti, assumeremo che il namespace `std` e `<bits/stdc++.h>` siano stati importati.

```cpp
#include <bits/stdc++.h>
using namespace std;
```
=== Struttura dati

Una _Struttura dati_ è un modo intelligente di organizzare informazioni che permetta di supportare determinate operazioni in maniera efficiente. In questo capitolo studiamo come sfruttare al meglio alcune strutture dati già implementate nella libreria standard C++, cioè `vector`, `queue`, `pair`, `set`, `priority_queue`, `map`.

Alcune strutture dati più complesse non sono implementate nella STL, ed andranno perciò implementate a mano. Ci occuperemo di queste strutture nei capitoli futuri.

Inoltre, tutte le strutture della STL supportano queste operazioni:

#op-table(
  op-row([`size()`], [$cal(O)(1)$], [Restituisce il numero di elementi contenuti.]),
  op-row([`empty()`], [$cal(O)(1)$], [Restituisce `true` se la struttura non contiene elementi.]),
)

=== Iteratori 

Un iteratore è un oggetto che punta ad uno specifico elemento della struttura dati. Sotto molti punti di vista è simile ad un puntatore. Gli iteratori sono molto utili e vengono usati dalle funzioni della STL che operano su strutture della STL. Per accedere all'elemento puntato dall'iteratore precediamo esso con un `*`. Vediamo un esempio:

```cpp
vector<int> a = {10, 20, 30};
auto it = a.begin(); // it punta a 10
cout << *it << endl; // stampa 10
it++;                 // it punta a 20
cout << *it << endl;  // stampa 20
```

Possiamo passare all'elemento successivo con `next(it)` (oppure incrementando direttamente l'iteratore con `++it` o `it++`), e a quello precedente con `prev(it)` (oppure `--it`). Inoltre è importante notare che se abbiamo una struttura, ad esempio un vettore `V`, allora `V.begin()` punta al primo elemento del vettore (se esiste), mentre `V.end()` punta all'elemento subito dopo l'ultimo (ovvero a memoria non allocata). Se `V` è vuoto vale `V.begin() == V.end()`.

=== `vector`
inclusa in `<vector>`

`vector` è forse la struttura dati più semplice della STL: può essere pensata come un _array dinamico_, che si ridimensiona automaticamente quando necessario.

Supporta le seguenti operazioni principali:

#op-table(
  op-row([`push_back(x)`], [$cal(O)(1)$ _ammortizzata_], [Aggiunge `x` in fondo al vettore.]),
  op-row([`pop_back()`], [$cal(O)(1)$], [Rimuove l'ultimo elemento del vettore.]),
  op-row([`at(i)`], [$cal(O)(1)$], [Restituisce un riferimento all'elemento in posizione `i`. Si può ottenere lo stesso effetto (ma senza controllo dei limiti, più veloce) con l'operatore `[i]`.]),
  op-row([`insert(it, x)`], [$cal(O)(N)$ #footnote($N$ + " è il numero di elementi contenuti dentro la struttura dati al momento dell'operazione.")], [Inserisce `x` nella posizione indicata dall'iteratore `it`. Richiede lo spostamento di tutti gli elementi successivi.]),
  op-row([`erase(it)`], [$cal(O)(N)$], [Rimuove l'elemento nella posizione indicata da `it`.]),
  op-row([`clear()`], [$cal(O)(N)$], [Rimuove tutti gli elementi.]),
  op-row([`front()` / `back()`], [$cal(O)(1)$], [Restituiscono un riferimento rispettivamente al primo e all'ultimo elemento.]),
  op-row([`begin()` / `end()`], [$cal(O)(1)$], [Restituiscono iteratori all'inizio e alla fine del vettore.]),
  op-row([`resize(n)`], [$cal(O)(N)$], [Ridimensiona il vettore in modo che contenga `n` elementi. Se `n` è minore della dimensione attuale, gli elementi in eccesso vengono rimossi; se è maggiore, i nuovi elementi vengono inizializzati con il valore di default (o con il valore passato come secondo argomento opzionale `resize(n, val)`). _Nota bene:_ `resize` non rimuove gli elementi già presenti: se `n` è maggiore della dimensione attuale, gli elementi esistenti rimangono invariati e vengono semplicemente aggiunti nuovi elementi in coda, mentre se `n` è minore, i primi `n` elementi vengono mantenuti e solo quelli in eccesso vengono rimossi.]),
)

`push_back` è $cal(O)(1)$ _ammortizzata_ perché, quando il vettore esaurisce lo spazio allocato, la sua capacità viene raddoppiata e tutti gli elementi vengono ricopiati in un nuovo blocco di memoria contiguo, il che ha complessità $cal(O)(N)$. Per risparmiare del tempo, se sappiamo in anticipo quanti elementi avrà il nostro vettore (anche una stima per eccesso va bene), possiamo pre-allocare la memoria per $n$ elementi tramite `reserve(n)`. 

*Nota bene:* alcune operazioni, come `push_back`, `insert` o `erase`, possono invalidare gli iteratori esistenti su un `vector` (ad esempio se il vettore viene ricopiato in un nuovo blocco di memoria durante un ridimensionamento). Usare un iteratore invalidato è un comportamento indefinito.

=== `queue`
inclusa in `<queue>`

`queue` è una struttura dati che implementa una coda *FIFO* (_First In, First Out_): l'elemento che viene inserito per primo è anche il primo ad essere rimosso. Permette di eseguire le seguenti operazioni:

#op-table(
  op-row([`push(x)`], [$cal(O)(1)$], [Inserisce l'elemento `x` in fondo alla coda.]),
  op-row([`pop()`], [$cal(O)(1)$], [Rimuove l'elemento in cima alla coda (il primo inserito).]),
  op-row([`front()` / `back()`], [$cal(O)(1)$], [Restituiscono un riferimento rispettivamente al primo e all'ultimo elemento.]),
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

#op-table(
  op-row([`insert(x)`], [$cal(O)(log N)$], [Inserisce l'elemento `x` nel set.]),
  op-row([`erase(x)`], [$cal(O)(log N)$], [Rimuove l'elemento `x` dal set. Se `x` non è presente l'operazione non ha effetto.]),
  op-row([`find(x)`], [$cal(O)(log N)$], [Trova l'elemento `x` e restituisce un _iteratore_ ad esso. Se `x` non è presente restituisce un iteratore all'elemento subito dopo l'ultimo.]),
  op-row([`begin()` / `end()`], [$cal(O)(1)$], [Restituiscono iteratori all'inizio e alla fine del `set`. `begin()` punta al primo elemento, `end()` alla posizione subito dopo l'ultimo.]),
  op-row([`clear()`], [$cal(O)(N)$], [Rimuove tutti gli elementi.]),
)

*Nota bene:* `set` salva *una sola copia* degli elementi (ovvero non si possono avere elementi duplicati). Una struttura sostanzialmente identica che supporta questa funzionalità è `multiset`.

Vediamo come usare un set in un semplice esempio:

```cpp
set<int> s;
s.insert(5);
s.insert(1);
s.insert(3);
s.insert(1); // non ha effetto, 1 è già presente

for (int x : s)
  cout << x << " "; // stampa: 1 3 5 (ordinati)
cout << endl;

if (s.find(3) != s.end()) {
  cout << "3 è presente nel set" << endl;
}

s.erase(3);
cout << s.size() << endl; // stampa 2
```

Consideriamo un altro esempio pratico.
#problem("Room Allocation", url: "https://cses.fi/problemset/task/1164", lbl: "room-allocation", tags: ("cses",))[
    L'Olinfo Hotel vuole ospitare $N$ clienti, l'$i$-esimo dei quali vuole alloggiare in una stanza dal giorno $L_i$ al giorno $R_i$. Una stanza non può essere occupata simultaneamente da più persone (cioè affinché due ospiti possano alloggiare nella stessa stanza, i loro intervalli $[L_i, R_i]$, $[L_j, R_j]$ devono essere disgiunti).
    Qual è il minimo numero di stanze affinché l'Olinfo Hotel possa ospitare tutti? Se la risposta è $K$, stabilisci per ogni ospite un numero di stanza da $1$ a $K$.

    $N <= 2 dot 10^5$, $1 <= L_i <= R_i <= 10^9$.
][
  Intuitivamente, è ottimale ordinare gli eventi in ordine cronologico, per poi simulare la partenza e l'arrivo di ogni cliente nell'ordine giusto. A questo punto, ogni volta che arriva un cliente, è ottimale assegnargli la stanza libera con numero minimo.

  // *Esercizio:* dimostra quest'ultimo fatto. In particolare, supponi di dare a un cliente una stanza con numero non minimo. A quel punto, la stanza con numero minimo o rimane sempre inutilizzata (e quindi non stai usando il numero minimo di stanze), oppure viene utilizzata da altri clienti in seguito (in questo caso, trova un'altra configurazione di stanze che funziona).

  Come trovare la stanza libera con numero minimo? Se controlliamo le stanze una a una, impieghiamo $cal(O)(N)$ per cliente nel caso pessimo (ad esempio, se l'unica stanza libera è l'ultima): serve una struttura dati più veloce. Un `set` è particolarmente adatto perché supporta l'estrazione dell'elemento minimo in tempo $cal(O)(log N)$.

  Vorremmo quindi inizializzare un set che contiene tutte le stanze libere, ma non sappiamo quante sono. In ogni caso, usiamo al massimo $N$ stanze, per cui possiamo inizializzare il set con tutti gli interi da $1$ a $N$. Ora:
  - ogni volta che un nuovo cliente arriva, estraiamo (e rimuoviamo) il minimo elemento dal set;
  - ogni volta che un cliente lascia l'hotel, aggiungiamo nel set il suo numero di stanza.

  *Attenzione:* ogni giorno, è importante processare prima gli arrivi e poi le partenze, altrimenti un cliente potrebbe lasciare una stanza e un altro cliente potrebbe occuparla il giorno stesso.

  Segue una possibile implementazione. Nota che stiamo ordinando gli eventi prima per tempo, e a parità di tempo per tipo (prima gli arrivi, poi le partenze).

  ```cpp
  int n;
  cin >> n;
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
]


=== `priority_queue`
inclusa in `<queue>`

`priority_queue` è una struttura dati che immagazzina una serie di elementi e permette di accedere rapidamente al *massimo* tra essi (o al minimo, se configurata opportunamente). Nonostante il nome, una `priority_queue` è più simile ad un `multiset` invece di una `queue`. A differenza di `set`, non mantiene gli elementi ordinati internamente in modo accessibile, e non supporta iteratori né la ricerca di un elemento arbitrario, ma supporta elementi duplicati. Permette di eseguire le seguenti operazioni:

#op-table(
  op-row([`push(x)`], [$cal(O)(log N)$], [Inserisce l'elemento `x` nella coda.]),
  op-row([`pop()`], [$cal(O)(log N)$], [Rimuove l'elemento massimo dalla coda.]),
  op-row([`top()`], [$cal(O)(1)$], [Restituisce (senza rimuoverlo) l'elemento massimo attualmente presente nella coda.]),
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

#op-table(
  op-row([`insert({k, v})`], [$cal(O)(log N)$], [Inserisce la coppia chiave-valore. Se la chiave `k` è già presente, `insert` non ha effetto, mentre `[k] = v` sovrascrive il valore associato.]),
  op-row([`erase(k)`], [$cal(O)(log N)$], [Rimuove la coppia con chiave `k`. Se `k` non è presente l'operazione non ha effetto.]),
  op-row([`find(k)`], [$cal(O)(log N)$], [Trova la chiave `k` e restituisce un _iteratore_ alla coppia corrispondente. Se `k` non è presente restituisce un iteratore all'elemento subito dopo l'ultimo (cioè uguale a `end()`).]),
  op-row([`[k]`], [$cal(O)(log N)$], [Restituisce (o crea, se non esiste) un riferimento al valore associato alla chiave `k`. _Attenzione_: accedere con `[k]` a una chiave non presente la _inserisce automaticamente_ nella mappa con un valore di default.]),
  op-row([`begin()` / `end()`], [$cal(O)(1)$], [Restituiscono iteratori all'inizio e alla fine della `map` (in ordine di chiave crescente).]),
  op-row([`clear()`], [$cal(O)(N)$], [Rimuove tutti gli elementi.]),
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

=== `string`
inclusa in `<string>`

`string` rappresenta una sequenza di caratteri e viene utilizzata per
gestire il testo. È possibile accedere ai singoli caratteri tramite il loro
indice, che parte da `0`, come negli array e nei `vector`.

Le operazioni più utilizzate sono:

#op-table(
  op-row([`[i]` / `at(i)`], [$cal(O)(1)$], [Restituiscono il carattere in posizione `i`.]),
  op-row([`size()` / `length()`], [$cal(O)(1)$], [Restituiscono il numero di caratteri della stringa.]),
  op-row([`push_back(c)` / `pop_back()`], [$cal(O)(1)$ _ammortizzata_], [Aggiungono o rimuovono un carattere alla fine della stringa.]),
  op-row([`substr(pos, len)`], [$cal(O)(M)$], [Restituisce la sottostringa di lunghezza `len` che inizia in posizione `pos`, dove `M` è la lunghezza della sottostringa.]),
  op-row([`find(t)`], [$cal(O)(N M)$], [Restituisce la prima posizione in cui compare `t`, oppure `string::npos` se non viene trovata.]),
  op-row([`erase(pos, len)` / `insert(pos, t)`], [$cal(O)(N)$], [Rimuovono o inseriscono caratteri nella posizione indicata.]),
)

Le stringhe possono essere concatenate con `+` e confrontate direttamente
con gli operatori `==`, `!=`, `<`, `<=`, `>` e `>=`. I confronti lessicografici
usano l'ordine dei caratteri.

```cpp
string s = "grazie";
s += " dario";
s.push_back('!');

cout << s << endl;             // stampa: grazie dario!
cout << s.substr(7, 5) << endl; // stampa: dario

auto pos = s.find("dario");
if (pos != string::npos)
  cout << pos << endl;         // stampa 7
```

Nota bene: usare `cin` per leggere una stringa può causare problemi se essa contiene spazi. In particolare, `cin` legge l'input fino a quando non trova uno spazio o la riga è terminata, quindi la stringa verrebbe "spezzata" ad ogni spazio. Se vogliamo leggere una riga per intero possiamo usare `getline` come illustrato nell'esempio:

```cpp
string s;
getline(cin, s);
```

=== Problemi consigliati

#exercise("Tieni aggiornato il catalogo", "https://training.olinfo.it/task/catalogo", diff: 1)
#exercise("Soste in autostrada", "https://training.olinfo.it/task/autogrill", diff: 1)
#exercise("Quantum Brackets", "https://training.olinfo.it/task/ois_brackets", diff: 1)
#exercise("Festa Estiva", "https://training.olinfo.it/task/pre-egoi-festaestiva", diff: 2)
#exercise("Overtakings", "https://training.olinfo.it/task/ois_g1", diff: 2)
#exercise("Concert Tickets", "https://cses.fi/alon/task/1091", diff: 2)
#exercise("Traffic Lights", "https://cses.fi/ckvo8q5wh/task/1163", diff: 2)
#exercise("Mattia e i suoi vasi", "https://training.olinfo.it/task/vasi", diff: 3)

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
