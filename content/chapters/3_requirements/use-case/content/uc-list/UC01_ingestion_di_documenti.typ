#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Ingestion di documenti"
// #let depth=

#let diagram=none


#if utils.debug == true{
        diagram=utils.draw-uc-diagram(
        system-name: "Sistema core", // Nome nell'angolo del recinto
        target-uc: use-case-nome,
        actors: ("Companion",),        // Attori primari, a sinistra
        ext-actors: (),              // Attori esterni/secondari, sul lato opposto
        includes: (
                "Avvia ingestion",
                "Ingestion liste entità",
                "Termina ingestion"
                ),
        extends: (:),
        generalizations: (),
        spacing: (3cm, 2cm),
        width: 100%,                 // Come width per le immagini: si adatta al contenitore
        max-height: none,            // Limite opzionale, utile per non sforare la pagina
        actor-offset: 1.05,
        ext-actor-offset: 5,
        note-offset: (-0.8, 0.5),
        )
}

#use-case(
        codice: get-use-case-code(use-case-nome),
        nome: use-case-nome,
        attore-principale:[Companion],
        attore-secondario: none,
        pre-condizioni:[
                - Il sistema è attivo
                - Nel sistema non ci sono sessioni di ingestion di documenti attive
        ],
        post-condizioni: [
                - Il sistema ha salvato le informazioni ricevute
                - Il sistema ha salvato gli embedding relativi ai dati
                - Il sistema ha salvato le informazioni di lingua relative ai dati
                - Il sistema ha reso le informazioni disponibili per la ricerca
                // - Il sistema ha risolto conflitti di inserimento con l'aggiornamento
                        ],
        scenario-principale:[
                + Companion avvia il processo di ingestion dei dati #sym.arrow #utils.uc-link("Avvia ingestion")
                + Companion carica le liste di entità #sym.arrow #utils.uc-link("ingestion liste entità")
                + Companion termina il processo di ingestion #sym.arrow #utils.uc-link("Termina ingestion")
                + Companion viene notificato del corretto salvataggio dei dati.

        ],
        scenari-alternativi:none,
        trigger: [Companion vuole caricare dei documenti sul sistema],
        inclusioni: [
                - #utils.uc-link("Avvia ingestion")
                - #utils.uc-link("ingestion liste entità")
                - #utils.uc-link("Termina ingestion")
        ],
        estensioni: none,
        specializzazioni: none,
        immagine: diagram,
        caption: none,
)
