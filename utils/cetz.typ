#import "@preview/cetz:0.4.2" as cetz
#import "@preview/shiroa:0.4.0": is-web-target
#import "render.typ": is-native-html

// Keep these in sync with page.typ (main-size / web-scale).
// Web text is 18pt * 1.1, PDF text is 10.5pt.
#let pdf-text-size = 10.5pt
#let web-text-size = 18pt * 1.1
#let fig-scale = if is-web-target() { web-text-size / pdf-text-size } else { 1 }

#let canvas(..args) = {
  if is-native-html {
    block(
      width: 90%,
      inset: (x: 1em, y: 0.8em),
      fill: luma(96%),
      stroke: 0.5pt + luma(82%),
      radius: 0.3em,
      align(center)[
        #text(style: "italic", fill: luma(55%))[*Figura*]
      ],
    )
  } else if fig-scale == 1 {
    cetz.canvas(..args)
  } else {
    // scale strokes, arrowheads and text together with the canvas,
    // using the PDF text size inside so text isn't enlarged twice
    scale(fig-scale * 100%, reflow: true, {
      set text(size: pdf-text-size)
      cetz.canvas(..args)
    })
  }
}

// Scales arbitrary content (grids, tidy trees, ...) so that it keeps the same
// proportions with the text as in the PDF. No-op on PDF.
#let fit-web(body) = if is-native-html or fig-scale == 1 {
  body
} else {
  layout(size => {
    // inside, use the PDF text size, so the text isn't enlarged twice
    let inner = { set text(size: pdf-text-size); body }
    let w = measure(inner).width
    // never scale beyond the available width
    let s = if w > 0pt { calc.min(fig-scale, size.width / w) } else { fig-scale }
    scale(s * 100%, reflow: true, inner)
  })
}