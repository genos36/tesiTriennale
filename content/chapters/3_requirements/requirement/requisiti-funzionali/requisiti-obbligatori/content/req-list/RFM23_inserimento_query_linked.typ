#import "../deps/utils.typ" as utils:get-req-code


#import "../deps/utils.typ" as utils

#let req-name="Inserimento query linked"
#let data =(
  codice:[
    #utils.get-req-code( req-name)
    #label(utils.get-req-code(req-name))
    ],

  descrizione:[
          #set list(marker: sym.bullet)
    Companion deve poter inserire una query di ricerca linked.

    La query deve contenere i seguenti dati:
    - elenco dei campi dati da ritornare indicati tramite nome dell'entità e nome del campo dati,
    - elenco dei campi dati su cui eseguire la ricerca semantica indicati tramite nome dell'entità e nome del campo dati,
    - il testo da utilizzare per la ricerca semantica,
    - il numero di risultati voluti,

    La query può contenere i seguenti dati:
    - il filtro da applicare durante la ricerca iniziale, precedente ai join, su ogni entità,
    - il filtro da applicare successivamente ai join,
    - i pesi da applicare ai singoli campi su cui calcolare la similarità,
    - l'informazione di lingua
  ],
  // Per facilitare l'automazione, gli use case associati vanno riferiti solo per nome
  // La conversione in codice con label sarà effettuata in una fase successiva
  fonti:(
    "Inserimento query linked",
  )
)