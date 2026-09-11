#import "../deps/utils.typ" as utils:get-req-code


#import "../deps/utils.typ" as utils

#let req-name="Ricerca linked"
#let data =(
  codice:[
    #utils.get-req-code( req-name)
    #label(utils.get-req-code(req-name))
    ],

  descrizione:[
    #set list(marker:sym.bullet)
    Il sistema di ricerca deve implementare per ogni tipo di ricerca di similarità su singola entità anche la rispettiva versione linked.

    Le sequenze di linking sono le seguenti:
    - conversation item #sym.arrow ticket,
    - attachment #sym.arrow ticket,
    - attachment #sym.arrow conversation item #sym.arrow ticket.
  ],
  // Per facilitare l'automazione, gli use case associati vanno riferiti solo per nome
  // La conversione in codice con label sarà effettuata in una fase successiva
  fonti:[Colloquio con il tutor]
)
