#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Errore ricerca linked"
// #let depth=

#use-case(
        codice: get-use-case-code(use-case-nome),
        nome: use-case-nome,
        attore-principale:[Companion],
        attore-secondario: none,
        pre-condizioni:[
                - Nel sistema è in corso una ricerca su una singola entità
                - Nel sistema siè verificato un errore durante la ricerca
        ],
        post-condizioni: [
                - Companion riceve notifica esplicita dell'errore
                        ],
        scenario-principale:[
                + Il sistema interrompe la ricerca
                + Companion riceve un messaggio d'errore esplicativo
        ],
        scenari-alternativi:none,
        trigger: none,
        inclusioni: none,
        estensioni: none,
        specializzazioni: none,
        immagine: none,
        caption: none,
)
