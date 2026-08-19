#import "/templates/page.typ": project
#import "/utils/render.typ": is-web

#let render = if is-web { project.with(title: "Introduzione a C++") } else { it => it }
#show: render

#import "../../utils/code.typ": code
#import "../../utils/ref.typ": crossref


== Concetti base di programmazione in C++

// Hai capito come risolvere il problema! Cioè sapresti redigere una lista di istruzioni a prova di idiota (per brevità, _algoritmo_) che permetta a chiunque di risolvere non uno, ma tutti i possibili casi di input.
// Purtroppo lo staff delle Olimpiadi di Informatica non è pagato abbastanza per leggere la lista che hai scarabocchiato su carta e giudicarne la correttezza, per questo, ma anche perché non siamo alle Olimpiadi della Matematica#footnote[La partecipazione alle quali ci sentiamo di consigliare.] e a noi i risultati piace averli subito, la lista non la scrivi per noi ma per le macchine.

Prima di cominciare a risolvere effettivamente i problemi, dobbiamo possedere alcune conoscenze di base di programmazione.
In questa guida assumeremo che il lettore conosca già i principali costrutti della programmazione (variabili, cicli, funzioni e istruzioni `if`/`else`).

Consigliamo di scrivere il codice in C++ per diversi motivi:
+ la libreria standard del C++ offre una vasta collezione di strutture dati e algoritmi pronti all'uso;
+ è un linguaggio efficiente e permette, quando necessario, di controllare in modo granulare l'uso della memoria;
+ è l'unico linguaggio ammesso alla finale OII e dalla maggior parte delle competizioni internazionali.

Il file C++ più semplice (e inutile) che possiamo scrivere è il seguente:
```cpp
int main() {
    return 0;
}
```

`int main()` è il punto di ingresso del nostro programma. La funzione `main` restituisce un `int`: questo valore è il _codice di uscita_. Per convenzione, `0` indica la terminazione corretta, mentre un valore diverso da `0` segnala un'anomalia. Se l'esecuzione raggiunge la fine di `main` senza incontrare un'istruzione `return`, in C++ viene restituito automaticamente `0`.

Questo programma per ora non produce alcun output. Proviamo a stampare una stringa di testo, per esempio `Ciao Dario!`.

#code(
  header: [*ciao_dario.cpp*],
)
```cpp
#include <iostream>
using namespace std;

int main() {
    cout << "Ciao Dario!" << endl;
    return 0;
}
```
In C++ le varie dichiarazioni delle librerie vanno incluse nella compilazione tramite la keyword `#include`. La maggior parte delle dichiarazioni della _libreria standard_ appartiene principalmente al namespace `std`. L'istruzione `using namespace std;` permette di usarli senza scrivere ogni volta il prefisso `std::`.

`cout` (abbr. di "character output") scrive sullo stream standard di output. `endl` inserisce un carattere di fine riga e svuota il buffer associato allo stream.

Nota: in futuro useremo spesso `'\n'` al posto di `endl`, perché inserisce una nuova riga senza forzare lo svuotamento del buffer, operazione solitamente molto lenta. Il buffer viene comunque svuotato automaticamente, per esempio quando è pieno o quando lo stream viene chiuso.

Ora che abbiamo scritto il nostro programma, è giunto il momento di compilarlo! Per compilare il sorgente ci sono due modi principali:
    1. Tramite l'*IDE* in cui stiamo lavorando è spesso possibile compilare ed eseguire il programma premendo un tasto (o una combinazione/sequenza). Ad esempio, su _Visual Studio Code_ `F5`, su _Code::Blocks_ `F9`, su _Dev-C++_ `F11`. 
    
        Lo staff delle OII ha messo a disposizione un IDE online (#link("https://editor.olinfo.it")) per compilare ed eseguire il codice senza installare nulla sul proprio computer. Per quanto questo IDE sia comodo all'inizio, è consigliabile installare un IDE sul proprio computer per svariate ragioni, tra cui la possibilità di fare _debugging_ in maniera più efficace e il fatto che l'editor online non sarà disponibile durante la finale delle OII.
        
// TODO: fact check the last sentence

    2. (*Consigliato*) Tramite *terminale* si può avere un controllo più granulare sulla compilazione (che, come vedremo nel #crossref(<debugging>, "/chapters/0_introduzione/debugging.typ", "capitolo sul Debugging"), può tornare molto utile).
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
  box(
    fill: luma(20%),
    inset: 5pt,
    align(left, text(luma(90%), size: 8pt, font: "JetBrains Mono")[
      > g++ ciao_dario.cpp \
      > ls \
      #text(olive)[a.out] ciao_dario.cpp \
      > ./a.out \
      Ciao Dario!
    ],
  )),
  caption: "Esempio di compilazione su Linux."
)

=== Esempi

Vediamo altri esempi. Il seguente programma legge prima un intero $n$, poi $n$ interi $a_0, dots, a_(n-1)$ e li stampa in ordine inverso.
```cpp
#include <vector>
#include <iostream>
using namespace std;

int main() {
    int n;
    cin >> n;
    
    vector<int> a(n);
    for (int i = 0; i < n; ++i)
        cin >> a[i];

    for (int i = n - 1; i >= 0; --i)
        cout << a[i] << " ";

    cout << "\n";
}
```

`cin` è lo stream di input standard del C++ ed è la controparte di `cout`. L'operatore `>>` (diverso da quello del cout, `<<`) legge i dati dallo stream, ignorando automaticamente gli spazi bianchi iniziali.
L'istruzione `vector<int> a(n)` costruisce un `vector` di `n` elementi di tipo `int`. Gli elementi vengono poi letti uno alla volta nel ciclo `for`.
Infine, un ciclo `for` percorre il vettore al contrario, dagli indici `n - 1` a `0`, e `cout` ne stampa gli elementi.

Vediamo ora un esempio leggermente più articolato:
```cpp
#include <iostream>
#include <cstdio>
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

`freopen(file, mode, stream)` dirotta lo `stream` specificato e lo associa al `file`. Se `mode` è `"r"` (read), il file viene aperto per la lettura; se è `"w"` (write), viene aperto per la scrittura e il suo contenuto precedente viene sovrascritto.
In questo caso il programma reindirizza l'input standard verso `input.txt` e l'output standard verso `output.txt`. Di conseguenza, le operazioni su `cin` e `cout` usano rispettivamente quei due file. Questo è il formato standard di input/output per la fase territoriale.

Oltre a `main`, abbiamo definito la funzione `void solve()`.
Una funzione di tipo `void` non restituisce un valore; può terminare raggiungendo la fine delle istruzioni oppure eseguendo `return;`. Una funzione con un tipo di ritorno diverso da `void` deve invece restituire sempre un valore del tipo corretto tramite `return <valore>;`, altrimenti il comportamento è indefinito.

Una funzione può anche chiamare se stessa; in questo caso si dice che è ricorsiva. Implementiamo quindi una funzione ricorsiva di tipo `int` per il calcolo del fattoriale
#footnote[In questo caso basterebbe anche un ciclo for, altre volte la ricorsione è estremamente utile.]
di un numero naturale $n$, definito come $n! = 1 dot 2 dot ... dot n = n dot (n - 1)!$ per $n > 0$, ponendo $0! = 1$.
```cpp
int fact(int n) {
    if (n == 0)
        return 1;
    return n * fact(n - 1);
}
```<factorial>

Secondo te cosa accadrebbe se non inserissi il _caso base_ per $n = 0$ nella definizione di `fact`? E se chiamassi `fact(-1)`?

Per ora abbiamo usato solo `int`, ma non è l'unico tipo di variabile. Presentiamo un breve elenco dei tipi più comunemente usati:

#figure(
  table(
    columns: 3,
    align: (left, right, left),
    [*Tipo*], [*Byte*], [*Dettagli*],
    [`char`], [1], [Un singolo carattere.],
    [`bool`], [1], [Un valore booleano: `true` oppure `false`.],
    [`int`], [4], [Un intero; tipicamente da $-2^31$ a $2^31 - 1$ (circa $2 dot 10^9$).],
    [`long long`], [8], [Un intero di 64 bit; tipicamente da $-2^63$ a $2^63 - 1$ (circa $9 dot 10^18$).],
    [`float`], [4], [Numero reale con precisione singola.],
    [`double`], [8], [Numero reale con precisione doppia.],
    [`std::string`], [variabile], [Stringa di lunghezza variabile; la memoria dipende dal contenuto.],
  )
)

Cosa succede quando si provano a salvare dentro un tipo di variabile come `int` valori maggiori a quelli massimi consentiti?
Un _overflow_ si verifica quando il risultato di un'operazione supera il valore massimo, o scende sotto il valore minimo (_underflow_), rappresentabile dal tipo scelto. Con gli interi con segno, il comportamento risultante è indefinito, ma solitamente genera valori spazzatura. Con gli interi senza segno (solo positivi), il risultato è quello corretto ma troncato ai bit disponibili.

In molti #footnote([In alcuni problemi, rispettare il limite di memoria è la parte più complicata del problema. Ad esempio, #link("https://training.olinfo.it/task/tai_cct2").])
problemi la memoria massima consentita è molto generosa, quindi risulta più conveniente usare `long long` ovunque al posto di `int` per evitare questo tipo di errori.
Dato che `long long` è più lungo da scrivere, possiamo definire un _alias_ all'inizio del codice con `using ll = long long;`, così da poter usare la sintassi abbreviata `ll`.

// disclaimer
//Prima di salutarci, sappi che tante scelte convenienti quando si fa programmazione competitiva sono da evitare, per mille motivi, in altri ambiti#footnote[Vedi il punto 7 di #link("https://www.comp.nus.edu.sg/~stevenha/cs3233.html").]. Al prossimo capitolo.

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
using ll = long long;
#define all(x) begin(x), end(x)

int main() {
    int n; cin >> n;
    vector<ll> a(n);
    for (ll& x : a)
        cin >> x;
    sort(all(a));
    a.erase(unique(all(a)), end(a));
    for (ll x : a)
        cout << x << " ";
    cout << "\n";
}
```

In questo esempio non è importante comprendere il codice riga per riga; ciò che conta è il concetto:
quando si gareggia, spesso conviene abbandonare le "buone pratiche" insegnate a lezione per favorire un'implementazione più rapida ed efficiente.
