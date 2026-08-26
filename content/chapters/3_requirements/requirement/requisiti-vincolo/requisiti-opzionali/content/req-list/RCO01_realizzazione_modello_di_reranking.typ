#import "../deps/utils.typ" as utils:get-req-code


#import "../deps/utils.typ" as utils

#let req-name="Realizzazione modello di reranking"
#let data =(
  codice:[
    #utils.get-req-code( req-name)
    #label(utils.get-req-code(req-name))
    ],

  descrizione:[
    Il sistema deve supportare la ricerca ibrida con utilizzo di un modello di re-ranking per la fusione dei risultati.
  ],
  // Per facilitare l'automazione, gli use case associati vanno riferiti solo per nome
  // La conversione in codice con label sarà effettuata in una fase successiva
  fonti:[Piano di lavoro]
)