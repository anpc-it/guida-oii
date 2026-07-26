#import "../../config.typ"

== Debugging

Il _debugging_, o in italiano "_correzione degli errori_", è il processo di rimozione di errori logici o concettuali (in inglese, _bugs_) dal proprio codice. A meno che non abbiate vinto almeno 3 medaglie d'oro alle _IOI_, durante fase di stesura del codice è molto probabile che vengano inseriti inavvertitamente dei bugs, perciò familiarizzare e padroneggiare le tecniche di debugging è essenziale. Elenchiamo qui sotto le tecniche e gli strumenti più efficaci per fare _debugging_:

- === Usare `std::cout` o `std::cerr`
Il metodo più banale (ma spesso il più efficace) per scovare bugs è quello di stampare delle informazioni intermedie durante l'esecuzione del codice. Capiamo meglio con un semplice esempio:

// TODO: trovare un esempio migliore per debugging std::cout D:
"_Dati due interi $a,b$ tali che $1 <= a,b <= 14$, calcolare $a^b$._"

Consideriamo il seguente codice che dovrebbe risolvere il problema:

```cpp
#include <iostream>
using namespace std;

int main() {
    int a,b;
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

// TODO: finire la sezione di debugging, decidere se spostare in un capitolo più avanti (debugging avanzato) o meno. Alcune tecniche da menzionare sono le seguenti:
- === Usare `assert`
- === Usare `fsanitize`
- === Usare `gdb` 
- === Usare `trapv`
- === Usare `-Wall`
- === Usare `valgrind`
