#import "../deps/utils.typ" as utils:get-req-code


#import "../deps/utils.typ" as utils

#let req-name="Visualizza dashboard performance"
#let data =(
  codice:[
    #utils.get-req-code( req-name)
    #label(utils.get-req-code(req-name))
    ],

  descrizione:[
    Il supervisore deve poter visualizzare la dashboard riepilogativa delle performance del sistema
  ],
  // Per facilitare l'automazione, gli use case associati vanno riferiti solo per nome
  // La conversione in codice con label sarà effettuata in una fase successiva
  fonti:(
    req-name,
  )
)