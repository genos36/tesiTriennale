#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Fallimento ingestion"
// #let depth=

#use-case(
        codice: get-use-case-code(use-case-nome),
        nome: use-case-nome,
        attore-principale:[Companion],
        attore-secondario: none,
        pre-condizioni:[
                - Il processo di caricamento lista di entità è in corso
        ],
        post-condizioni: [
                - Il sistema di ricerca non ha salvato i record non validi
                - Companion riceve un messaggio di errore esplicativo
                        ],
        scenario-principale:[
                + Companion carica un blocco di entità
                + Il sistema di ricerca rileva degli errori relativi a uno o più record del blocco
                + Companion riceve un errore esplicativo relativo ai record che hanno generato errori
                ],
        scenari-alternativi:none,
        trigger: none,
        inclusioni: none,
        estensioni: none,
        specializzazioni: none,
        immagine: none,
        caption: none,
)
