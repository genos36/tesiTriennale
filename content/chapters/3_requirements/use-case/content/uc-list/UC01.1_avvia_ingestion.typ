#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Avvia ingestion"
// #let depth=

#use-case(
        codice: get-use-case-code(use-case-nome),
        nome: use-case-nome,
        attore-principale:[Companion],
        attore-secondario: none,
        pre-condizioni:[
                - Il sistema è attivo
                - Nel sistema non ci sono sessioni di ingestion di documenti attive
        ],
        post-condizioni: [
                - Nel sistema è attiva una sessione di ingestion di documenti
                        ],
        scenario-principale:[
                + Companion chiede di avviare una sessione di ingestion
                + Il sistema avvia la sessione di ingestion
                + Companion viene notificato della corretta apertura del sistema
        ],
        scenari-alternativi:none,
        trigger: none,
        inclusioni: none,
        estensioni: none,
        specializzazioni: none,
        immagine: none,
        caption: none,
)
