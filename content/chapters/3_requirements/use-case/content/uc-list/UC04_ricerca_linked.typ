#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Ricerca linked"
// #let depth=
#let diagram=none


#if utils.debug == true{
        diagram=utils.draw-uc-diagram(
                system-name: "Sistema core - API",
  target-uc: use-case-nome,
  actors: ("Companion",),
  ext-actors: (),
  includes: ("inserimento query linked",),
  extends: (:),
  generalizations: (
        "Ricerca linked full-text",
        "Ricerca linked semantica",
        "Ricerca linked ibrida",
  ),
  spacing: (0.5cm, 3cm),
  width: 100%,
  max-height: none,
  actor-offset: 0,
  ext-actor-offset: 0.9,
  
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
                - Companion riceve l'identificativo del chunk su cui è stato trovato il match
                - Companion riceve solo il chunk di testo su cui è stato trovato un match
                        ],
        scenario-principale:[
                + Companion inserisce una query
                + Il sistema esegue la query
                + Il sistema ritorna i risultati
        ],
        scenari-alternativi:[
                - La ricerca non produce risultati
                - Errore durante la ricerca
        ],
        trigger: [Companion vuole eseguire una ricerca su tutte le entità],
        inclusioni: none,
        estensioni: none,
        specializzazioni: [
                - #utils.uc-link("Ricerca linked full-text")
                - #utils.uc-link("Ricerca linked semantica")
                - #utils.uc-link("Ricerca linked ibrida")
        ],
        immagine: diagram,
        caption: none,
)
