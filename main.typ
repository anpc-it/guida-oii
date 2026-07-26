#import "config.typ"
#show: config.config


#set document(
  title: "Guida alle Olimpiadi di Informatica",
  author: ("M. Arcari", "L. Ferrari", "F. Vercellesi", "L. Versari"),
)
#let affiliation = "Associazione Nazionale Programmazione Competitiva"
#let edition = "Prima edizione"
// si ringraziano anche:
// - Valerio Stancanelli

#set page(margin: 2cm)
#align(center + horizon)[
  #set par(justify: false)
  #text(size: 32pt, weight: "bold", hyphenate: false)[#context document.title]
  #v(2em)
  #text(size: 18pt)[#context document.author.join(", ")]
  #v(1em)
  #text(size: 14pt)[#edition]
]

#pagebreak()

#set heading(numbering: none)
#show outline.entry.where(level: 1): strong
#show math.equation.where(block: false): box
#show raw.where(block: true): set text(size: 7pt)

#outline(depth: 2)
#pagebreak(weak: true)

= Prefazione

#include "chapters/preface.typ"

#set heading(numbering: (..nums) => {
  let nums = nums.pos()
  if nums.len() == 1 {
    numbering("I", ..nums)
  } else if (nums.len() == 2) {
    numbering("1", ..nums.slice(1))
  } else {
    none
  }
})

#show heading.where(depth: 1): it => {
  let number = context(counter(heading).display())

  pagebreak(weak: true)
  align(center + horizon)[
    #text(size: 26pt, weight: "bold")[Parte #number]\
    #v(0mm)
    #it.body
  ]
}

#show heading.where(depth: 2): it => {
  let number = context(counter(heading).display())

  pagebreak(weak: true)
  strong("Capitolo " + number + ": " + it.body)
}


// ========== Contenuti ===========


= Introduzione alla programmazione competitiva //introduzione

#include "chapters/0_introduzione/cpp_basics.typ"
#include "chapters/0_introduzione/debugging.typ"


= Argomenti di base //terry

#include "chapters/1_terry/complexity.typ"
#include "chapters/1_terry/greedy.typ"
#include "chapters/1_terry/ds_basics.typ"
#include "chapters/1_terry/binary_search.typ"
#include "chapters/1_terry/dp_basics.typ"
#include "chapters/1_terry/graphs.typ"
#include "chapters/1_terry/trees.typ"


= Argomenti avanzati //oii


= Extra //ioi

#include "chapters/3_ioi/sos_dp.typ"


= Problemi passati //editorials

#include "chapters/4_editorials/graph_problems.typ"


#pagebreak()
#include "sources.typ"
