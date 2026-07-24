#import "/template/mod.typ":slugify

#let use-case(
  livello-intestazione: 3,
  codice: none,
  nome: none,
  attore-principale: none,
  attore-secondario: none,
  pre-condizioni: none,
  post-condizioni: none,
  scenario-principale: none,
  scenari-alternativi: none,
  trigger: none,
  inclusioni: none,
  estensioni: none,
  specializzazioni: none,
  immagine: none,
  caption: none,
  padding-interno:cont=>{
          pad(left: 1em, top: 0em)[#cont]
  }
) = {

  // 1. Intestazione
  // heading(level: livello-intestazione)[#codice: #nome]
block(breakable: false)[  
  #{v(1em)+strong[#codice: #nome #label(slugify(nome))]
  // 2. Gestione Immagine
  if immagine != none {
    // In Typst le variabili sono immutabili, usiamo una variabile di appoggio per la caption
    let local-caption = caption
    if local-caption == none {
      // Sostituisci con la tua funzione se definita altrove, o lascia un default
      // local-caption = use-case-link-extended-label(nome-etichetta: nome)
      local-caption = [Diagramma del caso d'uso: #nome]
    }

    figure(
      caption: local-caption,
      kind: image
    )[
      #if type(immagine) == str {
        image(immagine)
      } else {
        immagine
      }
    ]
  }}
]
  // 3. Costruzione degli elementi opzionali
  let elementi-lista-opzionali = (

          [*Attore principale*: #attore-principale],
    if attore-secondario != none {
      [
        *Attore secondario*: #attore-secondario
      ]
    } else { none },
          [*Precondizioni*:\ #padding-interno(pre-condizioni) ],
          [*Postcondizioni*:\ #padding-interno(post-condizioni )],



    if scenario-principale != none {
      [
          #set enum(full: true)
        *Scenario principale*: \
        #padding-interno(scenario-principale)

      ]
    } else { none },

    if scenari-alternativi != none {
      [
        *Scenari alternativi*: \
        #padding-interno(scenari-alternativi)
      ]
    } else { none },

    if inclusioni != none {
      [
        *Inclusioni*: \
        #padding-interno(inclusioni)
        // #pad(left: 1em, top: -0.5em)[ #inclusioni ]
      ]
    } else { none },

    if estensioni != none {
      [
        *Estensioni*: \
        #padding-interno(estensioni)
      ]
    } else { none },

    if specializzazioni != none {
      [
        *Specializzazioni*: \
        #padding-interno(specializzazioni)
      ]
    } else { none },

    if trigger != none {
      [
        *Trigger*:#trigger
      ]
    } else { none },
  ).filter(item => item != none).map(it=>block(breakable: false,it))

  // 4. Rendering della lista finale
  list(

    ..elementi-lista-opzionali
  )
}
