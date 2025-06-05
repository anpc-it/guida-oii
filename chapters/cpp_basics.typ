#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()

#codly(
	languages: codly-languages,
	// number-format: none
)

= Concetti di base di programmazione in C++

Hai capito come risolvere il problema! Cioè sapresti come redigere una lista di istruzioni a prova di idiota che permetta a chiunque di risolvere non uno, ma tutti i possibili casi di input.
Purtroppo lo staff delle Olimpiadi di Informatica non è pagato abbastanza per leggere la lista che hai scarabocchiato su carta e giudicarne la correttezza, per questo, ma anche perché non siamo le Olimpiadi della Matematica#footnote[La partecipazione alle quali ci sentiamo di consigliare.] e a noi i risultati piace averli subito, la lista non la scrivete per noi ma per le macchine.

Noi vi consigliamo di scrivere il vostro codice in C++ per almeno due buoni motivi:
+ la sua Standard Template Library offre una vasta collezione di strutture dati e algoritmi adatti all'utilizzo come scatole nere. Inoltre C++ è un linguaggio molto efficiente e permette, a chi lo desidera, un controllo a basso livello della memoria per eventuali ulteriori ottimizzazioni;
+ è l'unico linguaggio ammesso alle OII.

Un file C++ ha l'aspetto che segue.

#codly(
	header: [*main.cpp*],
)
```cpp
#include <iostream>
using namespace std;

int main() {
	cout << "Hello World!\n";
}
```

La prima riga include la libreria `iostream`, che gestisce l'input e l'output. La parola chiave `include` è un'abbreviazione di "prendi questo file che sta da qualche parte sulla macchina e fai come se copia-incollassi il suo contenuto qui, al posto dell'`#include`".
// ...
// TODO: impostare le virgolette normali al posto di quelle angolate.
