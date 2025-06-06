#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#import "../util.typ": *
#show: codly-init.with()

#codly(languages: codly-languages)

= Problemi greedy

Come suggerisce il nome, nei problemi che vedremo tra poco la strategia vincente è agire come un avaro che in ogni momento prende per sé quanti più soldi possibile. Analizziamo ad esempio la seguente situazione:

#problem("Gelati costosi", url: "https://training.olinfo.it/task/pre-egoi-gelato", lbl: "gelati-costosi",
[
    Ci servono $C$ soldi per comprare il gelato e $N$ nostri amici sono disposti a prestarcene un po'. L'$i$-esimo amico ci può prestare al massimo $P_i$ soldi. Qual'è il minimo numero di amici a cui dobbiamo chiedere in prestito dei soldi?
])

È un problema abbastanza semplice di cui sappiamo delineare intuitivamente una strategia risolutiva: chiedo ogni volta all'amico che mi dà più soldi finché non arrivo ad avere $C$ soldi. 

Questa strategia si rivela essere quella ottimale! Di seguito l'implementazione:

#codly(
	header: [*Soluzione ottimale $cal(O)(N log N)$*],
)

```cpp
int presta(int N, int C, vector<int> P) {
    sort(P.begin(), P.end());
    int risposta = 0;
    while (C > 0) {
        risposta++;
        C -= P.back();
        P.pop_back();
    }
    return risposta;
}
```

La lezione che ne traiamo è che - in certi problemi - ad una scelta _localmente ottima_ formulata nel modo corretto, in questo caso, chiedere ogni volta all'amico che ci dà più soldi, ci conduce ad una soluzione _globalmente ottima_ che per questo problema corrisponde a minimizzare il numero di amici a cui chiedere.

Il miglior metro per capire se in un problema si possa applicare un approccio greedy è l'esperienza. Vediamo quindi un altro problema.

#problem("Viaggio in taxi", url: "https://training.olinfo.it/task/ois_taxi", lbl: "viaggio-in-taxi", 
[
    Dobbiamo passare per $N$ città in fila (numerate da $0$ a $N - 1$), equidistanti tra loro, ed arrivare alla fine nella città numero $N$. Nella città $i$ è presente un taxi che ci può portare alla città successiva $i + 1$ ad un costo di $C_i$ soldi. Arrivati alla città successiva, se non siamo arrivati alla città $N$, possiamo scegliere se proseguire prendendo il taxi presente in quella città per $C_(i + 1)$ soldi o rimanere sullo stesso taxi, che però aumenterà di $1$ soldo il suo prezzo per ogni città successiva alla propria città di partenza.
])

Facendo un esempio per capire meglio il testo, se nella prima città il taxi costa $3$ soldi, possiamo pagare $3$ per prenderlo e andare alla seconda città. Se nella seconda città il taxi costa $5$ possiamo scegliere se prendere quel taxi pagando $5$ o rimanere sul nostro taxi pagando questa volta $4$. Se rimaniamo sul nostro taxi alla stazione successiva pagheremo $5$ e così via.

Anche in questo problema la strategia intuitiva di prendere sempre il taxi che ci costa meno funziona perché in ogni caso entrambi aumenterebbero il loro prezzo di $1$ soldo a ogni stazione successiva. Quindi se il taxi $A$ costa meno del taxi $B$ in una certa città, costerà di meno anche in tutte le successive. 

#codly(
	header: [*Soluzione $cal(O)(N)$*],
)

```cpp
int viaggia(int N, vector<int> C) {
    int costo_totale = 0;
    int costo_attuale = INT_MAX;
    for (int i = 0; i < N; i++) {
        if (costo_attuale > C[i]) {
            costo_attuale = C[i];
        }
        costo_totale += costo_attuale;
        costo_attuale++;
    }
    return costo_totale;
}
```


