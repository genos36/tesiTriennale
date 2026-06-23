#import "/metadata/mod.typ": data

#let apply-components(body) = {
  // --- Liste ---
  set list(marker: (sym.bullet, sym.dash))

  // --- Tabelle ---
  set table(
    inset: 10pt,
    fill: (x, y) => if calc.even(y) { gray.lighten(70%) } else { white },
  )

  // --- Figure ---
  // Aggiunge spazio sopra e sotto tutte le figure
  show figure: it => {
    v(1em)
    it
    v(1em)
  }

  // SOLUZIONE BREAKABLE: Rendiamo breakable SOLO le tabelle, non le immagini.
  // Addio blocchi #[ ] o #{ } inseriti a mano!
  show figure.where(kind: table): set block(breakable: true)

  // --- Capitoli e Intestazioni ---
  show heading: set block(above: 2em, below: 1.4em)

  // Impostiamo di default la traduzione di "Capitolo"
  set heading(numbering: "1.1", supplement: data.chapter)

  show heading.where(level: 1): it => {
    pagebreak(to: "odd")
    stack(
      spacing: 2em,
      if it.numbering != none {
        // Nessun if/else magico: stampiamo direttamente il supplement!
        text(size: 1.5em)[#it.supplement #counter(heading).display()]
      },
      text(size: 2em, it.body),
      [],
    )
  }

  body
}
