#import "components-builder.typ" as builder
#import "/template/mod.typ":slugify

// ==========================================
// MOTORE DI LAYOUT CONDIVISO
// ==========================================
// Calcola le coordinate e costruisce tutti i nodi/archi di un diagramma
// dei casi d'uso (attori, generalizzazioni, include, extend + note).
//
// Non disegna il "recinto" del sistema: quello resta a carico del
// chiamante (draw-uc-diagram.typ userà build-std-box, draw-uc-expansion.typ
// userà build-exp-box), perché è l'unica parte che davvero differisce
// tra le due varianti di diagramma.
//
// Ritorna un dizionario:
//   elements    -> array di nodi/archi fletcher da spargere in diagram()
//   enclosed    -> array di label da racchiudere nel recinto del sistema
//   target-lbl  -> label del caso d'uso centrale
//   target-x/y  -> coordinate del caso d'uso centrale
//   y-gen       -> riga delle generalizzazioni (utile per padding esterni)
#let compute-uc-layout(
  target-uc: "",
  actors: (),
  ext-actors: (),
  includes: (),
  extends: (:),
  generalizations: (),
  actor-offset: 5,
  ext-actor-offset: 5,
  note-offset: (2, 0.6),
) = {

  let num-gen = generalizations.len()
  let num-inc = includes.len()
  let num-act = actors.len()
  let num-ext-act = ext-actors.len()

  let ext-list = if type(extends) == dictionary { extends.pairs() } else { extends.map(e => (e, none)) }
  let num-ext = ext-list.len()

  // ---- Griglia delle coordinate ----
  let spread-gen = if num-gen > 0 { (num-gen - 1) / 2.0 } else { 0.0 }
  let spread-ext = if num-ext > 0 { (num-ext - 1) / 2.0 } else { 0.0 }
  let max-spread = calc.max(spread-gen, spread-ext)

  let target-x = 1.0 + max-spread
  let target-y = if num-gen > 0 { 1.0 } else { 0.0 }

  let y-gen = target-y - 1.0
  let y-ext = target-y + 1.0
  let x-inc = target-x + max-spread + 1.0
  let x-act = 0.0

  // Colonna degli attori esterni: sul lato opposto rispetto agli attori
  // primari, oltre la colonna degli include.
  let x-act-ext = x-inc + ext-actor-offset

  let start-x-gen = target-x - spread-gen
  let start-x-ext = target-x - spread-ext
  let start-y-inc = target-y - if num-inc > 0 { (num-inc - 1) / 2.0 } else { 0.0 }
  let start-y-act = target-y - if num-act > 0 { (num-act - 1) / 2.0 } else { 0.0 }
  let start-y-act-ext = target-y - if num-ext-act > 0 { (num-ext-act - 1) / 2.0 } else { 0.0 }

  // ---- Assemblaggio ----
  let elements = ()
  let enclosed = ()

  let target-lbl = label("uc-" + slugify(target-uc))
  enclosed.push(target-lbl)
  elements.push(builder.build-use-case(uc-name: target-uc, uc-position: (target-x, target-y)))

  // -- Attori primari (sinistra) --
  for (i, actor) in actors.enumerate() {
    let actor-lbl = label("actor-" + slugify(actor))
    elements.push(builder.build-actor(actor-name: actor, actor-position: (x-act - actor-offset, start-y-act + i)))
    elements.push(builder.build-assoc-arrow(actor-lbl, target-lbl))
  }

  // -- Attori esterni/secondari (lato opposto agli attori primari) --
  for (i, actor) in ext-actors.enumerate() {
    let actor-lbl = label("actor-" + slugify(actor))
    elements.push(builder.build-actor(actor-name: actor, actor-position: (x-act-ext, start-y-act-ext + i)))
    elements.push(builder.build-assoc-arrow(actor-lbl, target-lbl))
  }

  // -- Generalizzazioni (alto) --
  for (i, gen) in generalizations.enumerate() {
    let gen-lbl = label("uc-" + slugify(gen))
    elements.push(builder.build-use-case(uc-name: gen, uc-position: (start-x-gen + i, y-gen)))
    elements.push(builder.build-generalize-arrow(gen-lbl, target-lbl))
    enclosed.push(gen-lbl)
  }

  // -- Include (destra) --
  for (i, inc) in includes.enumerate() {
    let inc-lbl = label("uc-" + slugify(inc))
    elements.push(builder.build-use-case(uc-name: inc, uc-position: (x-inc, start-y-inc + i)))
    elements.push(builder.build-include-arrow(target-lbl, inc-lbl))
    enclosed.push(inc-lbl)
  }

  // -- Extend (basso) + note a ventaglio --
  for (i, (ext-name, ext-cond)) in ext-list.enumerate() {
    let ext-lbl = label("uc-" + slugify(ext-name))
    let x-pos = start-x-ext + i

    elements.push(builder.build-use-case(uc-name: ext-name, uc-position: (x-pos, y-ext)))
    elements.push(builder.build-extend-arrow(ext-lbl, target-lbl))
    enclosed.push(ext-lbl)

    if ext-cond != none and ext-cond != "" {
      let note-lbl = label("note-ext-" + str(i))
      enclosed.push(note-lbl)

      // Ventaglio orizzontale: spinge le note a sx/dx per evitare collisioni.
      // Verticalmente le note salgono sempre verso la riga del target
      // (comportamento identico nelle due versioni precedenti, qui reso esplicito).
      let is-left = x-pos < target-x
      let note-x = x-pos + if is-left { -note-offset.at(0) } else { note-offset.at(0) }
      let note-y = y-ext - note-offset.at(1)

      elements.push(builder.build-note(description: ext-cond, note-position: (note-x, note-y), note-lbl: note-lbl))
      elements.push(builder.build-note-arrow(note-lbl, ext-lbl, target-lbl))
    }
  }

  (
    elements: elements,
    enclosed: enclosed,
    target-lbl: target-lbl,
    target-x: target-x,
    target-y: target-y,
    y-gen: y-gen,
  )
}
