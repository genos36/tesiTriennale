#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Ricerca ibrida con rrf"
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
                - Companion ha ricevuto i risultati della ricerca.
                        ],
        scenario-principale:[
                + Companion inserisce una query
                + Il sistema esegue la query valutando la pertinenza in base alla ricerca semantica
                + Il sistema esegue la query valutando la pertinenza in base alla ricerca full-text
                + Il sistema fonde i risultati tramite RRF
                + Il sistema ritorna i risultati
        ],
        scenari-alternativi:none,
        trigger: [Companion vuole eseguire una ricerca su una singola entità],
        inclusioni: none,
        estensioni: none,
        specializzazioni: none,
        immagine: none,
        caption: none,
)