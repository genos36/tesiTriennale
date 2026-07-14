#import "/template/requirements/use-case/template.typ": use-case

#use-case(
        codice: "UC-01",
        nome: "data ingestion",
        attore-principale:"Companion",
        attore-secondario: "embedding model",
        pre-condizioni: [
                - precondizione
                - precondizione
                - precondizione
        ],
        post-condizioni: [
                - postcondizione
                - postcondizione
                - postcondizione
        ],
        scenario-principale:[
                + passo 1
                + passo 2
                + passo 3
                        + sotto passaggio 3.1
                + passo4
        ],
        scenari-alternativi: [
                - scenario alternativo
                - scenario alternativo
                - scenario alternativo
        ],
        trigger: [evento trigger],
        inclusioni: [
                (elenco esplicito senza descrizioni testuali)
                - Inclusione
                - Inclusione
                - Inclusione
        ],
        estensioni: [
                (elenco esplicito senza descrizioni testuali)
                - estensione
                - estensione
                - estensione
        ],
        specializzazioni: [
                - specializzazione
                - specializzazione
                - specializzazione
        ],
        immagine: [Seganposto immagine],
        caption: [immagine temporanea],
)
