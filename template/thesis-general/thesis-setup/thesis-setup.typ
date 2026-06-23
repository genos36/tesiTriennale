// template/setup.typ
#import "/metadata/mod.typ": data
#import "/style/mod.typ": apply-styles
#import "/plugin/mod.typ": code-init

// Aggiungiamo il parametro 'debug' con default a false
#let thesis-setup(
  debug: bool,
  body,
) = {
  set document(title: data.myTitle, author: data.myName)

  // --- 🐛 DEBUG MODE: Previene il crash per le reference rotte ---
  if debug {
    // 1. Gestione delle chiocciole (es. @cap:introduzione)
    show ref: it => context {
      // Controlla se l'elemento a cui punta la reference esiste nel documento
      if query(it.target).len() == 0 {
        text(fill: red, weight: "bold")[TODO: \@#str(it.target)]
      } else {
        it // Se esiste, stampalo normalmente
      }
    }

    // 2. Gestione dei link diretti alle label (es. #link(<cap:introduzione>))
    show link: it => {
      if type(it.dest) == label {
        context {
          if query(it.dest).len() == 0 {
            text(fill: red, weight: "bold")[TODO: link(#str(it.dest))]
          } else {
            it
          }
        }
      } else {
        it // Se è un URL normale (stringa), lascialo stare
      }
    }
  }
  show: apply-styles
  show: code-init
  body
}
