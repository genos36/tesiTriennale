#import "/template/requirements/use-case/template.typ": use-case

#use-case(
        codice: "UC-05",
        nome: "Rimuovi query di ricerca",
        attore-principale:"Supervisore",
        attore-secondario: none,
        pre-condizioni: [
                - Il sistema è attivo
        ],
        post-condizioni: [
                - La query è stata rimossa dall'elenco delle query da eseguire in fase di test  
                        ],
        scenario-principale:[
          + Il supervisore seleziona la query da eliminare
          + Il sistema la rimuove dalla lista delle query di test da eseguire

        ],
        scenari-alternativi: none,
        trigger: [Il supervisore vuole rimuovere una query da eseguire durante il testing],
        inclusioni: none,
        estensioni: none,
        specializzazioni: none,
        immagine: none,
        caption: none,
)
