#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Visualizzazione not found"
// #let depth=

#use-case(
        codice: get-use-case-code(use-case-nome),
        nome: use-case-nome,
        attore-principale:[Supervisore],
        attore-secondario: none,
        pre-condizioni:[
                - Il supervisore sta visualizzando la lista delle metriche
                - Nel sistema sono presenti i dati relativi all'ultimo test svolto o in corso
        ],
        post-condizioni: [
                - Il supervisore ha visualizzato il retrieval not found
                        ],
        scenario-principale:[
                - Il supervisore visualizza il retrieval retrieval not found
        ],
        scenari-alternativi:none,
        trigger: none,
        inclusioni: none,
        estensioni: none,
        specializzazioni: none,
        immagine: none,
        caption: none,
)
