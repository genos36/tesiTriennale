#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Errore termine ingestion"
// #let depth=

#use-case(
        codice: get-use-case-code(use-case-nome),
        nome: use-case-nome,
        attore-principale:[Companion],
        attore-secondario: none,
        pre-condizioni:[
                - Nel sistema è attiva una sessione di ingestion
                - Nel sistema i dati inseriti sono stati resi disponibili per la ricerca

        ],
        post-condizioni: [
                - Nel sistema rimane attiva la sessione di ingestion
                - Companion viene notificato dell'errore
                        ],
        scenario-principale:[
                + Companion chiede il termine della sessione di ingestion
                + Il sistema rileva che è ancora in corso l'elaborazione dei dati
                + Companion riceve una notifica esplicativa dell'errore
        ],
        scenari-alternativi:none,
        trigger: none,
        inclusioni: none,
        estensioni: none,
        specializzazioni: none,
        immagine: none,
        caption: none,
)
