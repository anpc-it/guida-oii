#import "config.typ"
#show: config.config

#set document(
  title: "Guida alle Olimpiadi di Informatica",
  author: ("M. Arcari", "L. Ferrari", "F. Vercellesi", "L. Versari"),
)
#let affiliation = "Associazione Nazionale Programmazione Competitiva"

#set page(margin: 2cm)
#align(center + horizon)[
  #text(size: 32pt, weight: "bold")[#context document.title]
  #v(2em)
  #text(size: 18pt)[#context document.author.join(", ")]
  #v(1em)
  #text(size: 14pt)[#datetime.today().display()]
]

#pagebreak()

#include "chapters/preface.typ"
#outline(depth: 1)
#include "chapters/cpp_basics.typ"
#include "chapters/competitive_cpp.typ"
#include "chapters/greedy.typ"
#include "chapters/sos_dp.typ"
