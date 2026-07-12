#let use-case(
  livello-intestazione: ,
  codice: none,
  nome: none,
  attore-principale:none,
  attore-secondario: none,
  pre-condizioni: none,
  post-condizioni: none,
  scenario-principale: none,
  scenari-alternativi: none,
  trigger: none,
  inclusioni: none,
  estensioni: none,
  generalizzazioni: none,
  immagine: none,
  caption: none,
) = {

  // 1. Intestazione
  heading(level: livello-intestazione)[#codice: #nome]
  // (Se hai ancora la tua funzione slugify attiva, puoi aggiungere qui #label(slugify(nome)))


  if immagine != none {
    let final-caption = if caption == none { [#codice - #nome] } else { caption }
    figure(
      caption: final-caption,
      // Se è una stringa assumiamo sia il path, altrimenti è già contenuto Typst
      if type(immagine) == str { image(immagine) } else { immagine }
    )
  }


  let campi = (
    ("Attore principale", attore-principale),
    ("Attore secondario", attore-secondario),
    ("Precondizioni", pre-condizioni),
    ("Postcondizioni", post-condizioni),
    ("Trigger", trigger),
    ("Scenario principale", scenario-principale),
    ("Scenari alternativi", scenari-alternativi),
    ("Inclusioni", inclusioni),
    ("Estensioni", estensioni),
    ("Specializzazioni", generalizzazioni),
  )

  // Filtriamo i vuoti e formattiamo automaticamente quelli pieni!
  let elementi-lista = campi
    .filter(campo => campo.at(1) != none)
    .map(campo => [
      *#campo.at(0)*: \
      #pad(left: 1em, top: -0.5em, campo.at(1))
    ])

  // 4. Renderizziamo la lista
  list(..elementi-lista)
}
