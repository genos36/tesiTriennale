#import "/plugin/packages.typ": codly-lib.codly, codly-lib.codly-init
#import "//plugin/packages.typ": codly-langs-lib.codly-languages
#import "/metadata/mod.typ": data


#let code-init(body) = {
  // Inizializza il motore di Codly
  show: codly-init.with()

  // Configura l'aspetto (colori, lingue supportate)
  codly(
    languages: codly-languages,
    zebra-fill: gray.lighten(90%),
  )

  // Associa il font specifico per il codice sorgente
  show raw: set text(font: "DejaVu Sans Mono", size: 10pt)

  body
}
