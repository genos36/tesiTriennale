#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Ingestione lista attachments"
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
                - Le informazioni relative alla lista di attachment sono state salvate nel sistema 
                - Gli embedding relativi alla lista di attachment sono salvati nel sistema
                - Le informazioni di lingua alla lista di attachment sono salvate nel sistema
                        ],
        scenario-principale:[
                + L'attore carica la lista dei attachment
                        + L'utente carica un blocco di attachment
        ],
        scenari-alternativi:none,
        trigger: none,
        inclusioni: [
                - #utils.uc-link("Carica blocco attachment")
        ],
        estensioni: none,
        specializzazioni: none,
        immagine: none,
        caption: none,
)
