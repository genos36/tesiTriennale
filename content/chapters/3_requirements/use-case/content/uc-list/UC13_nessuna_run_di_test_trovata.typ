#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Nessuna run di test trovata"
// #let depth=
#use-case(
        codice: get-use-case-code(use-case-nome),
        nome: use-case-nome,
        attore-principale:[Supervisore],
        attore-secondario: none,
        pre-condizioni:[
                - Il sistema è attivo
        ],
        post-condizioni: [
                - Il supervisore è stato informato dell'assenza di run di test
                        ],
        scenario-principale:[
                + Il sistema non trova nessuna run di test da mostrare
                + Il supervisore viene informato dell'assenza di run di test su cui calcolare le metriche
        ],
        scenari-alternativi:none,
        trigger: none,
        inclusioni: none,
        estensioni: none,
        specializzazioni: none,
        immagine: none,
        caption: none,
)
