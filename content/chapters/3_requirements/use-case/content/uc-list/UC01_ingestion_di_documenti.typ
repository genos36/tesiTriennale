#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Ingestion di documenti"
// #let depth=

#let diagram=none


#if utils.debug == true{
        diagram=utils.draw-uc-diagram(
        system-name: "Sistema core - API", // Nome nell'angolo del recinto
        target-uc: use-case-nome,
        actors: ("Companion",),        // Attori primari, a sinistra
        ext-actors: (),              // Attori esterni/secondari, sul lato opposto
        includes: (
                "Ingestione lista ticket",
                "Ingestione lista conversation item",
                "Ingestione lista attachments",
                ),
        extends: ("Fallimento ingestion":"Errore nell'ingestion dei dati"),
        generalizations: (),
        spacing: (2.5cm, 2cm),
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
        ],
        post-condizioni: [
                - Le informazioni sono state salvate nel sistema
                - Gli embedding associati sono stati salvati nel sistema
                - Le informazioni di lingua associate sono state salvate nel sistema
                - Informazioni duplicate sono state aggiornate
                - Companion viene notificato del corretto salvataggio dei dati.
                        ],
        scenario-principale:[
                + Companion avvia il processo di ingestion dei dati 
                + Companion carica la lista di ticket #sym.arrow #utils.uc-link("ingestione lista ticket")
                + Companion carica la lista di conversation item #sym.arrow #utils.uc-link("ingestione lista conversation item")
                + Companion carica la lista di attachment #sym.arrow #utils.uc-link("ingestione lista attachments")

        ],
        scenari-alternativi:[
                - Fallimento dell'ingestion #sym.arrow #utils.uc-link("Fallimento ingestion")
        ],
        trigger: [Companion vuole caricare dei documenti sul sistema],
        inclusioni: [
                - #utils.uc-link("ingestione lista ticket")
                - #utils.uc-link("ingestione lista conversation item")
                - #utils.uc-link("ingestione lista attachments")
        ],
        estensioni: 
        [
                - #utils.uc-link("Fallimento ingestion")
        ]
        ,
        specializzazioni: none,
        immagine: diagram,
        caption: none,
)
