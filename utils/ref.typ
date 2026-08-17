// Cross-chapter reference. In PDF mode this is a plain label link (all
// chapters are compiled together, so labels resolve globally). In web/Shiroa
// mode each chapter is compiled standalone, so we link to the other chapter's
// page via Shiroa's `cross-link`.
#import "render.typ": is-pdf, is-web

#let crossref(label, path, body) = {
  if is-pdf {
    link(label, body)
  } else {
    import "@preview/shiroa:0.4.0": cross-link
    cross-link(path, reference: label, body)
  }
}
