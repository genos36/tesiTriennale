#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Carica blocco attachment"
// #let depth=

#use-case(
        codice: get-use-case-code(use-case-nome),
        nome: use-case-nome,
        attore-principale:[Companion],
        attore-secondario: [
                - Modello di embedding
                - Modello di language detection
        ],
        pre-condizioni:[
                - Il processo di caricamento dei attachment è in corso
                - N è una costante nota al sistema
                - Il blocco da salvare contiene almeno N attachment
                - I attachment contengono i loro metadati
                - I attachment contenuti nel blocco contengono i campi testuali divisi in chunk.
        ],
        post-condizioni: [
                - Le informazioni relative al blocco di attachment sono state salvate nel sistema 
                - Gli embedding relativi al blocco di attachment sono salvati nel sistema
                - Le informazioni di lingua al blocco di attachment sono salvate nel sistema
                        ],
        scenario-principale:[
                + L'utente carica un blocco di attachment
                + Il sistema rileva le informazioni di lingua da applicare ai chunk
                        + Il sistema può usare l'informazione linguistica presente nei metadati del attachment
                        + Il sistema può usare un modello language detection
                + Il sistema usa il modello di embedding per calcolare gli embedding
                + Il sistema salva il blocco di attachment
                + Il sistema salva gli embedding
                + Il sistema salva le informazioni di lingua
                
        ],
        scenari-alternativi:none,
        trigger: none,
        inclusioni: none,
        estensioni: none,
        specializzazioni: none,
        immagine: none,
        caption: none,
)
