#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Ingestione lista ticket"
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
                - Le informazioni relative alla lista di ticket sono state salvate nel sistema 
                - Gli embedding relativi alla lista di ticket sono salvati nel sistema
                - Le informazioni di lingua alla lista di ticket sono salvate nel sistema
                        ],
        scenario-principale:[
                + L'attore carica la lista dei ticket
                        + L'utente carica un blocco di ticket
        ],
        scenari-alternativi:none,
        trigger: none,
        inclusioni: [
                - #utils.uc-link("Carica blocco ticket")
        ],
        estensioni: none,
        specializzazioni: none,
        immagine: none,
        caption: none,
)
