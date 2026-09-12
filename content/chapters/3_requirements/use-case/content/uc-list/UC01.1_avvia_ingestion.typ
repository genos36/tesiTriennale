#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Avvia ingestion"
// #let depth=

#use-case(
        alt-diagramma:"Questo diagramma dei casi d'uso rappresenta l'avvio di una sessione di ingestion.",
        codice: get-use-case-code(use-case-nome),
        nome: use-case-nome,
        attore-principale:[Companion],
        attore-secondario: none,
        pre-condizioni:[
                - Il sistema di ricerca è attivo
                - Nel sistema di ricerca non ci sono sessioni di ingestion di documenti attive
        ],
        post-condizioni: [
                - Nel sistema di ricerca è attiva una sessione di ingestion di documenti
                        ],
        scenario-principale:[
                + Companion chiede di avviare una sessione di ingestion
                + Il sistema di ricerca avvia la sessione di ingestion
                + Companion viene notificato della corretta apertura della sessione di ingestion
        ],
        scenari-alternativi:none,
        trigger: none,
        inclusioni: none,
        estensioni: none,
        specializzazioni: none,
        immagine: none,
        caption: none,
)
