#import "/template/requirements/use-case/template.typ": use-case

#use-case(
        codice: "UC-09",
        nome: "Visualizza query test",
        attore-principale:"Supervisore",
        attore-secondario: none,
        pre-condizioni: [
                - Il sistema è attivo
        ],
        post-condizioni: [
                - Il sistema ha creato l'indice sul sistema di permanenza
                        ],
        scenario-principale:[
    + Il supervisore seleziona l'indice da rimuovere
        ],
        scenari-alternativi:none,
        trigger: [Il supervisore vuole creare un indice],
        inclusioni: [
          - inserisci nome
          - seleziona entità
          - selezionare il tipo di indice da creare, vettoriale,testuale,btree e le loro variazioni.
          - selezione criterio di indicizzazione (da approfondire, comunque si limita all'inserimento del campo su cui creare l'indice,oppure fuinzioni composte )
          - 
        ],
        estensioni: [
          - annulla creazione
          - indice non valido
        ],
        specializzazioni: none,
        immagine: none,
        caption: none,
)
