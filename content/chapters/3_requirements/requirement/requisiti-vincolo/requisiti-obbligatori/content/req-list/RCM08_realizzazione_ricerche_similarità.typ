#import "../deps/utils.typ" as utils:get-req-code


#import "../deps/utils.typ" as utils

#let req-name="Realizzazione ricerche similarità"
#let data =(
  codice:[
    #utils.get-req-code( req-name)
    #label(utils.get-req-code(req-name))
    ],

  descrizione:[
    #set list(marker:sym.bullet)
      Il sistema principale deve implementare i seguenti tipi di ricerche di similarità sulle singole entità:
      - Semantica
      - Full-text
      - Ibrida
  ],
  // Per facilitare l'automazione, gli use case associati vanno riferiti solo per nome
  // La conversione in codice con label sarà effettuata in una fase successiva
  fonti:[Piano di lavoro]
)