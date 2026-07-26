#import "/plugin/packages.typ": flecther-lib as fl


#import fl: diagram
#import "utils/uc-layout-engine.typ": compute-uc-layout
#import "utils/components-builder.typ" as builder
#import "utils/layout-fit.typ": fit-to-width

// Diagramma "standard" dei casi d'uso: caso d'uso centrale racchiuso nel
// confine di sistema, insieme alle sue generalizzazioni/include/extend.
#let draw-uc-diagram(
  system-name: "Sistema - Frontend", // Nome nell'angolo del recinto
  target-uc: "",
  actors: ("Utente",),        // Attori primari, a sinistra
  ext-actors: (),              // Attori esterni/secondari, sul lato opposto
  includes: (),
  extends: (:),
  generalizations: (),
  spacing: (2.5cm, 2cm),
  width: 100%,                 // Come width per le immagini: si adatta al contenitore
  max-height: none,            // Limite opzionale, utile per non sforare la pagina
  actor-offset: 5,
  ext-actor-offset: 5,
  note-offset: (2, 0.6),
) = {

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

  if enclosed.len() > 0 {
    elements += builder.build-std-box(enclosed-lbl: enclosed, system-name: system-name)
  }

  fit-to-width(width: width, max-height: max-height)[
    #align(center)[
      #diagram(spacing: spacing, ..elements)
    ]
  ]
}
