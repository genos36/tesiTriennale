#import "/metadata/mod.typ": data
// Colore per i link esterni (stile Wikipedia, blu con buon contrasto su sfondo bianco)
#let external-blue = rgb("#0645AD")

// --- Funzioni di stile, riferibili anche nelle convenzioni ---

#let apply-style-internal-ref(body) = {
  underline(text(weight: "semibold", body))
}

#let apply-style-external-link(body) = {
  underline(text(fill: external-blue, body))
}

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

  show link: it => {
    if type(it.dest) == str {
      apply-style-external-link(it)
    } else if type(it.dest) == label and str(it.dest).starts-with("gls:") {
      it // lascia stare lo stile del glossario
    } else {
      apply-style-internal-ref(it)
    }
  }


  // --- Link: interni (#link(<label>)) vs esterni (URL) ---
  let internal-ref-kinds = (image, table, raw)
  show ref: it => {
    if it.element != none and (
      it.element.func() == heading
      or (it.element.func() == figure and it.element.kind in internal-ref-kinds)
    ) {
      apply-style-internal-ref(it)
    } else {
      it
    }
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


  show table.cell: it => block(breakable: false, it)


  // Alias
  // sosituisce il normale trattino con il tratticono non wrap point per gli a capo, all'apparenza sono uguali ma  soo dei caratteri distinti, il trattino è il non-breaking hyphen (U+2011), permette a parole come full-text di essere considerate come una singola parola invece di essere considerate come 2 parole
  let compound-words = (
    "full-text",
    "language-agnostic",
    "language-specific",
    "any-word",
    "all-words",
    "post-join",
  )

  let pattern = compound-words.join("|")

  show regex(pattern): it => it.text.replace("-", "\u{2011}")


  body
}
