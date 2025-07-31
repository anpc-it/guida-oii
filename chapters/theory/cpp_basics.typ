#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()

#codly(
	languages: codly-languages,
	// number-format: none
)

== Concetti di base di programmazione in C++

Hai capito come risolvere il problema! Cioè sapresti redigere una lista di istruzioni a prova di idiota (per brevità, _algoritmo_) che permetta a chiunque di risolvere non uno, ma tutti i possibili casi di input.
Purtroppo lo staff delle Olimpiadi di Informatica non è pagato abbastanza per leggere la lista che hai scarabocchiato su carta e giudicarne la correttezza, per questo, ma anche perché non siamo alle Olimpiadi della Matematica#footnote[La partecipazione alle quali ci sentiamo di consigliare.] e a noi i risultati piace averli subito, la lista non la scrivi per noi ma per le macchine.

Ti consigliamo di scrivere il tuo codice in C++ per almeno due buoni motivi:
+ la sua Standard Template Library offre una vasta collezione di strutture dati e algoritmi adatti all'utilizzo come scatole nere. Inoltre C++ è un linguaggio molto efficiente e permette, a chi lo desidera, un controllo a basso livello della memoria per eventuali ulteriori ottimizzazioni;
+ è l'unico linguaggio ammesso alle OII.

Puoi scrivere i tuoi programmi alla pagina #link("https://editor.olinfo.it"). Un file C++ ha l'aspetto che segue.

#codly(
	header: [*main.cpp*],
)
```cpp
#include <iostream>

int main() {
	std::cout << "Hello World!\n";
	return 0;
}
```

La prima riga include la libreria `iostream`, che implementa funzioni per gestire l'input e l'output. La parola chiave `include` è abbreviazione di "prendi questo file che sta da qualche parte sulla macchina e fai come se copia-incollassi il suo contenuto qui, al posto dell'`#include`".

L'esecuzione del codice inizia con la chiamata alla funzione `main`, che come valore di ritorno ha un intero (se tutto va bene: $0$).
La funzione `std::cout` della libreria `iostream` stampa a video la stringa "Hello World!" (senza apici), l'ultimo carattere `\n` "newline" indica di andare a capo.
L'istruzione `return` serve per restituire il valore di ritorno: il compito del `main` è terminato ed eventuali righe successive vengono ignorate.

// `using namespace std;` serve per accedere alle funzioni di libreria, quali ad esempio `std::cout``, senza la necessità di scrivere `std::` ogni volta.



// disclaimer
Sappiate che tante scelte convenienti quando si fa programmazione competitiva sono da evitare, per mille motivi, in altri ambiti: #link("www.google.com").
// poi linko la pagina giusta.

// se vuoi un ambiente nativo, ti consigliamo ...
