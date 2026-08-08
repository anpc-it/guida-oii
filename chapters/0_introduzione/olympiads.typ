#import "../../config.typ"


== Cos'è una gara di informatica

In una gara di informatica si risolvono problemi scrivendo programmi. A ogni problema corrisponde un compito preciso: dato un certo input, il programma deve produrre l'output richiesto.

Per partecipare alle gare di informatica non è necessario sapere usare un programma già pronto #footnote([Per questo esiste #link("https://excel-esports.com")]), non si deve costruire un computer, tanto meno programmare dei robot. Una gara di informatica consiste nel trovare un _algoritmo_, cioè una sequenza finita di istruzioni che risolva correttamente tutti i casi di input previsti dal problema.

Le gare di informatica hanno quindi due aspetti distinti:

- trovare un algoritmo corretto (non serve dimostrare che sia corretto);
- implementarlo in un linguaggio di programmazione in modo abbastanza _efficiente_.
 
=== Le Olimpiadi Italiane di Informatica

Le OII sono una competizione rivolta agli studenti delle scuole secondarie superiori. Il percorso di selezione comprende diverse fasi, dalla selezione scolastica, alla selezione territoriale, fino alla gara nazionale. Le regole precise, le date e i criteri di selezione possono cambiare di anno in anno: per informazioni aggiornate consultare il #link("https://olimpiadi-informatica.it/")[sito ufficiale delle OII].

Dalla fase territoriale in poi l'obiettivo è lo stesso: leggere i dati forniti, elaborare una risposta e stamparla nel formato richiesto. La teoria richiesta per cominciare a partecipare alle olimpiadi di informatica è molto ridotta: basta saper scrivere codice in un linguaggio di programmazione a scelta (preferibilmente C++, ne parleremo nei capitoli futuri). La teoria spiegata in questo libro comprende principalmente strumenti e tecniche che possono essere applicate in molti problemi diversi, e che rendono la soluzione più efficiente o facile da tradurre in codice.

=== Com'è fatto un problema

Un problema contiene le seguenti sezioni:

- *Descrizione*: spiega la situazione e che cosa bisogna calcolare.
- *Input*: descrive i dati che il programma riceverà.
- *Output*: descrive esattamente che cosa il programma deve stampare.
- *Vincoli*: indicano quanto possono essere grandi i dati e sono fondamentali per scegliere l'algoritmo.
- *Subtask* (opzionale): sono sottoproblemi più semplici, che permettono di ottenere punteggio parziale.
- *Esempi*: mostrano alcuni input e il corrispondente output.

Consideriamo questo problema molto semplice:

#v(10pt)
*Problema*

Dati due interi $a$ e $b$, stampa il maggiore dei due.

*Input*

L'unica riga contiene due interi $a$ e $b$.

*Output*

Stampa il maggiore tra $a$ e $b$.

*Vincoli*

$-10^9 <= a, b <= 10^9$.

*Esempio*

```input
7 4
```

```output
7
```

Gli esempi mostrano solo alcuni casi semplici, mentre una soluzione deve funzionare per tutti i valori ammessi dai vincoli.

=== Il programma e il giudice

Durante una gara il programma non conversa con una persona. Un sistema automatico, chiamato _giudice_, avvia il tuo programma, gli fornisce l'input e controlla l'output.

La comunicazione tra il programma e il giudice avviene solitamente sull'_input standard_ e _output standard_. In C++ questi due canali sono normalmente gestiti da `std::cin` e `std::cout`, come vedremo più avanti. Il programma deve terminare da solo: non deve chiedere conferma all'utente e non deve stampare messaggi aggiuntivi come `Inserisci un numero`.

Per il problema precedente, un output come questo non sarebbe corretto:

```output
Il risultato è: 7
```

Il giudice si aspetta il formato indicato nella sezione Output, quindi bisogna stampare soltanto:

```output
7
```

Gli esempi servono a capire il formato dell'output richiesto ed a testare la tua soluzione, ma il giudice testerà la tua soluzione con molti altri input nascosti. 

Nota che questo non è l'unico formato di problemi possibile: esistono anche i problemi _output only_ e i problemi _interattivi_:

- _output only_: Sono problemi in cui l'utente scarica tutti i test di input, anche quelli segreti, e li processa sulla propria macchina. Gli input possono essere _statici_ o _dinamici_: nel primo caso sono uguali per tutti gli utenti e non cambiano nel tempo, nell'altro sono diversi per ogni utente e vengono rigenerati dopo un intervallo di tempo oppure se viene inviata un soluzione. 
  
  Nella *fase territoriale* delle OII il fomato dei problemi è *_output only dinamico_*.

- _interattivi_: Un problema interattivo prevede che la soluzione dell'utente comunichi con un altra soluzione (o con se stessa) tramite specifiche funzioni. Questa classe di problemi è abbastanza rara: compare a volte tra i problemi della fase finale delle OII, oppure in gare internazionali.
// TODO: fare un capitolo sugli interattivi e linkarlo qua

=== Vincoli di tempo e di memoria

Oltre a dover risolvere il problema correttamente, la tua soluzione dovrà rispettare degli ulteriori vincoli sul _tempo di esecuzione_ e _memoria_. Andiamo con ordine e consideriamo il seguente problema:

"Dato un intero positivo $N$ calcolare la somma di tutti i numeri da $1$ a $N$".

- *Soluzione 1*: Eseguiamo la somma $1 + 2 + ... + N$ e stampiamo in output il risultato. Questa soluzione è assolutamente corretta, ma calcola la somma eseguendo $N-1$ somme diverse.  
- *Soluzione 2*: Usiamo la formula chiusa $(N (N+1))/2$ e stampiamo questo valore. Anche questa soluzione è corretta, ma esegue solo $3$ operazioni, indipendentemente dal valore di $N$. 

Se proviamo effettivamente a scrivere queste due soluzioni in C++ e misuriamo quanto tempo ci impiegano ad eseguire per valori diversi di $N$ otteniamo questa tabella: #footnote([Il tempo di esecuzione dipende dal computer su cui viene eseguito il programma. In questo caso un _MacBook Pro M4 Max (16-core CPU)_ compilato con clang versione _21.0.0_, _C++17_. ])

#table(
  columns: 3,
  align: right,
  [N], [Soluzione 1], [Soluzione 2],
  [$10^5$], [0.057 ms], [< 0.001 ms],
  [$10^6$], [0.607 ms], [< 0.001 ms],
  [$10^7$], [5.95 ms], [< 0.001 ms],
  [$10^8$], [51.6 ms], [< 0.001 ms],
  [$10^9$], [515 ms], [< 0.001 ms],
) 

Come possiamo notare, per $N = 10^9$ la prima soluzione è più di $500.000$ volte più lenta! Questo è dovuto a un semplice fatto: i computer impiegano del tempo a svolgere le operazioni. Questo argomento verrà ripreso in dettaglio nel #link(<complexity>)[capitolo sulla complessità computazionale], per ora però teniamo a mente che esistono soluzioni più o meno veloci che risolvono lo stesso problema.

In modo simile, esistono soluzioni che utilizzano più o meno memoria. La memoria del computer serve a conservare i dati che il programma sta usando: variabili, array, stringhe e strutture dati. Anche la memoria disponibile è limitata e il giudice può interrompere una soluzione che ne utilizza troppa.

Supponiamo di avere un vettore di $N$ interi salvati in memoria durante l'esecuzione.
Un intero occupa normalmente $4$ byte, quindi questo vettore richiede circa $4N$ byte: circa $4$ MB per $N = 10^6$ e circa $4$ GB per $N = 10^9$.

Per farci un'idea, limiti di tempo e memoria comunemente usati sono $1$ secondo e $256$ MB di memoria ( $approx 60$ milioni di interi), ma possono variare per problema ogni problema. 

=== I vincoli
// TODO: this section is poorly written and somewhat unclear, needs rewriting

Supponiamo che un problema chieda di verificare se in una lista compare un certo valore. Se la lista contiene al massimo cento elementi, anche controllare tutte le posizioni può essere sufficiente. Se invece può contenerne un miliardo, lo stesso approccio potrebbe essere troppo lento o richiedere troppa memoria.

I vincoli aiutano quindi a rispondere a una domanda fondamentale: _quanto tempo e memoria posso permettermi di consumare?_

I subtask servono proprio a questo. Se hai una soluzione corretta, ma che usa troppo tempo, memoria, o risolve solo casi specifici del problema originale, i subtask fanno avere comunque un punteggio parziale. Facciamo un esempio:

Supponiamo che i limiti per un generico problema siano $N <= 10^18$, dei subtask plausibili possono essere:
- $N = 1$ 
- $N <= 100$
- $N <= 10^6$

Se la nostra soluzione sfora il tempo massimo per, ad esempio, $N = 1000$, otterremo comunque i punteggi del primo e secondo subtask.

=== I risultati della valutazione

Quando inviamo una soluzione, il giudice può restituire risultati diversi:

- *Accepted* (AC): la soluzione ha prodotto risposte corrette per tutti i test assegnati e ha rispettato i limiti.
- *Wrong Answer* (WA): almeno una risposta è sbagliata oppure l'output non rispetta il formato richiesto.
- *Compilation Error* (CE o CTE): il codice non può essere trasformato in un programma eseguibile, per esempio a causa di un errore di sintassi.
- *Runtime Error* (RTE): il programma si interrompe durante l'esecuzione, per esempio accedendo a una posizione inesistente di un array.
- *Time Limit Exceeded* (TLE): il programma non termina entro il tempo consentito.
- *Memory Limit Exceeded* (MLE): il programma usa più memoria di quella consentita.

Un risultato diverso da *Accepted* non significa sempre che l'algoritmo sia sbagliato. Ad esempio, un TLE indica spesso che serve un algoritmo più veloce.

Nota: su #link("https://training.olinfo.it") "Memory Limit Exceeded" e "Runtime Error" sono combinati in un singolo verdetto: *Execution Killed*.
