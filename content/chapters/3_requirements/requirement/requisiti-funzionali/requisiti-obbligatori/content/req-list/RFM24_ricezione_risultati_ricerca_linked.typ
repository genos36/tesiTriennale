#import "../deps/utils.typ" as utils:get-req-code


#import "../deps/utils.typ" as utils

#let req-name="Ricezione risultati ricerca linked"
#let data =(
  codice:[
    #utils.get-req-code( req-name)
    #label(utils.get-req-code(req-name))
    ],

  descrizione:[
    Companion deve ricevere i risultati della ricerca linked.
          #set list(marker: sym.bullet)

    I risultati devono contenere le seguenti informazioni:
    - i valori dei campi richiesti tramite la query, 
    - il nome dell'entità e il nome del campo di testo su cui è stato trovato il match,
    - il testo su cui è stata rilevata la corrispondenza, 
    - il numero del chunk (si veda i requisiti di vincolo),
    - il punteggio di similarità.

  ],
  // Per facilitare l'automazione, gli use case associati vanno riferiti solo per nome
  // La conversione in codice con label sarà effettuata in una fase successiva
  fonti:(
    "Ricezione risultati ricerca linked",
  )
)