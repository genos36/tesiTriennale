#let risc-table(
  code: str,
  name: str,
  description: content,
  mitigation: content,
  probability: str,
  consequences: content,
  columns: (0.28fr, 0.72fr),
  fill: (_, row) => if row == 0 { luma(230) } else { white },
  header: ([*Campo*], [*Descrizione*]),
) = {
  table(
    columns: columns,
    fill: fill,
    table.header(..header),
    "Codice", code,
    "Nome", name,
    "Descrizione", description,
    "Mitigazione", mitigation,
    "Probabilità", probability,
    "Impatto", consequences
  )
}
