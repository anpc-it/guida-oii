// Code-block helper. In PDF mode it forwards to `codly` (whose init/show
// rules are applied by `config.typ`); in web/Shiroa mode code blocks are
// rendered natively by the Shiroa template, so this is a no-op.
#import "render.typ": is-pdf, is-web
#import "@preview/codly:1.3.0": codly, local as codly-local

#let code(..named) = if is-pdf {
  codly(..named)
} else {
  []
}

#let local(..named, body) = if is-pdf {
  codly-local(..named, body)
} else {
  body
}
