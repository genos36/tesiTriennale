#import "../deps/utils.typ" as utils:get-req-code


#import "../deps/utils.typ" as utils

#let req-name="Visualizzazione retrieval answer rate"
#let data =(
  codice:[
    #utils.get-req-code( req-name)
    #label(utils.get-req-code(req-name))
    ],

  descrizione:[
    Il supervisore deve poter visualizzare quanto spesso il risultato atteso è presente tra i risultati reali della ricerca, indipendente dalla posizione. 
  ],
  // Per facilitare l'automazione, gli use case associati vanno riferiti solo per nome
  // La conversione in codice con label sarà effettuata in una fase successiva
  fonti:(
    req-name,
  )
)