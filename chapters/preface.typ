#import "/templates/page.typ": project
#import "/utils/render.typ": is-web

#let render = if is-web { project.with(title: "Prefazione") } else { it => it }
#show: render

Questa guida intende essere una risorsa per le persone che si avvicinano al mondo della programmazione competitiva, in particolare alla selezione territoriale e alla fase nazionale delle Olimpiadi Italiane di Informatica (OII).
Come i più attenti tra voi potrebbero notare, la guida è ancora in corso d'opera.

Almeno fino a che non sarà completata, una referenza più completa, dettagliata, ma anche avanzata, è il "Competitive Programmer's Handbook" di Antti Laaksonen, liberamente disponibile online all'indirizzo #link("https://cses.fi/book/book.pdf"). Una risorsa in italiano è invece la Guida per le selezioni territoriali di Alessandro Bugatti, che contiente anche numerosi problemi risolti; la trovate all'indirizzo #link("https://training.olinfo.it/bugatti.pdf").

Buona lettura e buon allenamento dallo staff delle Olimpiadi Italiane di Informatica.