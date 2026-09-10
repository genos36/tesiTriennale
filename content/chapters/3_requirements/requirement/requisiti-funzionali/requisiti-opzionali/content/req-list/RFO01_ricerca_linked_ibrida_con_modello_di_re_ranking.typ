#import "../deps/utils.typ" as utils:get-req-code


#import "../deps/utils.typ" as utils

#let req-name="Ricerca linked ibrida con modello di reranking"
#let data =(
  codice:[
    #utils.get-req-code( req-name)
    #label(utils.get-req-code(req-name))
    ],

  descrizione:[
    Companion deve poter effettuare ricerche ibride in modalità linked combinando i risultati tramite un modello di reranking
  ],
  // Per facilitare l'automazione, gli use case associati vanno riferiti solo per nome
  // La conversione in codice con label sarà effettuata in una fase successiva
  fonti:(
    "Ricerca linked ibrida con modello di reranking",
  )
)
