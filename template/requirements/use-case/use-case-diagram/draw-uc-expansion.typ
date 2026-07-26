#import "@preview/fletcher:0.5.8": diagram, node
#import "utils/uc-layout-engine.typ": compute-uc-layout
#import "utils/components-builder.typ" as builder
#import "utils/layout-fit.typ": fit-to-width

// Diagramma "di espansione": stesso motore di layout di draw-uc-diagram,
// ma il recinto è la scatola con linguetta (build-exp-box) usata per
// espandere un singolo caso d'uso già presente in un diagramma padre.
#let draw-uc-expansion(
  system-name:str,
  parent-uc: none,             // Nome mostrato sulla linguetta; default = target-uc
  target-uc: "",
  actors: ("Utente",),
  ext-actors: (),
  includes: (),
  extends: (:),
  generalizations: (),
  spacing: (0.5cm, 3cm),
  width: 100%,
  max-height: none,
  actor-offset: 6,
  ext-actor-offset: 6,
  note-offset: (1, 0.6),
  tab-offset: (-25pt, -25pt),
  top-padding: 0.1,             // Spazio fantasma sopra, per non far toccare la linguetta
) = {
  let resolved-parent-uc = if parent-uc == none { target-uc } else { parent-uc }

  let layout-data = compute-uc-layout(
    target-uc: target-uc,
    actors: actors,
    ext-actors: ext-actors,
    includes: includes,
    extends: extends,
    generalizations: generalizations,
    actor-offset: actor-offset,
    ext-actor-offset: ext-actor-offset,
    note-offset: note-offset,
  )

  let elements = layout-data.elements
  let enclosed = layout-data.enclosed

  if top-padding > 0 {
    let ghost-lbl = <ghost-top>
    elements.push(node(
      (layout-data.target-x, layout-data.y-gen - top-padding),
      "",
      name: ghost-lbl,
      stroke: none,
      fill: none,
    ))
    enclosed.push(ghost-lbl)
  }

  if enclosed.len() > 0 {
    elements += builder.build-exp-box(
      system-name: system-name,
      enclosed-lbl: enclosed,
      parent-uc-name: resolved-parent-uc,
      tab-offset: tab-offset,
    )
  }

  fit-to-width(width: width, max-height: max-height)[
    #align(center)[
      #diagram(spacing: spacing, ..elements)
    ]
  ]
}
