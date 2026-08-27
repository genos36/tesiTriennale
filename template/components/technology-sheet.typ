#let alternative-list-item(nome: none, versione: none, motivo: none, a-label: none) = {
  [
    *#nome*#if versione != none [ v#versione]: #motivo
    #if a-label != none { label(a-label) }
  ]
}

#let technology-sheet(
  nome: none,
  versione: none,
  logo: none,
  caption: none,
  descrizione: none,
  motivazione: none,
  alternative: (),
  t-label: none,
) = {
  block(breakable: false)[
    #v(0.8em)
    #if t-label != none { label(t-label) }
    #strong(nome) v#versione

    #if logo != none [
      #figure(image(logo, width: 25%), caption: caption,alt: none)
    ]

    #list(
      [*Descrizione:* #descrizione],
      [*Motivazione della scelta:* #motivazione],
      ..if alternative.len() > 0 {
        ([*Alternative valutate:*
          #list(..alternative.map(it => alternative-list-item(..it)))
        ],)
      } else { () }
    )
  ]
}