#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Ricerca linked"
// #let depth=
#let diagram=none


#if utils.debug == true{
        diagram=utils.draw-uc-diagram(
                system-name: "Sistema core",
  target-uc: use-case-nome,
  actors: ("Companion",),
  ext-actors: (),
  includes: (
        "inserimento query linked",
        "Ricezione risultati ricerca linked"
        ),
  extends: (
        // "Inserimento query su singola entità non valida":[Companion inserisce una query non valida],
        "Errore ricerca linked":[Nel sistema si è verificato un errore durante la ricerca],
        ),  generalizations: (
        "Ricerca linked full-text",
        "Ricerca linked semantica",
        "Ricerca linked ibrida",
  ),
  spacing: (0.5cm, 2cm),
  width: 100%,
  max-height: none,
  actor-offset: 3,
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
                - Companion ha ricevuto i risultati della ricerca.
//                - Companion riceve l'identificativo del chunk su cui è stato trovato il match
//                - Companion riceve solo il chunk di testo su cui è stato trovato un match
                        ],
        scenario-principale:[
                + Companion inserisce una query #sym.arrow #utils.uc-link("Inserimento query linked")
                + Il sistema valida la query
                + Il sistema esegue la query
                + Companion riceve i risultati #sym.arrow #utils.uc-link("ricezione risultati ricerca linked")
        ],
        scenari-alternativi:[
                - Errore durante la ricerca #sym.arrow #utils.uc-link("Errore ricerca linked")
        ],
        trigger: [Companion vuole eseguire una ricerca su tutte le entità],
        inclusioni: [
                - #utils.uc-link("Inserimento query linked")
                - #utils.uc-link("ricezione risultati ricerca linked")
        ],
        estensioni: [
                - #utils.uc-link("Errore ricerca linked")

        ],
        specializzazioni: [
                - #utils.uc-link("Ricerca linked full-text")
                - #utils.uc-link("Ricerca linked semantica")
                - #utils.uc-link("Ricerca linked ibrida")
        ],
        immagine: diagram,
        caption: none,
)
