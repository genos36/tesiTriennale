#import "/template/requirements/use-case/template.typ": use-case

#use-case(
        codice: "UC-04",
        nome: "Ricerca dati linked",
        attore-principale:"Supervisore",
        attore-secondario: none,
        pre-condizioni: [
                - Il sistema è attivo
        ],
        post-condizioni: [
                - La query è stata aggiunta all'elenco delle query da eseguire in fase di test  
                        ],
        scenario-principale:[
          + Il supervisore seleziona il tipo di query
          + Il supervisore seleziona la modalità di ricerca
          + Il supervisore seleziona dati di ritorno
          + Il supervisore imposta filtro
          + Il supervisore configura i criteri di pertinenza
          + il supervisore inserisce il valore identificativo atteso 
        ],
        scenari-alternativi: [
            -  query non valida
            - annullamento operazione
        ],
        trigger: [Il supervisore vuole aggiungere una query da eseguire durante il testing],
        inclusioni: [
          - selezione  tipo di query          
          - selezione  modalità di ricerca                
          - selezione dati di ritorno   
          - impostazione filtro
          - inserimento il valore identificativo atteso 
        ],
        estensioni: [
                - UC-0?
        ],
        specializzazioni: none,
        immagine: none,
        caption: none,
)

#use-case(
        codice: "UC-04.1",
        nome: "Seleziona tipo ricerca",
        attore-principale:"Supervisore",
        attore-secondario: none,
        pre-condizioni: [
                - Nel sistema è in corso il processo di aggiunta di una query. 
        ],
        post-condizioni: [
                 - Il sistema ha registrato il tipo di query
                        ],
        scenario-principale:[
          + Il supervisore seleziona il tipo di ricerca
          + Il sistema salva il tipo di ricerca selezionato
        ],
        scenari-alternativi:none,
        trigger: none,
        inclusioni: none,
        estensioni: none,
        specializzazioni: 
        [
          - seleziona full text
          - seleziona semantica
          - seleziona ibrida
        ],
        immagine: none,
        caption: none,
)

#use-case(
        codice: "UC-04.2",
        nome: "Seleziona scope ricerca",
        attore-principale:"Supervisore",
        attore-secondario: none,
        pre-condizioni: [
                - Nel sistema è in corso il processo di aggiunta di una query. 
        ],
        post-condizioni: [
                 - Il sistema ha registrato il tipo di query
                        ],
        scenario-principale:[
          + Il supervisore seleziona lo scope della ricerca ricerca
          + Il sistema salva lo scope della ricerca selezionato
        ],
        scenari-alternativi:none,
        trigger: none,
        inclusioni: none,
        estensioni: none,
        specializzazioni: 
        [
          - Seleziona Linked
          - Seleziona singola entità
            - Seleziona ticket
            - Seleziona conv item
            - Seleziona attachment
        ],
        immagine: none,
        caption: none,
)
#use-case(
        codice: "UC-04.3",
        nome: "Seleziona dati di ritorno",
        attore-principale:"Supervisore",
        attore-secondario: none,
        pre-condizioni: [
                - Nel sistema è in corso il processo di aggiunta di una query. 
        ],
        post-condizioni: [
          - Il sistema ha registrato i dati di ritorno indicati dal supervisore
                        ],
        scenario-principale:[
          + Il supervisore visualizza la lista di possibili dati di ritorno
          + Il supervisore seleziona uno o più dati di ritorno dalla lista
          + Il sistema registra i dati di ritorno indicati dal supervisore
        ],
        scenari-alternativi:none,
        trigger: none,
        inclusioni: [
          - visualizza lista
          - Seleziona dati di ritorno da lista
        ],
        estensioni: none,
        specializzazioni: none,
        immagine: none,
        caption: none,
)
#use-case(
        codice: "UC-04.4",
        nome: "Imposta filtri",
        attore-principale:"Supervisore",
        attore-secondario: none,
        pre-condizioni: [
              - Nel sistema è in corso il processo di aggiunta di una query. 

        ],
        post-condizioni: [
          - Il sistema ha registrato i filtri impostati dal supervisore
                        ],
        scenario-principale:[
          + Il supervisore inserisce una o più condizioni
            - le condizioni possono essere unitarie 
            - le condizioni possono essere composte e annidate (X AND (Y OR Z)) 
          + Il sistema salva i filtri impostati dal supervisore

        ],
        scenari-alternativi:none,
        trigger: none,
        inclusioni: [
          - inserisci condizione
              - condizione unitaria
              - condizione composta
        ],
        estensioni: none,
        specializzazioni: none,
        immagine: none,
        caption: none,
)
#use-case(
        codice: "UC-04.5",
        nome: "Configura criteri di similarità",
        attore-principale:"Supervisore",
        attore-secondario: none,
        pre-condizioni: [
      
              - Nel sistema è in corso il processo di aggiunta di una query. 

        ],
        post-condizioni: [
            - Il sistema ha salvato i criteri di pertinenza
                        ],
        scenario-principale:[
        + Il supervisore inserisce il testo da usare nel calcolo della similarità
        + Il supervisore inserisce la lingua del testo
        + Il supervisore visualizza la lista su cui è possibile effettuare la ricerca di similarità
        + Il supervisore seleziona i campi da considerare per la ricerca di similarità
        ],
        scenari-alternativi:none,
        trigger: none,
        inclusioni: [
          - Inserisci testo
          - Seleziona lingua testo
          - visualizza campi disponibili per similarity search
          - Seleziona campi da considerare per la similarity search
        ],
        estensioni: none,
        specializzazioni: none,
        immagine: none,
        caption: none,
)
#use-case(
        codice: "UC-04.6",
        nome: "",
        attore-principale:"Supervisore",
        attore-secondario: none,
        pre-condizioni: [
                      - Nel sistema è in corso il processo di aggiunta di una query. 

        ],
        post-condizioni: [
          - Il sistema ha registrato il valore identificativo atteso per la query
                        ],
        scenario-principale:[
          + Il supervisore inserisce l'identificativo atteso per la ricerca.
        ],
        scenari-alternativi:none,
        trigger: none,
        inclusioni: none,
        estensioni: none,
        specializzazioni: none,
        immagine: none,
        caption: none,
)
