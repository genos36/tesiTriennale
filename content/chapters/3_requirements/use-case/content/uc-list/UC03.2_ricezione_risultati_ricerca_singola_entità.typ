#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Ricezione risultati ricerca singola entità"
// #let depth=

#use-case(
        codice: get-use-case-code(use-case-nome),
        nome: use-case-nome,
        attore-principale:[Companion],
        attore-secondario: none,
        pre-condizioni:[
                - Nel sistema è in corso una ricerca su singola entità
                - Il sistema ha eseguito la query
        ],
        post-condizioni: [
                - Companion ha ricevuto i risultati della ricerca
                        ],
        scenario-principale:[
                + Il sistema ritorna la lista dei risultati prodotti dalla ricerca
                + Companion riceve i risultati della ricerca
        ],
        scenari-alternativi:none,
        trigger: none,
        inclusioni: none,
        estensioni: none,
        specializzazioni: none,
        immagine: none,
        caption: none,
)
