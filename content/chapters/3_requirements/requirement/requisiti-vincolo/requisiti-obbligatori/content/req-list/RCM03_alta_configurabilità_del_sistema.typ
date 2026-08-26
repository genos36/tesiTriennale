#import "../deps/utils.typ" as utils:get-req-code


#import "../deps/utils.typ" as utils

#let req-name="Alta configurabilità del sistema"
#let data =(
  codice:[
    #utils.get-req-code( req-name)
    #label(utils.get-req-code(req-name))
    ],

  descrizione:[
      Il sistema e il suo modello dati devono essere altamente configurabili.
      #set list(marker: sym.bullet)

      La richiesta di configurabilità è da intendersi nel seguente modo:
      - le entità che compongono il sistema devono essere configurabili esternamente,
      - i campi da utilizzare nella ricerca pe similarità devono essere configurabili esternamente,
      - i campi filtrabili devono essere configurabili esternamente,
      - i pesi da usare nella ricerca devono poter subire override nell'ambito di una singola ricerca
      - i pesi da usare per la fusione di ricerca semantica e ibrida devono poter subire override nell'ambito di una singola ricerca


  ],
  // Per facilitare l'automazione, gli use case associati vanno riferiti solo per nome
  // La conversione in codice con label sarà effettuata in una fase successiva
  fonti:[Colloquio con i tutor]
)