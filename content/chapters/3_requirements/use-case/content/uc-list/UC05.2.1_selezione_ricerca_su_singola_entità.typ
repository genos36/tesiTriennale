#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Selezione ricerca su singola entità"
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
                - Il sistema ha registrato lo scope della ricerca
                        ],
        scenario-principale:[
                + Il supervisore seleziona lo scope ricerca su singola entità
        ],
        scenari-alternativi:none,
        trigger: none,
        inclusioni: none,
        estensioni: none,
        specializzazioni: [
                - #utils.uc-link("Selezione ricerca sui ticket")
                - #utils.uc-link("Selezione ricerca sui conversation item")
                - #utils.uc-link("Selezione ricerca sugli attachment")
        ],
        immagine: none,
        caption: none,
)
