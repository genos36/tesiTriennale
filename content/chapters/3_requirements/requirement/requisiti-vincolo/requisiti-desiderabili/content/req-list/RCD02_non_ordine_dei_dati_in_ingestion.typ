#import "../deps/utils.typ" as utils:get-req-code


#import "../deps/utils.typ" as utils

#let req-name="Non ordine dei dati in ingestion"
#let data =(
  codice:[
    #utils.get-req-code( req-name)
    #label(utils.get-req-code(req-name))
    ],

  descrizione:[
    Il sistema deve supportare flussi di dati paralleli e non ordinati di dati durante l'ingestion.

    Con non ordinati si intende che è possibile caricare prima gli attachment e poi i ticket.
  ],
  // Per facilitare l'automazione, gli use case associati vanno riferiti solo per nome
  // La conversione in codice con label sarà effettuata in una fase successiva
  fonti:[Colloquio con il tutor]
)