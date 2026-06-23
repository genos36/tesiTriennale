#import "/metadata/mod.typ": data

// --- INDICE GENERALE ---
#[
  // Aggiungiamo un po' di spazio e il grassetto ai capitoli di livello 1
  #show outline.entry.where(level: 1): it => {
    v(1em, weak: true)
    strong(it)
  }

  // Il titolo "Indice" (o simile) lo puoi passare direttamente dal JSON
  #outline(
    title: data.outline,
    depth: 5,
  )
]

#v(8em)


// --- ELENCO DELLE FIGURE ---
#outline(
  title: data.figuresList,
  target: figure.where(kind: image),
)

#v(8em)

// --- ELENCO DELLE TABELLE ---
#outline(
  title: data.tablesList,
  target: figure.where(kind: table),
)

#v(8em)

// --- ELENCO DEI CODICI SORGENTE ---
#outline(
  title: data.sourceCodeList,
  target: figure.where(kind: raw),
)
#parbreak()
