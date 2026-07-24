#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Selezione ricerca full text"
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
                - Il sistema ha registrato il tipo di ricerca selezionato
                        ],
        scenario-principale:[
                + Il supervisore seleziona la ricerca full-text
        ],
        scenari-alternativi:none,
        trigger: none,
        inclusioni: none,
        estensioni: none,
        specializzazioni: [
                - #utils.uc-link("Selezione ricerca full-text")
                - #utils.uc-link("Selezione ricerca semantica")
                - #utils.uc-link("Selezione ricerca ibrida")
        ],
        immagine: none,
        caption: none,
)
