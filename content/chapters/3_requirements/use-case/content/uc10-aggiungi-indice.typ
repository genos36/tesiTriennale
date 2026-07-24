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
    + Il supervisore inserisce il nome dell'indice
    + Il supervisore seleziona l'entità target dell'indice
    + Il supervisore seleziona il tipo di indice da creare (rendere esplicito che la scelta dipende strettamente dal criterio di indicizzazione, se sceglie un campo vettoriale deve poter selezionare hnsw o ivfflat e il tipo di distanza da usare)
    + Il supervisore specifica il criterio di indicizzazione
        - Indice semplice su un campo
        - Expression index
    + il supervisore può specificare un filtro (necessario se si vuole creare un partial index)

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
