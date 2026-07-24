#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Ingestion di documenti"
// #let depth=

#use-case(
        codice: get-use-case-code(use-case-nome),
        nome: use-case-nome,
        attore-principale:[Companion],
        attore-secondario: none,
        pre-condizioni:[
                - Il sistema è attivo
        ],
        post-condizioni: [
                - Le informazioni da salvare sono state salvate nel sistema con i relativi embedding e la relativa informazione di lingua
                - Informazioni duplicate sono state aggiornate
                - Companion viene notificato del corretto salvataggio dei dati.
                        ],
        scenario-principale:[
                + Companion carica la lista di ticket
                + Companion carica la lista di conversation item
                + Companion carica la lista di attachment

        ],
        scenari-alternativi:[
                - Fallimento dell'ingestion
        ],
        trigger: [Companion vuole caricare dei documenti sul sistema],
        inclusioni: [
                - #utils.uc-link("ingestione lista ticket")
                - #utils.uc-link("ingestione lista conversation item")
                - #utils.uc-link("ingestione lista attachments")
        ],
        estensioni: 
        [
                - #utils.uc-link("Fallimento ingestion")
        ]
        ,
        specializzazioni: none,
        immagine: none,
        caption: none,
)
