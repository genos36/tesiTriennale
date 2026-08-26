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
    Il sistema principale deve deve implementare per ogni tipo di ricerca di similarità su singola entità anche la rispettiva versione linked.

    Le sequenze di linking sono le seguenti
    - Conversation item #sym.arrow Ticket
    - Attachment #sym.arrow Ticket
    - Attachment #sym.arrow Conversation item #sym.arrow Ticket
  ],
  // Per facilitare l'automazione, gli use case associati vanno riferiti solo per nome
  // La conversione in codice con label sarà effettuata in una fase successiva
  fonti:[Colloquio con i tutor]
)