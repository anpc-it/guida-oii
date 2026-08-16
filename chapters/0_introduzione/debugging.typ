#import "/templates/page.typ": project
#import "/utils/render.typ": is-web

#let render = if is-web { project.with(title: "Debugging") } else { it => it }
#show: render

#import "../../utils/examples.typ": *

== Debugging <debugging>

Il _debugging_, o in italiano "_correzione degli errori_", è il processo di rimozione di errori logici o concettuali (in inglese, _bugs_) dal proprio codice. 
Durante la fase di stesura del codice è molto probabile che vengano inseriti inavvertitamente dei bugs, perciò familiarizzare e padroneggiare le tecniche di debugging è essenziale.
Elenchiamo qui sotto le tecniche e gli strumenti più efficaci per fare _debugging_:

=== Usare `std::cout` o `std::cerr`
Il metodo più banale (ma spesso il più efficace) per scovare bugs è quello di stampare delle informazioni intermedie durante l'esecuzione del codice.

// TODO: trovare un esempio migliore per debugging std::cout D:

#example[Individuare un overflow con `std::cout`][
_Dati due interi $a,b$ tali che $1 <= a,b <= 14$, calcolare $a^b$._

Consideriamo il seguente codice che dovrebbe risolvere il problema:

```cpp
#include <iostream>
using namespace std;

int main() {
    int a, b;
    cin >> a >> b;
    int risposta = 1;

    for(int i = 1; i <= b; i++) {
        risposta = risposta * a;
    }
    cout << risposta << endl;
}
```

Compiliamo e testiamo la soluzione con qualche input:
```input
3 4
```
```output
81
```
$81$ è la risposta corretta. Proviamo con un altro input:
```input
14 14
```
```output
-1282129920
```
Qualcosa è andato storto, proviamo a capire meglio cosa inserendo un `std::cout` nel ciclo:
```cpp
#include <iostream>
using namespace std;

int main() {
    int a,b;
    cin >> a >> b;
    int risposta = 1;

    for(int i = 1; i <= b; i++) {
        cout << i << ": " << risposta << endl;
        risposta = risposta * a;
    }
    cout << risposta << endl;
}
```
```input
14 14
```
```output
1: 1
2: 14
3: 196
4: 2744
5: 38416
6: 537824
7: 7529536
8: 105413504
9: 1475789056
10: -813789696
11: 1491846144
12: -588990464
13: 344068096
14: 521986048
-1282129920
```

Come possiamo vedere, alla decima iterazione del ciclo la risposta diventa negativa. Questo è dovuto ad un _overflow_, ovvero la variabile `risposta` di tipo `int` può contenere numeri fino a $2^31-1 = 2147483647$, ma il numero che stiamo cercando di calcolare è più grande! Per risolvere questo problema, usiamo invece di `int` il tipo `long long`, che contiene numeri fino a $2^63-1 approx 9.22 times 10^18$

```cpp
#include <iostream>
using namespace std;

int main() {
    long long a,b;
    cin >> a >> b;
    long long risposta = 1;

    for(int i = 1; i <= b; i++) {
        risposta = risposta * a;
    }
    cout << risposta << endl;
}
```
```input
14 14
```
```output
11112006825558016
```
]

=== Usare gli avvisi del compilatore

Il compilatore può segnalare alcune situazioni _sospette_ durante la compilazione. Per abilitare i vari controlli possiamo usare le opzioni `-Wall`, `-Wextra` e `-Wshadow`:
```sh
g++ -Wall -Wextra -Wshadow programma.cpp
```

Rispettivamente:
- `-Wall` attiva molti warning generici, ad esempio quelli per una funzione non-`void` senza `return` o per una variabile dichiarata ma mai usata;
- `-Wextra` attiva altri warning non inclusi in `-Wall`, come quello per un parametro della funzione mai utilizzato;
- `-Wshadow` segnala quando una variabile dichiarata in uno _scope_ interno oscura una variabile con lo stesso nome in uno _scope_ esterno.
Ricordiamo che gli avvisi non indicano necessariamente un errore, ma è buona pratica leggerli e correggerli quando possibile.

#example[Leggere un warning sul valore restituito][
  Una funzione con tipo di ritorno diverso da `void` deve restituire un valore.
In questo codice manca il `return`, quindi il compilatore può segnalare che l'esecuzione raggiunge la fine della funzione senza restituire un valore:
```cpp
int doppio(int x) {
    x * 2;
}
```
```output
programma.cpp: In function ‘int doppio(int)’:
programma.cpp:2:9: warning: statement has no effect [-Wunused-value]
    2 |     x * 2;
      |     ~~^~~
programma.cpp:3:1: warning: no return statement in function returning non-void [-Wreturn-type]
    3 | }
      | ^
```
La correzione è:
```cpp
int doppio(int x) {
    return x * 2;
}
```
]


#example[Individuare una variabile shadowed][
  Consideriamo il seguente codice, in cui vogliamo calcolare il massimo di un vettore:

```cpp
int massimo = a[0];

for (int i = 1; i < n; ++i) {
    int massimo = max(massimo, a[i]);
}

cout << massimo << "\n";
```
```output
programma.cpp:32:9: warning: declaration of ‘int massimo’ shadows a previous local [-Wshadow]
    32 |     int massimo = max(massimo, a[i]);
       |         ^~~~~~~
programma.cpp:1:5: note: shadowed declaration is here
    29 | int massimo = a[0];
       |     ^~~~~~~
```
La variabile `massimo` dichiarata nel ciclo nasconde quella esterna. Inoltre, nella sua inizializzazione viene usata prima di essere inizializzata. Il `massimo` esterno non viene aggiornato.
]


// TODO: complete debugging section or write a more advanced one
/*
- === Usare `assert`
- === Usare `fsanitize`
- === Usare `gdb` 
- === Usare `trapv`
- === Usare `valgrind`
*/
