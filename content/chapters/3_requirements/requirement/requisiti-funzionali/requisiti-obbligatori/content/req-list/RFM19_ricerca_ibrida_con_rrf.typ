#import "../deps/utils.typ" as utils:get-req-code


#import "../deps/utils.typ" as utils

#let req-name="Ricerca ibrida con rrf"
#let data =(
  codice:[
    #utils.get-req-code( req-name)
    #label(utils.get-req-code(req-name))
    ],

  descrizione:[
    Companion deve poter effettuare ricerche ibride, basate sia su ricerca full-text sia su ricerca semantica,
    su una singola entità. 
    
    Per la combinazione dei risultati viene usato rrf
  ],
  // Per facilitare l'automazione, gli use case associati vanno riferiti solo per nome
  // La conversione in codice con label sarà effettuata in una fase successiva
  fonti:(
    "Ricerca ibrida con rrf",
  )
)