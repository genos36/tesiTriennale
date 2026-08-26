#let req-table(
  cells,
  columns:(auto,1fr,auto)
)={
set table(
    inset: 10pt,
    fill: (x, y) => if calc.even(y) { gray.lighten(70%) } else { white },
  )

align(
left,

table(
  columns:columns,
  table.header(strong("Codice"),strong("Descrizione"),strong("Fonti"),),
  ..((cells.values().map(
    value=>{
      (value.at("codice"),value.at("descrizione"),value.at("fonti"),)
    }
  )).flatten())
)

)

}