#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Inserimento campo di ritorno"
// #let depth=

#use-case(
        codice: get-use-case-code(use-case-nome),
        nome: use-case-nome,
        attore-principale:[Supervisore],
        attore-secondario: none,
        pre-condizioni:[
                - Il supervisore sta inserendo i campi dati da ritornare
        ],
        post-condizioni: [
                - Il sistema ha registrato i campi dati da ritornare
                        ],
        scenario-principale:[
                + Il supervisore seleziona i campi di ritorno dalla lista dei campi di ritorno disponibili
        ],
        scenari-alternativi:none,
        trigger: none,
        inclusioni: none,
        estensioni: none,
        specializzazioni: none,
        immagine: none,
        caption: none,
)