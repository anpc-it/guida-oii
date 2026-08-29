#import "/templates/page.typ": project
#import "/utils/render.typ": is-web

#let render = if is-web { project.with(title: "Prefazione") } else { it => it }
#show: render

Questa guida intende essere una risorsa per le persone che si avvicinano al mondo della programmazione competitiva, in particolare alla selezione territoriale e alla fase nazionale delle Olimpiadi Italiane di Informatica (OII).

#v(20pt)

La guida è strutturata nel seguente modo:
- *Capitolo $1$*: Introduzione alle olimpiadi di informatica, al C++ e ai problemi algoritmici.
- *Capitolo $2$*: Conoscenze di base. Questo capitolo mira a preparare uno studente ad affrontare la selezione territoriale.
- *Capitolo $3$*: Conoscenze avanzate. Questo capitolo mira a preparare uno studente ad affrontare la finale nazionale.
- *Capitolo $4$*: Contenuti extra. Queste conoscenze non sono richieste nelle fasi nazionali, ma possono essere utili per affrontare problemi specifici o gare internazionali.

#v(20pt)

Nota che queste indicazioni vanno prese con le pinze: seppur è possibile ottenere punteggio pieno alle varie fasi basandosi sulle conoscenze spiegate nei rispettivi capitoli, avere conoscenze extra dei capitoli che seguono può spesso tornare molto utile. Inoltre, queste indicazioni sono relative all'edizione 2025-2026 e precedenti, ma non è detto che rimangano uguali in futuro.

=== Come contribuire

Questa guida è un progetto in continuo miglioramento. È molto probabile che ci siano scappati errori, refusi o spiegazioni migliorabili. Se noti qualcosa che non va o hai idee per arricchire i contenuti, qualsiasi aiuto è benvenuto! Invece di scrivere direttamente ai singoli autori, ti invitiamo a segnalarlo o a proporre una modifica aprendo rispettivamente un issue o una pull request su GitHub: #link("https://github.com/anpc-it/guida-oii").

=== Una nota sul progetto

Questo testo nasce come una semplice raccolta di materiale didattico, scritta nel tempo libero e senza alcuna pretesa di completezza o perfezione. Né gli autori né ANPC traggono alcun profitto da questa guida: l'unico obiettivo è avvicinare quante più persone possibili all'informatica e al mondo delle olimpiadi. Per scoprire tutte le attività e i progetti di ANPC, puoi visitare il sito ufficiale: #link("https://anpc.it").

Se trovi utile questa guida e vuoi dare una mano a portare avanti progetti simili, ci farebbe davvero piacere un piccolo supporto all'*Associazione Nazionale Programmazione Competitiva (ANPC)*, ad esempio devolvendo il *5x1000*:

#align(center)[
  #if is-web {
    block(
    fill: luma(247),
    inset: (x: 14pt, y: 10pt),
    radius: 4pt,
    stroke: 0.5pt + luma(220),
    [
      *Associazione Nazionale Programmazione Competitiva (ANPC)* \
      #text(size: 20pt, fill: rgb("475569"))[Codice Fiscale: _*97979100159*_] \
      #text(size: 16pt, fill: rgb("475569"))[“Sostegno degli Enti del Terzo Settore iscritti nel RUNTS”]
    ],
  )
  } else {
    block(
    fill: luma(247),
    inset: (x: 14pt, y: 10pt),
    radius: 4pt,
    stroke: 0.5pt + luma(220),
    [
      *Associazione Nazionale Programmazione Competitiva (ANPC)* \
      #text(size: 11pt, fill: rgb("475569"))[Codice Fiscale: _*97979100159*_] \
      #text(size: 11pt, fill: rgb("475569"))[“Sostegno degli Enti del Terzo Settore iscritti nel RUNTS”]
    ],
  )
  }
]

Speriamo che queste pagine ti siano d'aiuto nel tuo percorso. Buono studio e buon divertimento!