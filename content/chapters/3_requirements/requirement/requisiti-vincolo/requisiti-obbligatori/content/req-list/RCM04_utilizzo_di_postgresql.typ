#import "../deps/utils.typ" as utils:get-req-code


#import "../deps/utils.typ" as utils

#let req-name="Utilizzo di postgresql"
#let data =(
  codice:[
    #utils.get-req-code( req-name)
    #label(utils.get-req-code(req-name))
    ],

  descrizione:[
    Il sistema principale deve utilizzare un database relazionale postgres.

    La ricerca semantica va realizzata sfruttando l'estensione pgvector.

    La ricerca full-text va realizzata sfruttando le funzioni native di postgres
  ],
  // Per facilitare l'automazione, gli use case associati vanno riferiti solo per nome
  // La conversione in codice con label sarà effettuata in una fase successiva
  fonti:[
    Piano di lavoro
  ]
)