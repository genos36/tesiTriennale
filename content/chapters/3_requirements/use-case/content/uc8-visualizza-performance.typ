#import "/template/requirements/use-case/template.typ": use-case

#upper(text(size:3em,"CHIARIRE SE DEVONO ESSERE VISIBILI LIVE OPPURE BASTANO A POSTERIORI, \n MI SEMBRA CHE DOVESSERO ESSERE VISIBILI LIVE COMUNQUE, O MEGLIO DOVREI CAPIRE SE LE METRICHE DI PERFORMANCE DEVONO ESSERE LIVE E QUELLE DI QUALITà DI RISULTATI possano essere aggiornate solo al termine")
)

#use-case(
        codice: "UC-08",
        nome: "Visualizza performance",
        attore-principale:"Supervisore",
        attore-secondario: none,
        pre-condizioni: [
                - Il sistema è attivo
        ],
        post-condizioni: [
                - Il supervisore ha visualizzato i risultati.
                        ],
        scenario-principale:[
    + Il supervisore visualizza l'hit rate \@1
    + Il supervisore visualizza l'hit rate \@5
    + Il supervisore visualizza l'hit rate \@510
    + Il supervisore visualizza il retriaval MRR
    + Il supervisore visualizza il retriaval answer rate
    + Il supervisore visualizza il not found
    + Il supervisore visualizza la retriaval latency
    + Il supervisore visualizza le retrival wins rispetto ad elastic search
    + Il supervisore visualizza l'End-to-End Ingestion Time
    + Il supervisore visualizza la RAM Index Footprint
    + Il supervisore visualizza l'Index Rebuild Time
        ],
        scenari-alternativi:none,
        trigger: [Il supervisore vuole avviare i test],
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
