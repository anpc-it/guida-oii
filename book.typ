#import "@preview/shiroa:0.4.0": *
#show: book
#book-meta(
  title: "Guida alle Olimpiadi di Informatica",
  description: "Una guida per chi si avvicina alla programmazione competitiva e alle OII.",
  authors: ("M. Arcari", "A. Coato", "L. Ferrari", "F. Vercellesi", "L. Versari"),
  language: "it",
  repository: "https://github.com/anpc-it/guida-oii",
  summary: [
    = Prefazione
    - #chapter("chapters/preface.typ", section: "0")[Prefazione]

    = Introduzione
    - #chapter("chapters/0_introduzione/olympiads.typ", section: "1.1")[Cos'è una gara di informatica]
    - #chapter("chapters/0_introduzione/cpp_basics.typ", section: "1.2")[Concetti base di C++]
    - #chapter("chapters/0_introduzione/debugging.typ", section: "1.3")[Debugging]

    = Argomenti di base
    - #chapter("chapters/1_terry/complexity.typ", section: "2.1")[Complessità computazionale]
    - #chapter("chapters/1_terry/stl.typ", section: "2.2")[Standard Template Library (STL)]
    - #chapter("chapters/1_terry/greedy.typ", section: "2.3")[Problemi greedy]
    - #chapter("chapters/1_terry/complete_search.typ", section: "2.4")[Ricorsione e ricerca completa]
    - #chapter("chapters/1_terry/binary_search.typ", section: "2.5")[Ricerca binaria]
    - #chapter("chapters/1_terry/dp_basics.typ", section: "2.6")[Programmazione dinamica]
    - #chapter("chapters/1_terry/graphs.typ", section: "2.7")[Grafi]
    - #chapter("chapters/1_terry/trees.typ", section: "2.8")[Alberi]

    = Argomenti avanzati
    - #chapter("chapters/2_oii/stl2.typ", section: "3.1")[Altre funzionalità della STL]

    = Extra
    - #chapter("chapters/3_ioi/sos_dp.typ", section: "4.1")[Sum over Subsets DP]

    = Problemi passati
    - #chapter("chapters/4_editorials/graph_problems.typ", section: "5.1")[Problemi di grafi]

    = Debug
    - #chapter("chapters/5_debug/debug_tests.typ", section: "6.1")[Debug]
  ])

#import "/templates/page.typ": project
#let book-page = project
