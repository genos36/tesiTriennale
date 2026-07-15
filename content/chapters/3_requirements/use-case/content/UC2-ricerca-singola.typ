#import "/template/requirements/use-case/template.typ": use-case

#use-case(
        codice: "UC-02",
        nome: "Ricerca dati su singola entità",
        attore-principale:"Companion",
        attore-secondario: none,
        pre-condizioni: [
                - Il sistema è attivo
        ],
        post-condizioni: [
                - Companion ha ricevuto i risultati della query.
        ],
        scenario-principale:[
          + Companion invia una query di ricerca
          + Il sistema recupera i dati più pertinenti sulla base dei criteri definiti nella query di ricerca.
          + Companion riceve i dati recuperati

        ],
        scenari-alternativi: [
            -  La ricerca non ha prodotto risultati.
        ],
        trigger: [Il sistema Companion vuole recuperare delle informazioni riguardanti una singola tipologia di entità],
        inclusioni: [
                - UC-02.1
                
        ],
        estensioni: [
                - UC-0?
        ],
        specializzazioni: [
          - ricerca semantica UC2.2
          - Ricerca vettoriale UC2.3
          - ricerca ibrida UC2.4
        ],
        immagine: none,
        caption: none,
)

#use-case(
        codice: "UC-02.1",
        nome: "Invio della query su singola entità",
        attore-principale:"Companion",
        attore-secondario: none,
        pre-condizioni: [
                - Nel sistema è stata avviata una query di ricerca su una singola entità
                - La query di ricerca specifica un'entità valida per la ricerca
                - La query di ricerca contiene le informazioni da recuperare
                - La query di ricerca contiene il numero di risultati da restituire.
                - La query di ricerca contiene le informazioni su cui filtrare
                - La query di ricerca contiene il testo da usare per valutare la pertinenza dei dati sul sistema di pertinenza
        ],
        post-condizioni: [
                - Il sistema ha ricevuto la query di ricerca su una singola entità
                - Il tipo di entità selezionato è valido
        ],
        scenario-principale:[
          + Companion invia una query di ricerca

        ],
        scenari-alternativi: [
            -  La query non è valida.
        ],
        trigger: [Il sistema Companion vuole recuperare delle informazioni],
        inclusioni: [
                - UC-02.1
        ],
        estensioni: [
                - UC-0?
        ],
        specializzazioni: none,
        immagine: none,
        caption: none,
)


#use-case(
        codice: "UC-02.2",
        nome: "Ricerca full text su singola entità",
        attore-principale:"Companion",
        attore-secondario: none,
        pre-condizioni: [
                - Il sistema è attivo
        ],
        post-condizioni: [
                - Companion ha ricevuto i risultati della query.
        ],
        scenario-principale:[
          + Companion invia una query di ricerca
          + Il sistema recupera i dati più pertinenti, secondo i criteri della ricerca full-text, sulla base dei criteri definiti nella query di ricerca.
          + Companion riceve i dati recuperati

        ],
        scenari-alternativi: none,
        trigger: [Il sistema Companion vuole recuperare delle informazioni riguardanti una singola tipologia di entità, usando la ricerca full text],
        inclusioni: none,
        estensioni: none,
        specializzazioni: none,
        immagine: none,
        caption: none,
)




#use-case(
        codice: "UC-02.3",
        nome: "Ricerca semantica su singola entità",
        attore-principale:"Companion",
        attore-secondario: "Modello di embedding",
        pre-condizioni: [
                - Il sistema è attivo
        ],
        post-condizioni: [
                - Companion ha ricevuto i risultati della query.
        ],
        scenario-principale:[
          + Companion invia una query di ricerca
          + Il sistema usa il modello di embedding per calcolare il vettore di embedding del campo testuale da usare per la ricerca
          + Il sistema recupera i dati più pertinenti, secondo i criteri della ricerca semantica, sulla base dei criteri definiti nella query di ricerca.
          + Companion riceve i dati recuperati

        ],
        scenari-alternativi: none,
        trigger: [Il sistema Companion vuole recuperare delle informazioni riguardanti una singola tipologia di entità, usando la ricerca semantica],
        inclusioni:none,
        estensioni: none,
        specializzazioni: none,
        immagine: none,
        caption: none,
)
#use-case(
        codice: "UC-02.4",
        nome: "Ricerca ibrida su singola entità",
        attore-principale:"Companion",
        attore-secondario: "Modello di embedding",
        pre-condizioni: [
                - Il sistema è attivo
        ],
        post-condizioni: [
                - Companion ha ricevuto i risultati della query.
        ],
        scenario-principale:[
          + Companion invia una query di ricerca
          + Il sistema usa il modello di embedding per calcolare il vettore di embedding del campo testuale da usare per la ricerca
          + Il sistema recupera i dati più pertinenti, secondo i criteri della ricerca full-text, sulla base dei criteri definiti nella query di ricerca.
          + Il sistema recupera i dati più pertinenti, secondo i criteri della ricerca semantica, sulla base dei criteri definiti nella query di ricerca.
          + Il sistema fonde i set di risultati e seleziona i top k risultati sulla nuova classifica.
          + Companion riceve i dati recuperati

        ],
        scenari-alternativi: none,
        trigger: [Il sistema Companion vuole recuperare delle informazioni riguardanti una singola tipologia di entità, usando la ricerca ibrida],
        inclusioni:none,
        estensioni: none,
        specializzazioni: [
          - Ricerca ibrida con fusione basata su rrf
          - Ricerca ibrida con fusione basata su un modello di re-ranking
        ],
        immagine: none,
        caption: none,
)
#use-case(
        codice: "UC-02.4.1",
        nome: "Ricerca ibrida su singola entità rrf",
        attore-principale:"Companion",
        attore-secondario: "Modello di embedding",
        pre-condizioni: [
                - Il sistema è attivo
        ],
        post-condizioni: [
                - Companion ha ricevuto i risultati della query.
        ],
        scenario-principale:[
          + Companion invia una query di ricerca
          + Il sistema usa il modello di embedding per calcolare il vettore di embedding del campo testuale da usare per la ricerca
          + Il sistema recupera i dati più pertinenti, secondo i criteri della ricerca full-text, sulla base dei criteri definiti nella query di ricerca.
          + Il sistema recupera i dati più pertinenti, secondo i criteri della ricerca semantica, sulla base dei criteri definiti nella query di ricerca.
          + Il sistema fonde i set di risultati usando un algoritmo RRF e seleziona i top k risultati sulla nuova classifica.
          + Companion riceve i dati recuperati

        ],
        scenari-alternativi: none,
        trigger: [Il sistema Companion vuole recuperare delle informazioni riguardanti una singola tipologia di entità, usando la ricerca ibrida rrf],
        inclusioni:none,
        estensioni: none,
        specializzazioni: none,
        immagine: none,
        caption: none,
)

#use-case(
        codice: "UC-02.4.2",
        nome: "Ricerca ibrida su singola entità modello di rerank",
        attore-principale:"Companion",
        attore-secondario: "Modello di embedding modello di rerank",
        pre-condizioni: [
                - Il sistema è attivo
        ],
        post-condizioni: [
                - Companion ha ricevuto i risultati della query.
        ],
        scenario-principale:[
          + Companion invia una query di ricerca
          + Il sistema usa il modello di embedding per calcolare il vettore di embedding del campo testuale da usare per la ricerca
          + Il sistema recupera i dati più pertinenti, secondo i criteri della ricerca full-text, sulla base dei criteri definiti nella query di ricerca.
          + Il sistema recupera i dati più pertinenti, secondo i criteri della ricerca semantica, sulla base dei criteri definiti nella query di ricerca.
          + Il sistema fonde i set di risultati usando un modello di rerank e seleziona i top k risultati sulla nuova classifica.
          + Companion riceve i dati recuperati

        ],
        scenari-alternativi: none,
        trigger: [Il sistema Companion vuole recuperare delle informazioni riguardanti una singola tipologia di entità, usando la ricerca ibrida con modello di rerank],
        inclusioni:none,
        estensioni: none,
        specializzazioni: none,
        immagine: none,
        caption: none,
)




