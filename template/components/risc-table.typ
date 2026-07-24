#let risc-table(
  code: str,
  name: str,
  description: content,
  mitigation: content,
  probability: str,
  consequences: content,
  columns: (0.28fr, 0.72fr),
  fill: (_, row) => if row == 0 { luma(99%) } else { white },
  header: ([*Campo*], [*Descrizione*]),
  r-label:none,
) = {
   box(fill:color.rgb("E8F3FF"),inset:1em,radius:3%, stroke:1pt, width:100%)[

  #align(left)[
    #strong("Codice : "+code)

    #if r-label!=none{
            label(r-label)
    }

    #strong()[#name]

  #box(inset:1em)[

  - #strong("Descrizione"):\ #description
  - #strong("Mitigazione"):\ #mitigation
  - #strong("Probabilità"): #probability
  - #strong("Impatto"): #consequences




  ]
  ]
    ]
  // table(
  //   columns: columns,
  //   fill: fill,
  //   table.header(..header),
  //   "Codice", code,
  //   "Nome", name,
  //   "Descrizione", description,
  //   "Mitigazione", mitigation,
  //   "Probabilità", probability,
  //   "Impatto", consequences
  // )
}
