#import "/template/requirements/use-case/template.typ": use-case

#use-case(
        codice: "UC-07",
        nome: "Esegui test",
        attore-principale:"Supervisore",
        attore-secondario: none,
        pre-condizioni: [
                - Il sistema è attivo
        ],
        post-condizioni: [
                - Il sistema ha loggato i risultati di test.

                        ],
        scenario-principale:[
    + Il supervisore avvia i test
    + Il sistema logga i risultati
        ],
        scenari-alternativi:none,
        trigger: [Il supervisore vuole avviare i test],
        inclusioni: none,
        estensioni: none,
        specializzazioni: none,
        immagine: none,
        caption: none,
)
