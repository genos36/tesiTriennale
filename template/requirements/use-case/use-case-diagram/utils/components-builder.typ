#import "/plugin/packages.typ": flecther-lib as fl

#import fl: node, edge,diagram
#import "/plugin/uc-diagram/style-theme.typ" as st
#import "/template/mod.typ":slugify
#import "/content/chapters/3_requirements/use-case/content/deps/utils/code-set-up.typ":uc-link-extended as extended-link-label
// ==========================================
// COMPONENTI: ATTORI
// ==========================================

#let build-actor(actor-name: str, actor-position: ()) = {
  // Usiamo slugify!
  let lbl = label("actor-" + slugify(actor-name))
  node(
    actor-position,
    align(center)[
      #image("/images/actor.svg", height: 6em) \
      #strong(text(actor-name, size: 1.4em))
    ],
    name: lbl,
    ..st.style-actor
  )
}

#let build-actors(actors: (:)) = {
  let items = ()
  for (name, pos) in actors.pairs() {
    items.push(build-actor(actor-name: name, actor-position: pos))
  }
  return items
}
// ==========================================
// COMPONENTI: CASI D'USO
// ==========================================

#let build-use-case(uc-name: str, uc-position: ()) = {
  // Usiamo slugify!
  let lbl = label("uc-" + slugify(uc-name))
  node(
    uc-position,
    align(center)[#text(size:1.15em,extended-link-label(uc-name,separator:linebreak()))],
    name: lbl,
    ..st.style-uc
  )
}

#let build-use-cases(use-cases: (:)) = {
  let items = ()
  for (name, pos) in use-cases.pairs() {
    items.push(build-use-case(uc-name: name, uc-position: pos))
  }
  return items
}

// ==========================================
// COMPONENTI: FRECCE E RELAZIONI
// ==========================================

// Associazione semplice (Attore -> Target)
#let build-assoc-arrow(from-lbl, to-lbl) = {
  edge(from-lbl, to-lbl, st.mark-assoc)
}

#let build-include-arrow(from-lbl, to-lbl) = {
  edge(from-lbl, to-lbl, ..st.style-edge-include)
}

#let build-extend-arrow(from-lbl, to-lbl) = {
  edge(from-lbl, to-lbl, ..st.style-edge-extend)
}

#let build-generalize-arrow(child-lbl, father-lbl) = {
  // In UML la freccia va dal caso d'uso specifico (figlio) a quello generale (padre)
  edge(child-lbl, father-lbl, ..st.style-edge-generalize)
}

// ==========================================
// COMPONENTI: NOTE UML E CONDIZIONI
// ==========================================

#let build-note(description: str, note-position: (), note-lbl: label) = {
  node(
    note-position,
    align(left)[
      #text(size: 1em, weight: "bold")[Condition:] \
      #text(size: 1em)[{ #description }]
    ],
    name: note-lbl,
    ..st.style-note
  )
}

// Collega la nota esattamente a metà della freccia tra start-lbl ed end-lbl
#let build-note-arrow(note-lbl, target-start-lbl, target-end-lbl) = {
  edge(
    note-lbl,
    (target-start-lbl, 50%, target-end-lbl),
    stroke: (paint: gray.darken(30%), dash: "dashed", thickness: 0.8pt),
    marks: (none, none)
  )
}

// ==========================================
// COMPONENTI: RECINTI E BOX
// ==========================================

#let build-std-box(enclosed-lbl: (), system-name: str) = {
  (
    // 1. Il background e il bordo del recinto
    node(
      enclose: enclosed-lbl,
      name: <system-box>,
      ..st.style-box-bg
    ),
    // 2. Il nodo "fantasma" per piazzare l'etichetta del sistema
    // Usiamo il trick dell'allineamento a destra che avevamo validato
    node(
      enclose: enclosed-lbl,
      stroke: none,
      inset: 20pt,
      align(top + right)[
        #place(dx: 20pt, dy: -35pt)[#strong(text(system-name, size: 1.5em))]
      ]
    )
  )
}

// ==========================================
// COMPONENTI: RECINTI ED ESPANSIONI
// ==========================================

// Disegna SOLO il recinto tratteggiato basato sulle etichette incluse
// #let build-exp-box(enclosed-lbl: ()) = {
//   node(
//     enclose: enclosed-lbl,
//     name: <expansion-box>,
//     ..st.style-box-expansion
//   )
// }

#let build-exp-tab(parent-uc-name: str, tab-position: ()) = {
  // Usiamo slugify!
  let lbl = label("tab-" + slugify(parent-uc-name))
  node(
    tab-position,


  align(center)[
      #strong(extended-link-label(parent-uc-name,separator:linebreak()))#h(0.5em)
    ],
    name: lbl,
    ..st.style-exp-tab
  )
}

#let build-exp-box(
  enclosed-lbl: (),
  parent-uc-name: "",
  tab-offset: (-25pt, -25pt), // <-- NUOVO PARAMETRO (dx, dy)
  system-name:"Sistema-Frontend"
) = {
  (
    // 1. Il recinto tratteggiato
    node(
      enclose: enclosed-lbl,
      name: <expansion-box>,
      ..st.style-box-expansion,
    ),
    // 2. Il Nodo Fantasma per allineare la linguetta custom
    node(
      enclose: enclosed-lbl,
      stroke: none,
      inset: 25pt,
      align(top + right)[
        // Usiamo le coordinate passate dal parametro!
        #place(dx: tab-offset.at(0), dy: tab-offset.at(1))[
          #diagram(
            node(
              (0,0),
              [
                #place(dx: 20pt, dy: -35pt)[
                    #box( width:20em,text(size: 1.85em)[
  #strong(system-name)
  ])
                ]

                #v(0.2em)

              #box(width:15em,align(center)[

                #strong(extended-link-label( parent-uc-name,separator:linebreak()))#h(0.5em)
              ])
              ]
              
              ,
              name: <tab-node>,
              ..st.style-exp-tab
            )
          )
        ]
      ]
    )
  )
}
