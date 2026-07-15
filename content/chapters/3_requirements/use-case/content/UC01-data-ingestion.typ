#import "/template/requirements/use-case/template.typ": use-case

#use-case(
        codice: "UC-01",
        nome: "data ingestion",
        attore-principale:"Companion",
        attore-secondario: none,
        pre-condizioni: [
                - Il sistema è attivo
        ],
        post-condizioni: [
                - Le informazioni da salvare sono state salvate nel sistema con i relativi embedding e la relativa informazione di lingua
        ],
        scenario-principale:[
                + L'attore carica la lista di ticket
                + L'attore carica la lista di conversation item
                + Il sistema salva la lista di conversation item
                + L'attore carica la lista di attachment
                + Il sistema salva la lista di attachment

        ],
        scenari-alternativi: [
                - Il caricamento di una o più liste fallisce
        ],
        trigger: [Il sistema Companion vuole effettuare un caricamento bulk di dati sul sistema di permanenza dei dati],
        inclusioni: [
                - UC-01.1
                - UC-01.2
                - UC-01.3
        ],
        estensioni: [
                - UC-02
        ],
        specializzazioni: none,
        immagine: image("/content/chapters/3_requirements/use-case/content/uc1.drawio.png"),
        caption: none,
)

#use-case(
        codice: "UC-01.1",
        nome: "Caricamento lista ticket",
        attore-principale:"Companion",
        attore-secondario: none,
        pre-condizioni: [
                - Il sistema è attivo
                - Il processo di ingestione dei file è stato avviato
        ],
        post-condizioni: [
                - Le informazioni relative ai ticket sono state salvate nel sistema con i relativi embedding e la relativa informazione di lingua
        ],
        scenario-principale:[
                + L'attore carica la lista dei ticket
                        + L'utente carica un blocco di ticket
                

        ],
        scenari-alternativi: none,
        trigger: none,
        inclusioni: [
                - UC-01.1.1
        ],
        estensioni: none,
        specializzazioni: none,
        immagine: image("/content/chapters/3_requirements/use-case/content/uc1.1.drawio.png"),
        caption: none,
)







#use-case(
        codice: "UC-01.1.1",
        nome: "Caricamento blocco di ticket",
        attore-principale:"Companion",
        attore-secondario: [
                - Language detection model
                - Embedding model
        ],
        pre-condizioni: [
                - Il processo di caricamento dei ticket è in corso
                - N è una costante nota al sistema
                - I ticket contenuti in ogni blocco contengono i metadati del ticket
                - I ticket contenuti nel blocco contengono i campi testuali da embeddare già con la lista di chunk di testo da salvare e elaborare.
        ],
        post-condizioni: [
                - Le informazioni relative al blocco di ticket sono state salvate nel sistema con i relativi embedding e la relativa informazione di lingua
        ],
        scenario-principale:[
                + L'utente carica un blocco di ticket
                + Il sistema rileva le informazioni di lingua da applicare ai chunk
                        + Il sistema può usare l'informazione linguistica presente nei metadati del ticket
                        + Il sistema può usare un modello language detection
                + Il sistema usa il modello dei embedding per calcolare gli embedding
                + Il sistema salva il blocco di ticket con le informazioni aggiuntive

        ],
        scenari-alternativi: none,
        trigger: none,
        inclusioni:none,
        estensioni: none,
        specializzazioni: none,
        immagine: image("/content/chapters/3_requirements/use-case/content/uc1.1.1v2.drawio.png"),
        caption: none,
)





#use-case(
        codice: "UC-01.2",
        nome: "Caricamento lista conversation item",
        attore-principale:"Companion",
        attore-secondario: none,
        pre-condizioni: [
                - Il processo di ingestione dei file è stato avviato
                - i ticket sono stati caricati
        ],
        post-condizioni: [
                - Le informazioni relative ai conversation item sono state salvate nel sistema con i relativi embedding e la relativa informazione di lingua
        ],
        scenario-principale:[
                + L'attore carica la lista dei conversation item
                        + L'utente carica un blocco di conversation item
                

        ],
        scenari-alternativi: none,
        trigger: none,
        inclusioni: [
                - UC-01.2.1
        ],
        estensioni: none,
        specializzazioni: none,
        immagine: image("/content/chapters/3_requirements/use-case/content/uc1.1.drawio.png"),
        caption: none,
)







#use-case(
        codice: "UC-01.2.1",
        nome: "Caricamento blocco di conversation item",
        attore-principale:"Companion",
        attore-secondario: [
                - Language detection model
                - Embedding model
        ],
        pre-condizioni: [
                - Il processo di caricamento dei conversation item è in corso
                - N è una costante nota al sistema
                - I conversation item contenuti in ogni blocco contengono i metadati del conversation item
                - I conversation item contenuti nel blocco contengono i campi testuali da embeddare già con la lista di chunk di testo da salvare e elaborare.
        ],
        post-condizioni: [
                - Le informazioni relative al blocco di conversation item sono state salvate nel sistema con i relativi embedding e la relativa informazione di lingua
        ],
        scenario-principale:[
                + L'utente carica un blocco di conversation item
                + Il sistema rileva le informazioni di lingua da applicare ai chunk
                        + Il sistema può usare l'informazione linguistica presente nei metadati del conversation item
                        + Il sistema può usare un modello language detection
                + Il sistema usa il modello dei embedding per calcolare gli embedding
                + Il sistema salva il blocco di conversation item con le informazioni aggiuntive

        ],
        scenari-alternativi: none,
        trigger: none,
        inclusioni:none,
        estensioni: none,
        specializzazioni: none,
        immagine: image("/content/chapters/3_requirements/use-case/content/uc1.1.1v2.drawio.png"),
        caption: none,
)


#use-case(
        codice: "UC-01.3",
        nome: "Caricamento lista attachment",
        attore-principale:"Companion",
        attore-secondario: none,
        pre-condizioni: [
                - Il processo di ingestione dei file è stato avviato
                - i ticket sono stati caricati
                - i conversation item sono stati caricati
        ],
        post-condizioni: [
                - Le informazioni relative agli attachment sono state salvate nel sistema con i relativi embedding e la relativa informazione di lingua
        ],
        scenario-principale:[
                + L'attore carica la lista di attachment
                        + L'utente carica un blocco di attachment
                

        ],
        scenari-alternativi: none,
        trigger: none,
        inclusioni: [
                - UC-01.2.1
        ],
        estensioni: none,
        specializzazioni: none,
        immagine: image("/content/chapters/3_requirements/use-case/content/uc1.1.drawio.png"),
        caption: none,
)







#use-case(
        codice: "UC-01.2.1",
        nome: "Caricamento blocco di attachment",
        attore-principale:"Companion",
        attore-secondario: [
                - Language detection model
                - Embedding model
        ],
        pre-condizioni: [
                - Il processo di caricamento degli attachment è in corso
                - N è una costante nota al sistema
                - Gli attachment contenuti in ogni blocco contengono i metadati dell'attachment
                - Gli attachment  contenuti nel blocco contengono i campi testuali da embeddare già con la lista di chunk di testo da salvare e elaborare.
        ],
        post-condizioni: [
                - Le informazioni relative al blocco di attachment sono state salvate nel sistema con i relativi embedding e la relativa informazione di lingua
        ],
        scenario-principale:[
                + L'utente carica un blocco di attachment
                + Il sistema rileva le informazioni di lingua da applicare ai chunk
                        + Il sistema può usare l'informazione linguistica presente nei metadati dell'attachment
                        + Il sistema può usare un modello language detection
                + Il sistema usa il modello dei embedding per calcolare gli embedding
                + Il sistema salva il blocco di attachment con le informazioni aggiuntive

        ],
        scenari-alternativi: none,
        trigger: none,
        inclusioni:none,
        estensioni: none,
        specializzazioni: none,
        immagine: image("/content/chapters/3_requirements/use-case/content/uc1.1.1v2.drawio.png"),
        caption: none,
)
