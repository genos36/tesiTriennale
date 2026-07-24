#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Ingestione lista conversation item"
// #let depth=


#use-case(
        codice: get-use-case-code(use-case-nome),
        nome: use-case-nome,
        attore-principale:[Companion],
        attore-secondario: none,
        pre-condizioni:[
                - Il processo di ingestione dei file è stato avviato
        ],
        post-condizioni: [
                - Le informazioni relative alla lista di conversation item sono state salvate nel sistema 
                - Gli embedding relativi alla lista di conversation item sono salvati nel sistema
                - Le informazioni di lingua alla lista di conversation item sono salvate nel sistema
                        ],
        scenario-principale:[
                + L'attore carica la lista dei conversation item
                        + L'utente carica un blocco di conversation item
        ],
        scenari-alternativi:none,
        trigger: none,
        inclusioni: [
                - #utils.uc-link("Carica blocco conversation item")
        ],
        estensioni: none,
        specializzazioni: none,
        immagine: none,
        caption: none,
)
