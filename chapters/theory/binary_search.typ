#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#import "../../util.typ": *
#show: codly-init.with()

#codly(languages: codly-languages)

== Ricerca binaria

La ricerca binaria#footnote[in inglese, _binary search_] è una tecnica di ricerca che in molti contesti permette di velocizzare una ricerca lineare.

Per capire l'idea alla base consideriamo il seguente esempio: un nostro amico sta pensando a un numero $N$ da $1$ a $100$ e noi dobbiamo indovinarlo. 
La domanda che possiamo fare è _"Il numero $N$" è minore o uguale a X?"_.

La prima domanda che chiunque farebbe è _"Il numero è minore o uguale di 50?"_ perché qualsiasi sia la risposta, avremo scartato metà delle opzioni. 
Proseguendo con un ragionamento simile, possiamo a ogni domanda dimezzare lo spazio di ricerca.

*Quante domande ci serviranno per arrivare al numero?* Ovvero quante volte dobbiamo dimezzare lo spazio di ricerca per arrivare ad avere un solo numero plausibile?

Per dare una risposta è più facile capovolgere il problema chiedendosi, partendo da un singolo elemento, quante volte devo raddoppiare lo spazio di ricerca per ottenere la dimensione di quello iniziale. 

Se $Q$ è il numero di query#footnote[domande] e $D$ la dimensione dello spazio di ricerca, avremo $2^Q = D$ da cui $ Q = log_2 D $

Si ricorda che un cambio di base nei logaritmi equivale a un fattore costante e di conseguenza spesso si omette la base. Dunque diremo che la ricerca binaria impiega $cal(O)(log D)$.

Una possibile implementazione del problema sopra descritto è la seguente:

#codly(
    header: [Ricerca binaria],
)

```cpp
int N = 42, queries;

bool chiedi (int X) {
    return N <= X;
}

int main() {
    queries = 0;
    int left = 1, right = 100;
    while (right - left > 0) {
        queries++;
        int mid = (left + right) / 2;
        if (chiedi(mid)) {
            right = mid;
        } else {
            left = mid + 1;
        }
    }
    if (left == N) {
        cout << "Correct: " << queries << " queries" << endl;
    } else {
        cout << "Wrong" << endl;
    }
}
```

È bene spendere qualche parola su alcuni dettagli dell'implementazione.

Con `left` e `right` indichiamo gli estremi (inclusi) dello spazio di ricerca, che dunque conterrà `right - left` $+ 1$ elementi.
Vogliamo 