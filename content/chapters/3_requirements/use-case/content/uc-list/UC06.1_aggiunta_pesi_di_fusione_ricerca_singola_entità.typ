#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Aggiunta pesi di fusione ricerca singola entità"
// #let depth=

#use-case(
        codice: get-use-case-code(use-case-nome),
        nome: use-case-nome,
        attore-principale:[Companion],
        attore-secondario: none,
        pre-condizioni:[
                - Companion sta eseguendo una ricerca ibrida su singola entità
        ],
        post-condizioni: [
                - Companion ha inserito i pesi da usare durante la fusione dei risultati di ricerca
                        ],
        scenario-principale:[
                - Companion inserisce il peso da applicare alla ricerca full-text
                - Companion inserisce il peso da applicare alla ricerca semantica
        ],
        scenari-alternativi:none,
        trigger: none,
        inclusioni: none,
        estensioni: none,
        specializzazioni: none,
        immagine: none,
        caption: none,
)
