// Target-aware wrapper around CeTZ. CeTZ canvas renders fine on PDF and on
// dynamic web (the browser WASM renderer), but not on Typst's native HTML
// export (`static-html`), where `layout` is ignored — so there we render a
// placeholder instead.
#import "@preview/cetz:0.4.2" as cetz
#import "render.typ": is-native-html

#let canvas(..args) = {
  if is-native-html {
    block(
      width: 100%,
      inset: (x: 1em, y: 0.8em),
      fill: luma(96%),
      stroke: 0.5pt + luma(82%),
      radius: 0.3em,
      align(center)[
        #text(style: "italic", fill: luma(55%))[*Figura*]
      ],
    )
  } else {
    cetz.canvas(..args)
  }
}
