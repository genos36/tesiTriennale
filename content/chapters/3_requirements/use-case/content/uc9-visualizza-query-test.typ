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
                - Il Supervisore ha visualizzato la lista delle query di test
                        ],
        scenario-principale:[
    + Il supervisore visualizza id della query di test
    + Il supervisore visualizza il tipo della query di test
    + Il supervisore visualizza lo scope della query di test
    + Il supervisore visualizza i dati di ritorno
    + Il supervisore visualizza visualizza i filtri inseriti
    + Il supervisore visualizza visualizza i criteri di pertinenza
    + Il supervisore visualizza i valori identificativi attesi
    + Il supervisore visualizza i risultati della query
      - visualizza lista valori di ritorno
      - visualizza messaggio nessun valore restituito

        ],
        scenari-alternativi:none,
        trigger: [Il supervisore vuole visualizzare la lista delle query],
        inclusioni: [
                Visualizzazione delle singole metriche
        ],
        estensioni: [
                nessun dato disponibile
        ],
        specializzazioni: none,
        immagine: none,
        caption: none,
)
