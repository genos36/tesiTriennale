#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Visualizza metriche di consumo delle risorse"
// #let depth=

#use-case(
        codice: get-use-case-code(use-case-nome),
        nome: use-case-nome,
        attore-principale:[Supervisore],
        attore-secondario: none,
        pre-condizioni:[
                - Il supervisore sta visualizzando la dashboard delle performance
        ],
        post-condizioni: [
                - Il supervisore ha visualizzato le metriche relative al consumo di risorse del DB.
                        ],
        scenario-principale:[
                + ANCORA DA DECIDERE IN ATTESA DI INDICAZIONI DAL TUTOR
        ],
        scenari-alternativi:none,
        trigger: none,
        inclusioni: none,
        estensioni: none,
        specializzazioni: none,
        immagine: none,
        caption: none,
)
