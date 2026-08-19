#import "render.typ": is-pdf, is-web

#let author-card(name: "", bio: "", email: none, image-path: none) = {
  let avatar-size = if is-web { 110pt } else { 58pt }
  
  let avatar = if image-path != none {
    image(image-path, width: 100%, height: 100%, fit: "cover")
  } else {
    let initials = name.split(" ").map(w => w.slice(0, 1)).join("")
    rect(
      width: 100%,
      height: 100%,
      fill: rgb("e2e8f0"),
      stroke: 0.5pt + rgb("cbd5e1"),
      radius: 100%,
      align(center + horizon, text(fill: rgb("475569"), weight: "bold", size: if is-web { 12pt } else { 11pt })[#initials]),
    )
  }

  let email-block(size: 8.5pt) = if email != none {
    v(0.2em)
    text(size: size, fill: rgb("64748b"), style: "italic")[#email]
  }

  if is-web {
    block(
      width: 100%,
      above: 2.3em,
      below: 0.7em,
      [
        #grid(
          columns: (avatar-size, 1fr),
          gutter: 12pt,
          align: (center + horizon, left + horizon),
          box(
            width: avatar-size,
            height: avatar-size,
            clip: true,
            radius: 100%,
            avatar,
          ),
          [
            #text(weight: "bold", size: 1.05em)[#name] \
            #v(0.15em)
            #text(size: 0.9em, fill: rgb("334155"))[#bio]
            #email-block(size: 0.85em)
          ],
        )
      ],
    )
  } else {
    block(
      width: 100%,
      above: 2em,
      below: 2em,
      [
        #grid(
          columns: (avatar-size, 1fr),
          gutter: 10pt,
          align: (center + horizon, left + horizon),
          box(
            width: avatar-size,
            height: avatar-size,
            clip: true,
            radius: 100%,
            avatar,
          ),
          [
            #text(weight: "bold", size: 10.5pt)[#name] \
            #v(0.1em)
            #text(size: 9pt, fill: rgb("334155"))[#bio]
            #email-block(size: 8.5pt)
          ],
        )
      ],
    )
  }
}
