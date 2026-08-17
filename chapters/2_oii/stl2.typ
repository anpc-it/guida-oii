#import "/templates/page.typ": project
#import "/utils/render.typ": is-web

#let render = if is-web { project.with(title: "Altre funzionalità della STL") } else { it => it }
#show: render

#import "../../utils/problems.typ": *
#import "../../utils/tables.typ": *
#import "../../utils/ref.typ": crossref


== Altre funzionalità della STL

// TODO: update this link once the book is done
Le strutture dati introdotte nel #crossref(<stl>, "/chapters/1_terry/stl.typ", [capitolo precedente della STL]) sono tra le più utilizzate, ma la STL offre molte altre funzionalità utili, che presentiamo di seguito.

=== Funzioni della STL
incluse in `<algorithm>`

Segue una lista delle funzioni della STL più comunemente usate, con la relativa complessità:
#op-table(
  op-row([`sort(l, r)`], [$cal(O)(N log N)$], [Ordina il range $[l, r)$]),
  op-row([`reverse(l, r)`], [$cal(O)(N)$], [Inverte l'ordine del range $[l, r)$]),
  op-row([`max_element(l, r)` \ `min_element(l, r)`], [$cal(O)(N)$], [Restituisce un iteratore rispettivamente all'elemento massimo o minimo del range $[l, r)$]),
  op-row([`lower_bound(l, r, x)` \ `upper_bound(l, r, x)`], [$cal(O)(log N)$], [Restituisce un iteratore rispettivamente al primo elemento $>= x$ o $> x$ nel range $[l, r)$. I valori nel range devono necessariamente essere ordinati.]),
)

#v(1em)
`sort` ordina gli elementi nel range $[l, r)$ con complessità $cal(O)(N log N)$, dove $N$ è il numero di elementi nel range. Accetta iteratori oppure puntatori.

```cpp
vector<int> v = {5, 3, 1, 4, 2};
sort(v.begin(), v.end());
for (int x : v) cout << x << " "; // stampa: 1 2 3 4 5

int a[] = {5, 3, 1, 4, 2};
sort(a, a + 5); // ordina l'intero array
```

Di default, `sort` ordina in ordine *crescente*, usando l'operatore `<` per confrontare gli elementi. È possibile personalizzare il criterio di ordinamento passando un _comparatore_ come terzo argomento:

```cpp
vector<int> v = {5, 3, 1, 4, 2};

// ordine decrescente, usando un comparatore predefinito
sort(v.begin(), v.end(), greater<int>());

// ordine decrescente, usando una lambda
sort(v.begin(), v.end(), [](int a, int b) {
  return a > b;
});
```
Se gli oggetti da ordinare non hanno l'operatore `<` definito, ad esempio una `struct` o una classe, è necessario fornire un comparatore (che deve definire un ordinamento debole stretto).


#v(1em)
`reverse` inverte l'ordine degli elementi nel range $[l, r)$, con complessità $cal(O)(N)$. Accetta come parametro degli iteratori a `l`, `r`, oppure dei puntatori in caso di un array. Vediamo un esempio:

```cpp
vector<int> v = {1, 2, 3, 4, 5};
reverse(v.begin(), v.end());
for (int x : v) cout << x << " "; // stampa: 5 4 3 2 1

int a[] = {1, 2, 3, 4, 5};
reverse(a, a + 5); // inverte l'intero array
```

#v(1em)
`max_element(l, r)` e `min_element(l, r)` restituiscono un iteratore rispettivamente al massimo e al minimo elemento nel range $[l, r)$, con complessità $cal(O)(N)$. Accettano come parametro degli iteratori a `l`, `r`, oppure dei puntatori in caso di un array.

```cpp
vector<int> v = {5, 3, 1, 4, 2};

auto it = max_element(v.begin(), v.end());
cout << *it << endl; // stampa 5

cout << *min_element(v.begin(), v.end()) << endl; // stampa 1

int a[] = {5, 3, 1, 4, 2};
cout << *max_element(a, a + 5) << endl; // stampa 5
```
Come per `sort`, è possibile passare un comparatore come ultimo argomento per personalizzare il criterio di confronto.


#v(1em)
 `lower_bound(l, r, x)` e `upper_bound(l, r, x)` restituiscono un iteratore alla prima posizione nel range $[l, r)$ in cui si potrebbe inserire `x` senza violarne l'ordinamento, con complessità $cal(O)(log N)$ #footnote([La complessità è $cal(O)(log N)$ solo se gli iteratori sono _random-access_, altrimenti diventa $cal(O)(N)$. Un iteratore è random-access se supporta l'aritmetica dei puntatori in tempo costante (come gli iteratori di `vector` e degli array). Gli iteratori di `set` e `map`, invece, non lo sono: per questo motivo, se abbiamo un `set<int> S`, conviene usare il metodo membro `S.lower_bound(x)`, che costa $cal(O)(log N)$, mentre la funzione `lower_bound(S.begin(), S.end(), x)` costa $cal(O)(N)$.]). Richiedono che il range sia già ordinato in modo crescente.

La differenza tra le due:
- `lower_bound(l, r, x)`: restituisce un iteratore al primo elemento *$>= x$*.
- `upper_bound(l, r, x)`: restituisce un iteratore al primo elemento *$> x$*.

Se `x` non è presente nel range, entrambe restituiscono la stessa posizione (quella in cui `x` andrebbe inserito). Se `x` è presente una o più volte, `lower_bound` punta alla prima occorrenza e `upper_bound` alla posizione subito dopo l'ultima. Vediamo un esempio:

```cpp
vector<int> v = {1, 2, 2, 2, 5, 7};

auto lb = lower_bound(v.begin(), v.end(), 2);
auto ub = upper_bound(v.begin(), v.end(), 2);
cout << (lb - v.begin()) << endl; // stampa 1 (prima occorrenza di 2)
cout << (ub - v.begin()) << endl; // stampa 4 (subito dopo l'ultima occorrenza di 2)

// numero di occorrenze di 2:
cout << (ub - lb) << endl; // stampa 3

// se x non è presente:
auto it = lower_bound(v.begin(), v.end(), 4);
cout << (it - v.begin()) << endl; // stampa 4 (posizione in cui andrebbe inserito)
```

=== `unordered_map`
inclusa in `<unordered_map>`

`unordered_map` memorizza coppie chiave-valore come `map`, ma non mantiene le chiavi ordinate. Internamente è implementata tramite una tabella hash, che permette operazioni in tempo costante in media.

#op-table(
  op-row([`insert({k, v})`], [$cal(O)(1)$ media], [Inserisce la coppia chiave-valore. Se la chiave `k` è già presente, `insert` non ha effetto, mentre `[k] = v` sovrascrive il valore associato.]),
  op-row([`erase(k)`], [$cal(O)(1)$ media], [Rimuove la coppia con chiave `k`. Se `k` non è presente l'operazione non ha effetto.]),
  op-row([`find(k)`], [$cal(O)(1)$ media], [Trova la chiave `k` e restituisce un _iteratore_ alla coppia corrispondente. Se `k` non è presente restituisce un iteratore uguale a `end()`.]),
  op-row([`[k]`], [$cal(O)(1)$ media], [Restituisce (o crea, se non esiste) un riferimento al valore associato alla chiave `k`. _Attenzione_: accedere con `[k]` a una chiave non presente la _inserisce automaticamente_ con un valore di default.]),
  op-row([`begin()` / `end()`], [$cal(O)(1)$], [Restituiscono iteratori all'inizio e alla fine della `unordered_map` in un ordine non specificato.]),
  op-row([`clear()`], [$cal(O)(N)$], [Rimuove tutti gli elementi.]),
)

È preferibile usare questa struttura dati quando l'ordinamento non è necessario, perché spesso è più veloce di `map`, soprattutto con molti elementi. #footnote([Esistono gli attacchi anti-hash: #link("https://codeforces.com/blog/entry/62393")])

=== `unordered_set`
inclusa in `<unordered_set>`

`unordered_set` immagazzina una serie di elementi senza duplicati esattamente come `set`, ma senza mantenerli ordinati. Anche questa struttura internamente usa una tabella hash.

#op-table(
  op-row([`insert(x)`], [$cal(O)(1)$ media], [Inserisce l'elemento `x` nel set.]),
  op-row([`erase(x)`], [$cal(O)(1)$ media], [Rimuove l'elemento `x` dal set. Se `x` non è presente l'operazione non ha effetto.]),
  op-row([`find(x)`], [$cal(O)(1)$ media], [Trova l'elemento `x` e restituisce un _iteratore_ ad esso. Se `x` non è presente restituisce un iteratore uguale a `end()`.]),
  op-row([`begin()` / `end()`], [$cal(O)(1)$], [Restituiscono iteratori all'inizio e alla fine dell'`unordered_set` in un ordine non specificato.]),
  op-row([`clear()`], [$cal(O)(N)$], [Rimuove tutti gli elementi.]),
)


=== `bitset`
inclusa in `<bitset>`

`bitset<N>` rappresenta una sequenza di `N` bit, dove `N` deve essere conosciuto a tempo di compilazione. È utile quando dobbiamo memorizzare molti valori booleani oppure manipolare direttamente una maschera di bit. Rispetto ad un `vector<bool>` offre prestazioni migliori.

Il bit in posizione `0` è quello meno significativo. La struttura supporta le
seguenti operazioni principali:

#op-table(
  op-row([`[i]` / `test(i)`], [$cal(O)(1)$], [Restituisce il valore del bit in posizione `i`.]),
  op-row([`set(i)`], [$cal(O)(1)$], [Imposta a `1` il bit in posizione `i`.]),
  op-row([`reset(i)`], [$cal(O)(1)$], [Imposta a `0` il bit in posizione `i`.]),
  op-row([`flip(i)`], [$cal(O)(1)$], [Inverte il bit in posizione `i`.]),
  op-row([`flip()`], [$cal(O)(N)$], [Inverte tutti i bit.]),
  op-row([`count()`], [$cal(O)(N)$], [Restituisce il numero di bit impostati a `1`.]),
   op-row([`to_ulong()` / `to_ullong()`], [$cal(O)(N)$], [Convertono il `bitset` rispettivamente in un `unsigned long` o in un `unsigned long long` (se possibile, altrimenti restituisce un errore).]),
  op-row([`any()` / `none()`], [$cal(O)(N)$], [Controllano rispettivamente se almeno un bit oppure nessun bit è impostato a `1`.]),
   op-row([`set()` / `reset()`], [$cal(O)(N)$], [Impostano oppure azzerano tutti i bit.]),
)

È possibile usare gli operatori bit a bit `&`, `|` e `^` tra due `bitset` della stessa dimensione. Sono inoltre disponibili gli operatori di shift `<<` e `>>`, che spostano tutti i bit verso sinistra o verso destra. Queste operazioni hanno complessità $cal(O)(N)$ ed eseguono  circa $~ceil(N / 64)$ operazioni.

```cpp
bitset<8> b;

b.set(2);             // 00000100
b.set(5);             // 00100100
b.flip(2);            // 00100000
b[0] = true;          // 00100001

cout << b[5] << endl; // stampa 1
cout << b.count() << endl; // stampa 2

bitset<8> mask("00001111");
cout << (b & mask) << endl; // stampa 00000001
```
