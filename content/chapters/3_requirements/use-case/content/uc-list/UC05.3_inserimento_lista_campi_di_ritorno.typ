#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Inserimento lista campi di ritorno"
// #let depth=

#use-case(
        codice: get-use-case-code(use-case-nome),
        nome: use-case-nome,
        attore-principale:[Supervisore],
        attore-secondario: none,
        pre-condizioni:[
                - Nel sistema è in corso l'aggiunta di una query di test
        ],
        post-condizioni: [
                - Il sistema ha registrato i campi dati da ritornare
                        ],
        scenario-principale:[
                + Il supervisore visualizza i campi di ritorno
                + Il supervisore seleziona i campi dati dalla lista
        ],
        scenari-alternativi:
        [
                - Lista campi da ritornare non valida
        ],
        trigger: none,
        inclusioni: [
                - #utils.uc-link("Visualizza lista campi di ritorno disponibili")
                - #utils.uc-link("Inserimento campo di ritorno")
        ],
        estensioni: none,
        specializzazioni: none,
        immagine: none,
        caption: none,
)
