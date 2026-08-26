#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Ricerca su singola entità"
// #let depth=
#let diagram=none


#if utils.debug == true{
        diagram=utils.draw-uc-diagram(
                system-name: "Sistema core",
  target-uc: use-case-nome,
  actors: ("Companion",),
  ext-actors: (),
  includes: (
        "Inserimento query su singola entità",
        "Ricezione risultati ricerca singola entità"
  ),
  extends: (
        // "Inserimento query su singola entità non valida":[Companion inserisce una query non valida],
        "Errore ricerca su singola entità":[Nel sistema si è verificato un errore durante la ricerca],
        ),
  generalizations: (
        "Ricerca full-text",
        "Ricerca semantica",
        "Ricerca ibrida",
  ),
  spacing: (0.5cm, 3cm),
  width: 100%,
  max-height: none,
  actor-offset: 4,
  ext-actor-offset: 0.9,
  note-offset: (2, -0.2),
  
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
                - Companion ha ricevuto i risultati della ricerca
                // - Companion riceve l'identificativo del chunk su cui è stato trovato il match
                // - Companion riceve il chunk di testo su cui è stato trovato il match
                        ],
        scenario-principale:[
                + Companion inserisce una query #sym.arrow #utils.uc-link("Inserimento query su singola entità")
                + Il sistema valida la query
                + Il sistema esegue la query
                + Companion riceve i risultati #sym.arrow #utils.uc-link("ricezione risultati ricerca singola entità")
        ],
        scenari-alternativi:[
                - Errore durante la ricerca #sym.arrow #utils.uc-link("Errore ricerca su singola entità")
        ],
        trigger: [Companion vuole eseguire una ricerca su una singola entità],
        inclusioni: [
                - #utils.uc-link("Inserimento query su singola entità")
                - #utils.uc-link("ricezione risultati ricerca singola entità")
        ],
        estensioni: [
                - #utils.uc-link("Inserimento query su singola entità non valida")

        ],
        specializzazioni: [
                - #utils.uc-link("Ricerca full-text")
                - #utils.uc-link("Ricerca semantica")
                - #utils.uc-link("Ricerca ibrida")
        ],
        immagine: diagram,
        caption: none,
)
