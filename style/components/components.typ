#import "/metadata/mod.typ": data

#let apply-components(body) = {
  // --- Liste ---
  set list(marker: (sym.bullet,sym.bullet.tri ,sym.dash))
  show raw: set text(size: 0.85em)
  // --- Tabelle ---
  set table(
    inset: 10pt,
    fill: (x, y) => if calc.even(y) { gray.lighten(70%) } else { white },
  )
  // --- Figure ---
  // Non usare figure generale in questa circostanza,usando glossarium per il glossario si va a causare la creazione di spazi enormi tra i termini, glossarium usa delle figure per permettere le reference cliccabili
  show figure.where(kind: image): it => {
    v(1em)
    it
    v(1em)
  }
  show figure.where(kind: table): it => {
    v(1em)
    it
    v(1em)
  }
  show figure.where(kind: raw): it => {
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
  set heading(numbering: "1.1", )
  show heading.where(level: 1): set heading(supplement: data.chapter)
  
  show heading.where(level: 1): it => {
    pagebreak(to: "odd", weak: true)
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
