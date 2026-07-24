#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Fallimento ingestion"
// #let depth=

#use-case(
        codice: get-use-case-code(use-case-nome),
        nome: use-case-nome,
        attore-principale:[Companion],
        attore-secondario: none,
        pre-condizioni:[
                - Il sistema è attivo
                - Si è verificato un evento che ha portato all'interruzione del salvataggio dei dati
        ],
        post-condizioni: [
                - Il sistema non ha salvato o ha salvato parzialmente i dati
                - Companion riceve un messaggio di errore esplicativo
                        ],
        scenario-principale:[
                + Si verifica un evento imprevisto che interrompe il salvataggio dei dati
        ],
        scenari-alternativi:none,
        trigger: none,
        inclusioni: none,
        estensioni: none,
        specializzazioni: none,
        immagine: none,
        caption: none,
)
