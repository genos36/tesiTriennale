#import "../deps/utils.typ" as utils:get-req-code


#import "../deps/utils.typ" as utils

#let req-name="Inserimento query su singola entità"
#let data =(
  codice:[
    #utils.get-req-code( req-name)
    #label(utils.get-req-code(req-name))
    ],

  descrizione:[
    Companion deve poter inserire una query di ricerca valida.

    #[
      #set list(marker: sym.bullet)
      Una query valida è composta dalle seguenti informazioni obbligatorie:
    - nome dell'entità su cui eseguire la ricerca, 
    - l'elenco dei campi da ritornare al termine della ricerca, 
    - l'elenco dei campi su cui effettuare la ricerca per similarità,
    - il testo da usare per la ricerca, 
    - il numero di risultati voluti.
    Una query valida è composta dalle seguenti informazioni opzionali:
    - il filtro,
    - l'elenco dei pesi da applicare ai campi usati nel calcolo della similarità, 
    - l'informazione di lingua opzionale. ]
  ],
  // Per facilitare l'automazione, gli use case associati vanno riferiti solo per nome
  // La conversione in codice con label sarà effettuata in una fase successiva
  fonti:(
    "Inserimento query su singola entità",
  )
)