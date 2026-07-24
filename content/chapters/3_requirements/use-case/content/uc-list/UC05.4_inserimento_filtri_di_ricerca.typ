#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Inserimento filtri di ricerca"
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
                - Il sistema ha registrato il filtro inserito
                        ],
        scenario-principale:[
                + Il supervisore può inserire un filtro di ricerca configurabile
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
