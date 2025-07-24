#import "config.typ"
#show: config.config

#set document(
  title: "Guida alle Olimpiadi di Informatica",
  author: ("M. Arcari", "L. Ferrari", "F. Vercellesi", "L. Versari"),
)
#let affiliation = "Associazione Nazionale Programmazione Competitiva"

#set page(margin: 2cm)
#align(center + horizon)[
  #set par(justify: false)
  #text(size: 32pt, weight: "bold", hyphenate: false)[#context document.title]
  #v(2em)
  #text(size: 18pt)[#context document.author.join(", ")]
  #v(1em)
  #text(size: 14pt)[#datetime.today().display()]
]

#pagebreak()

#set heading(numbering: none)
#show outline.entry.where(level: 1): strong

#outline(depth: 2)
#pagebreak(weak: true)
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

= Tecniche e teoria

#include "chapters/cpp_basics.typ"
#include "chapters/competitive_cpp.typ"
#include "chapters/greedy.typ"
#include "chapters/dp_basics.typ"
#include "chapters/sos_dp.typ"

= Problemi passati
