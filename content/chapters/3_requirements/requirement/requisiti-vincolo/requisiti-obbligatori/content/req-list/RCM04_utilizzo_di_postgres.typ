#import "../deps/utils.typ" as utils:get-req-code


#import "../deps/utils.typ" as utils

#let req-name="Utilizzo di Postgres"
#let data =(
  codice:[
    #utils.get-req-code( req-name)
    #label(utils.get-req-code(req-name))
    ],

  descrizione:[
    Il sistema principale deve utilizzare un database relazionale Postgres.

    La ricerca semantica va realizzata sfruttando l'estensione pgvector.

    // La ricerca full-text va realizzata sfruttando le funzioni native di Postgres
  ],
  // Per facilitare l'automazione, gli use case associati vanno riferiti solo per nome
  // La conversione in codice con label sarà effettuata in una fase successiva
  fonti:[
    Piano di lavoro
  ]
)