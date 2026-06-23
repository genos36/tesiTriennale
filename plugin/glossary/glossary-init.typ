#import "/plugin/packages.typ": glossarium-lib
#import "glossary-style.typ"


#let glossary-init(terms: (), body) = {
  // Inizializza il motore
  show: glossarium-lib.make-glossary

  // Registra i termini passati in input
  glossarium-lib.register-glossary(terms)

  body
}
