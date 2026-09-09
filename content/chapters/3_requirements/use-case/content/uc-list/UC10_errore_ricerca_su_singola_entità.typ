#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Errore ricerca su singola entità"
// #let depth=
#use-case(
        codice: get-use-case-code(use-case-nome),
        nome: use-case-nome,
        attore-principale:[Companion],
        attore-secondario: none,
        pre-condizioni:[
                - Nel sistema di ricerca è in corso una ricerca su una singola entità
                - Nel sistema di ricerca si è verificato un errore durante la ricerca
        ],
        post-condizioni: [
                - Companion riceve notifica esplicativa dell'errore
                        ],
        scenario-principale:[
                + Il sistema di ricerca interrompe la ricerca
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
