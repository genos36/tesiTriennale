#import "/template/requirements/use-case/template.typ": use-case

#use-case(
        codice: "UC-06",
        nome: "Configura parametri di test",
        attore-principale:"Supervisore",
        attore-secondario: none,
        pre-condizioni: [
                - Il sistema è attivo
        ],
        post-condizioni: [
                - Il sistema ha salvato i parametri di configurazione dei test di esecuzione delle query.

                        ],
        scenario-principale:[
    + Il supervisore inserisce il numero degli utenti paralleli da simulare
    + Il supervisore inserisce il cooldown che ogni utente simulato deve aspettare per eseguire una query
    + il sistema registra i parametri di configurazione per il testing
        ],
        scenari-alternativi: [
          - parametri non validi
          - annullamento
        ],
        trigger: [Il supervisore vuole modificare i parametri di configurazione dei test],
        inclusioni: [
          - inserimento utenti paralleli da simulare
          - Inserimento cooldown query
        ],
        estensioni: none,
        specializzazioni: none,
        immagine: none,
        caption: none,
)
