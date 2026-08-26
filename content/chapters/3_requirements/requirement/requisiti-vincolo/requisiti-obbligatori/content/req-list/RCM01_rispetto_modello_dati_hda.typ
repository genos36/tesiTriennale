#import "../deps/utils.typ" as utils:get-req-code


#import "../deps/utils.typ" as utils

#let req-name="Rispetto modello dati hda"
#let data =(
  codice:[
    #utils.get-req-code( req-name)
    #label(utils.get-req-code(req-name))
    ],

  descrizione:[
        Il sistema deve realizzare \ l'indicizzazione testuale e vettoriale per il modello dati del service desk HDA.
        #set list(marker: sym.bullet)
        Il modello è costituito dalle seguenti entità:
          - ticket
          - conversation item
          - attachment
  ],
  // Per facilitare l'automazione, gli use case associati vanno riferiti solo per nome
  // La conversione in codice con label sarà effettuata in una fase successiva
  fonti:[Piano di lavoro]
)