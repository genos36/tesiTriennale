#import "../deps/utils.typ" as utils:get-req-code


#import "../deps/utils.typ" as utils

#let req-name="Ricerca full text ottimizzata su lingua"
#let data =(
  codice:[
    #utils.get-req-code( req-name)
    #label(utils.get-req-code(req-name))
    ],

  descrizione:[
    Il sistema deve rispettare il seguente comportamento per le ricerche full-text.

    Se la query di ricerca contiene l'informazione di lingua il sistema limita il pool di candidati solo ai chunk della medesima lingua e utilizza solo la configurazione linguistica assegnata a tale lingua.

    Altrimenti tutti i chunk vengono valutati sia usando una configurazione di testo agnostica rispetto alla lingua sia usando la configurazione di testo per la lingua assegnata
  ],
  // Per facilitare l'automazione, gli use case associati vanno riferiti solo per nome
  // La conversione in codice con label sarà effettuata in una fase successiva
  fonti:[Colloquio con il tutor]
)