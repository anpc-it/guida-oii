#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *


== Concetti base di programmazione in C++ <cpp_intro>

Hai capito come risolvere il problema! Cioè sapresti redigere una lista di istruzioni a prova di idiota (per brevità, _algoritmo_) che permetta a chiunque di risolvere non uno, ma tutti i possibili casi di input.
Purtroppo lo staff delle Olimpiadi di Informatica non è pagato abbastanza per leggere la lista che hai scarabocchiato su carta e giudicarne la correttezza, per questo, ma anche perché non siamo alle Olimpiadi della Matematica#footnote[La partecipazione alle quali ci sentiamo di consigliare.] e a noi i risultati piace averli subito, la lista non la scrivi per noi ma per le macchine.

Ti consigliamo di scrivere il tuo codice in C++ per almeno due buoni motivi:
+ la sua Standard Template Library offre una vasta collezione di strutture dati e algoritmi adatti all'utilizzo come scatole nere. C++ è inoltre un linguaggio molto efficiente e permette, a chi lo desidera, un controllo a basso livello della memoria per eventuali ulteriori ottimizzazioni;
+ è l'unico linguaggio ammesso alle OII.

Un file C++ ha l'aspetto che segue:

#codly(
	header: [*ilnomedeltuofile.cpp*],
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

Ora che abbiamo scritto il nostro programma, è giunto il momento di compilarlo! Per compilare il sorgente ci sono due modi principali:
    1. Tramite l'*IDE* in cui stiamo lavorando, è spesso possibile compilare ed eseguire il programma premendo un tasto (o una combinazione/sequenza). Ad esempio, su _Visual Studio Code_ `F5`, su _Code::Blocks_ `F9`, su _Dev-C++_ `F11`. 
    
        Lo staff delle OII ha messo a disposizione un IDE online (#link("https://editor.olinfo.it", `editor.olinfo.it`)) per compilare ed eseguire il codice senza installare nulla sul proprio computer. Per quanto questo IDE sia comodo all'inizio, è consigliabile installare un IDE sul proprio computer per svariate ragioni, tra cui la possibilità di fare _debugging_ in maniera più efficace e il fatto che l'editor online non sarà disponibile durante la finale delle OII. 

    2. (*Consigliato*) Tramite *terminale* si può avere un controllo più granulare sulla compilazione (che, come vedremo nella sezione di _Debugging_, può tornare molto utile). 
        - *Windows*: Possiamo installare `g++` tramite #link("https://dev.to/prastha/install-mingw-w64-on-windows-11-2025-november-acg", `MinGW`) o `MSYS2`. Compiliamo il sorgente con \ 
        ```sh 
        g++ ilnomedeltuofile.cpp
        ```
        Nella cartella comparirà un file chiamato `a.exe`, che possiamo eseguire tramite il comando \
        ```sh 
        ./a
        ```
        - *Linux*: Tramite il _package manager_ del sistema possiamo direttamente installare `g++`, appartenente al pacchetto `gcc` (Es. su _Arch Linux_, ```sh sudo pacman -S gcc```). Compiliamo tramite \
        ```sh 
        g++ ilnomedeltuofile.cpp
        ```
        Nella cartella comparirà un file chiamato `a.out`, che possiamo eseguire tramite il comando 
        ```sh
        ./a.out
        ```


#figure(
    image("../../figures/compile_and_run.png", width: 40%),
    caption: "Esempio di compilazione su Linux."
)

=== Esempi

È normale la sintassi appaia inizialmente un po' criptica. Ti invitiamo a capire#footnote[Cioè a indovinare.] il funzionamento delle varie parti nei codici che seguono. La strategia migliore è sperimentare.

Il seguente programma legge prima un intero $n$, poi $n$ interi $a_0, dots, a_(n-1)$ e li stampa in ordine inverso.
```cpp
#include <vector>
#include <iostream>

int main() {
    int n;
    std::cin >> n;
    
    std::vector<int> a(n);
    for (int i = 0; i < n; ++i)
        std::cin >> a[i];

    for (int i = n - 1; i >= 0; --i)
        std::cout << a[i] << " ";

    std::cout << "\n";
}
```

Ahinoi, abbiamo omesso il valore di ritorno! Poco male, il main è una funzione speciale e se tutto va bene già lo conosce. Lo stesso non vale per le funzioni che definiremo in futuro.
I due modi consigliati per gestire liste di elementi sono gli `std::vector`, liste di dimensione variabile, e gli `std::array`, liste di dimensione fissa. Un `std::array<int, 10> arr` è una lista di dieci interi, all'$i$-esimo dei quali si accede con `arr[i]`.
Scrivere `std::` prima di ogni funzione o oggetto della libreria standard è sconveniente: d'ora in poi la stringa `using namespace std;` ci risparmierà questa fatica.

Se hai già avuto modo di partecipare alla fase #link("https://training.olinfo.it/tasks/terry/1")[territoriale], saprai che per ogni problema ricevi un file di input contenente più istanze dello stesso problema. In questi casi conviene definire una funzione `solve` che il main chiamerà tante volte quante sono le istanze. Qualcuno, probabilmente mentre partecipava alle Terry, ha già pensato a come evitare sconvenienti copia-incolla lunghi milioni di caratteri e ha inventato la lettura dell'input e scrittura dell'output da e su file.

```cpp
#include <iostream>
using namespace std;

void solve() {
    int a; cin >> a;
    int b; cin >> b;
    cout << a + b << "\n";
}

int main() {
    freopen("input.txt", "r", stdin);
    freopen("output.txt", "w", stdout);

    int T; cin >> T;
    for (int caso = 1; caso <= T; ++caso) {
        cout << "Case #" << caso << ": ";
        solve();
    }
}
```

Una funzione di tipo `void` non ha nessun valore di ritorno e semplicemente svolge delle operazioni. In generale una funzione ha un valore di ritorno che specifichiamo con `return <valore>;`. Una funzione può anche chiamare se stessa, nel cui caso si dice "ricorsiva". Implementiamo quindi una funzione ricorsiva di tipo `int` per il calcolo del fattoriale
#footnote[Basterebbe anche un ciclo for, altre volte la ricorsione è estremamente utile.]
di un naturale $n$, definito come $n! = 1 dot 2 dot ... dot n = n dot (n - 1)!$ per $n != 0$ e ponendo $0! = 1$.
```cpp
int fact(int n) {
    if (n == 0)
        return 1;
    return n * fact(n - 1);
}
```

Il costrutto `if (<condizione>) ` precede un blocco di codice che viene eseguito se e solo se la condizione è vera, in questo caso se e solo se $n = 0$. Poiché il blocco di codice consta di una sola istruzione, possiamo omettere le parentesi graffe altrimenti necessarie per isolarlo, in maniera del tutto analoga ai cicli for
#footnote[Lo avevi notato?].
Secondo te cosa accadrebbe se non mettessi il _caso base_ per $n = 0$ nella definizione di `fact`?

Per ora abbiamo avuto a che fare solo con variabili di tipo `int`, ma è ragionevole voler maneggiare anche numeri decimali, caratteri, stringhe di caratteri o interi più grandi
#footnote[Cosa succede se provi a calcolare il fattoriale di 15?].
Per questo esistono rispettivamente le variabili di tipo `double`, `char`, le `std::string` e i `long long`.
Poiché un computer non ha memoria infinita, ogni variabile ha dimensione finita, che ha lato pratico significa che un `int` contiene interi nell'intervallo $[-2^(31), 2^(31) - 1]$
#footnote[ricordando $2^(10) = 1024$ puoi stimare $2^(31)$ circa uguale a due miliardi],
per un `long long` l'intervallo è $[-2^(63), 2^(63) - 1]$ e un `double` ha una precisione relativa di circa $10^(-16)$.
Un `char` è un carattere rappresentato come un intero secondo la #link("https://it.wikipedia.org/wiki/ASCII")[Tabella ASCII] e una `std::string` funziona esattamente come un `std::vector<char>`, ossia un vettore di caratteri. Il seguente programma legge una parola (senza spazi) e stampa la frequenza di ogni carattere.

```cpp
#include <array>
#include <string>
#include <iostream>
using namespace std;

int main() {
    array<int, 128> freq;
    string s; cin >> s;
    for (int i = 0; i < (int)s.size(); ++i)
        ++freq[s[i]];
    for (int c = 32; c < 128; ++c)
        if (freq[c] != 0)
            cout << (char)c << ": " << freq[c] << "\n";
}
```

Più in generale, quando data una lista di interi $a_0, ..., a_(n-1)$ siamo interessati a conoscere la frequenza con cui ognuno appare, se gli $a_i$ sono troppo grandi e non possiamo permetterci di allocare un array di quelle dimensioni, possiamo usare una `std::map` nel modo seguente.

```cpp
#include <map>
#include <iostream>
using namespace std;

int main() {
    int n; cin >> n;
    map<int, int> freq;
    for (int i = 0; i < n; ++i) {
        int x; cin >> x;
        ++freq[x];
    }
    for (auto [key, value] : freq) {
        cout << key << ": " << value << "\n";
    }
}
```

Menzioniamo infine che per ordinare gli elementi di un vettore `a` in ordine crescente è possibile chiamare l'apposita funzione `std::sort(begin(a), end(a))` definita nella libreria `<algorithm>`.


// disclaimer
Prima di salutarci, sappi che tante scelte convenienti quando si fa programmazione competitiva sono da evitare, per mille motivi, in altri ambiti#footnote[Vedi il punto 7 di #link("https://www.comp.nus.edu.sg/~stevenha/cs3233.html").]. Al prossimo capitolo.

=== Problemi consigliati
- #link("https://training.olinfo.it/task/massimo")
- #link("https://training.olinfo.it/task/ois_biglietti")
- #link("https://training.olinfo.it/task/terry/download")
- #link("https://training.olinfo.it/task/catalogo")

=== Una nota per la programmazione competitiva
Quando gareggi hai tempo limitato per scrivere le tue soluzioni. Per questo motivo è comune adottare strategie per rendere più fluida la scrittura del codice ed eventualmente ridurre il numero di caratteri necessari a esprimere lo stesso concetto. Considera il seguente esempio.
```cpp
#include <bits/stdc++.h>
using namespace std;
using LL = long long;
#define all(x) begin(x), end(x)

int main() {
    int n; cin >> n;
    vector<LL> a(n);
    for (LL& x : a)
        cin >> x;
    sort(all(a));
    a.erase(unique(all(a)), end(a));
    for (LL x : a)
        cout << x << " ";
    cout << "\n";
}
```
La libreria omnicomprensiva `bits/stdc++.h` include tutte le librerie standard del C++ in un colpo solo#footnote[Attenzione: potrebbe non essere disponibile su tutti i compilatori.]: i tempi di compilazione si allungano, in compenso puoi pensare a una cosa in meno mentre risolvi il problema.
L'istruzione `using LL = long long;` significa che da quel momento in poi `LL` può sostituire la parola chiave `long long`.
In modo simile, la "macro" `#define all(x) begin(x), end(x)` sostituisce#footnote[Prima della compilazione.] ogni occorrenza di `all(<nome>)` con `begin(<nome>), end(<nome>)`, risparmiando qualche carattere. Nel complesso, il codice legge un intero $n$ seguito da $n$ interi e stampa l'insieme (senza ripetizioni) degli elementi inseriti in ordine crescente. Puoi scoprire il perché leggendo la documentazione relativa alle funzioni #link("https://en.cppreference.com/w/cpp/algorithm/unique")[`std::unique`] ed #link("https://en.cppreference.com/w/cpp/container/vector/erase")[`std::vector::erase`].
