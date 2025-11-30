#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#import "../../util.typ": *
#show: codly-init.with()

#codly(languages: codly-languages)

== Ricerca binaria

La ricerca binaria#footnote[talvolta chiamata anche _ricerca dicotomica_], in inglese, _binary search_, è una tecnica di ricerca che spesso permette di velocizzare una ricerca lineare.

Per capire l'idea alla base consideriamo il seguente esempio: un nostro amico sta pensando a un numero $N$ da $1$ a $100$ e noi dobbiamo indovinarlo.
Le domande che possiamo fare sono del tipo _"Il numero $N$ è minore o uguale a X?"_.

La prima domanda che chiunque farebbe è _"Il numero è minore o uguale di 50?"_ perché qualsiasi sia la risposta, avremo scartato metà delle opzioni. 
Proseguendo con un ragionamento simile, con ogni domanda possiamo dimezzare lo spazio di ricerca.

*Quante domande ci serviranno per determinare il numero?* Ovvero, quante volte dobbiamo dimezzare lo spazio di ricerca per arrivare a un solo numero plausibile e quindi alla soluzione?

Per rispondere è più facile capovolgere il problema chiedendosi, partendo da un singolo elemento, quante volte devo raddoppiare lo spazio di ricerca per ottenere la dimensione di quello iniziale.

Se $Q$ è il numero di query#footnote[domande.] e $D$ la dimensione dello spazio di ricerca, vale $2^Q = D$ da cui $ Q = log_2 D $

Si ricorda che un cambio di base nei logaritmi equivale a un fattore moltiplicativo costante, quindi è lecito omettere la base e affermare che la ricerca binaria impiega $cal(O)(log D)$ query, dove $D$ è la dimensione dello spazio di ricerca.

Una possibile implementazione del problema sopra descritto è la seguente:

```cpp
int N = 42, queries;

bool chiedi(int X) {
    return N <= X;
}

int main() {
    queries = 0;
    int left = 1, right = 100;
    while (left != right) {
        queries++;
        int mid = (left + right) / 2;
        if (chiedi(mid))
            right = mid;
        else
            left = mid + 1;
    }
    if (left == N)
        cout << "Correct: " << queries << " queries" << endl;
}
```

È bene spendere qualche parola su alcuni dettagli dell'implementazione.

Con `left` e `right` indichiamo gli estremi (inclusi) dello spazio di ricerca, che dunque conterrà $"right" - "left" + 1$ elementi.
Vogliamo reiterare l'algoritmo finché abbiamo più di un elemento tra i candidati, cioè finché `right` è diverso da `left`.

Ad ogni passo della ricerca si fa una query nel punto medio dell'intervallo per capire in quale delle due metà proseguire la ricerca. 

È possibile anche implementare la ricerca binaria ricorsivamente: 

```cpp
int ricerca_binaria(int left, int right) {
    if (left == right) return left;
  
    int mid = (left + right) / 2;
  
    if (chiedi(mid)) 
        return ricerca_binaria(left, mid);
    else 
        return ricerca_binaria(mid + 1, right);
}

int main() {
    cout << ricerca_binaria(1, 100) << endl;
}
```

Un'applicazione comune di questo algoritmo è nella ricerca di un elemento all'interno di un vettore ordinato.

```cpp
vector<int> A = {1, 2, 3, 5, 6, 9, 11, 24};

int left = 0, right = A.size() - 1;

int cercato = 11;

while (left != right) {
    int mid = (left + right) / 2;
    if (A[mid] >= cercato) {
        right = mid;
    } else {
        left = mid + 1;
    }
}

if (A[left] == cercato) {
    cout << "L'elemento è presente!" << endl;
    cout << "Posizione: " << left << endl;
}
```

In questo caso, dal momento che il vettore è ordinato, al posto di scorrere tutto l'array per verificare se è presente o meno il valore `cercato` in $cal(O)(N)$, posso fare una ricerca binaria:

Guardo l'elemento al centro dell'intervallo in cui sto cercando e se questo è minore o uguale proseguo la ricerca nella metà sinistra, altrimenti nella metà destra. La complessità è $cal(O)(log N)$.

Per verificare solamente se è presente un valore si può usare `std::binary_search()` mentre per determinarne la posizione `std::lower_bound()`. Entrambe queste funzioni hanno complessità $cal(O)(log N)$.

```cpp
vector<int> A = {1, 2, 3, 5, 6, 9, 11, 24};
  
int cercato = 11;

if (binary_search(A.begin(), A.end(), cercato)) {
    cout << "Elemento presente" << endl;

    int pos = lower_bound(A.begin(), A.end(), cercato) - A.begin();
    cout << "Posizione: " << pos << endl;
    
} else {
    cout << "Elemento non presente" << endl;
}
```

In generale, la ricerca binaria si può applicare quando i valori rispettano un qualche ordinamento che ci permette di separare in due metà lo spazio di ricerca sapendo in quale delle due metà si potrebbe trovare.

Un esempio classico è l'albero binario di ricerca, struttura dati in cui ogni nodo contiene un valore e tutti i valori nel sottoalbero sinistro sono minori mentre quelli nel sottoalbero destro sono più grandi.

=== Ricerca binaria sulla risposta

Un'applicazione non banale della ricerca binaria è dare la risposta a un problema di minimo o di massimo.
Consideriamo il seguente problema.

#problem("Christmas lights", url: "https://training.olinfo.it/task/ois_lights", lbl: "christmas-lights", tags: ("ois", "2022-23"), 
[
    Abbiamo una fila di $N$ luci colorate di $C$ colori diversi; il colore della luce $i$-esima è $A_i$ ($0 <= A_i < C <= N$). 
    Quanto è lungo il più corto sotto-array che contiene tutti i colori?
])

Assumiamo che la risposta sia $L$. Possiamo osservare due cose:

- Tutti i sotto-array più corti di $L$ non contengono $C$ colori distinti, altrimenti la risposta non sarebbe $L$;
- Per ogni lunghezza $K$ con $L <= K <= N$ esiste almeno un sotto-array che contiene tutti i colori. Basta considerare il sotto-array lungo $L$ che li contiene tutti ed espanderlo agli estremi finché non è lungo $K$.

Controllare se esiste un sotto-array di lunghezza $ell$ può contenere tutti i colori ci richiede tempo $cal(O)(N)$ nel seguente modo:

```cpp
bool controlla(int l) {
    vector<int> conta(C);
    int colori_mancanti = C;
    
    for (int i = 0; i < l; i++) {
        conta[A[i]]++;
        if (conta[A[i]] == 1) colori_mancanti--;
    }
    
    if (colori_mancanti == 0) return true;
    
    for (int i = l; i < N; i++) {
        conta[A[i - l]]--;
        if (conta[A[i - l]] == 0) colori_mancanti++;
        
        conta[A[i]]++;
        if (conta[A[i]] == 1) colori_mancanti--;

        if (colori_mancanti == 0) return true;
    }
    return false;
}
```

La funzione `controlla(int l)` restituisce `true` solo se esiste un sotto-array di lunghezza $ell$ che contiene tutti i colori.

Una soluzione quadratica potrebbe controllare tutti gli $ell$ da $C$ a $N$ e stampare il valore minimo per cui `controlla(l)` restituisce `true`.

Tuttavia, per le osservazioni fatte in precedenza, vediamo che per un prefisso di valori fino ad $L$, `controlla(l)` restituisce `false`, mentre per il restante suffisso restituisce `true` e quindi possiamo fare ricerca binaria su questo punto.

Sappiamo che si trova tra $C$ e $N$, quindi proviamo a metà. Se ottengo `true` devo controllare nella metà sinistra, diversamente controllo nella metà destra.

```cpp
int left = C, right = N;

while (left != right) {
    int mid = (left + right) / 2;
    if (controlla(mid)) 
        right = mid;
    else 
        left = mid + 1;
}

cout << left << endl;
```

Quando ci viene richiesto di trovare _il massimo o il minimo valore per il quale vale una certa proprietà_ e questa proprietà vale solo per un prefisso o solo per un suffisso, allora è solitamente possibile fare una ricerca binaria sul punto in cui cambia la risposta. 
