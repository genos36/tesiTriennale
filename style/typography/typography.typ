#import "/metadata/mod.typ": data

#let apply-typography(body) = {
  // Impostazioni di pagina di base
  set page(
    margin: 1.75in,
    paper: "a4",
    number-align: center,
  )

  // Font e lingua (letti automaticamente dal metadata!)
  set text(
    font: "New Computer Modern",
    lang: data.myLang,
  )

  // Paragrafi e interlinea stile LaTeX
  set par(
    leading: 0.55em,
    spacing: 0.55em,
    justify: true,
  )

  // show raw: set text(size: 0.85em) // Prova con 0.85em o 0.9em

  body
}
