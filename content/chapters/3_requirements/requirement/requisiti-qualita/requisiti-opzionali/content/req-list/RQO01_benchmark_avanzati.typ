#import "../deps/utils.typ" as utils:get-req-code


#import "../deps/utils.typ" as utils

#let req-name="Benchmark avanzati"
#let data =(
  codice:[
    #utils.get-req-code( req-name)
    #label(utils.get-req-code(req-name))
    ],

  descrizione:[
    Vanno verificati i benchmark previsti sul seguente volume di dati di 1.000.000 ticket, 5.000.000 conversation item e 6.000.000 attachemnt

  ],
  // Per facilitare l'automazione, gli use case associati vanno riferiti solo per nome
  // La conversione in codice con label sarà effettuata in una fase successiva
  fonti:[Colloquio con il tutor]
)
