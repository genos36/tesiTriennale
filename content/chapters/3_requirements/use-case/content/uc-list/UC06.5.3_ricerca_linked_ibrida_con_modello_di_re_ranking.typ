#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Ricerca linked ibrida con modello di re ranking"
// #let depth=
#let diagram=none


#if utils.debug == true{
        diagram=utils.draw-uc-expansion(
                system-name:"Sistema core",
  parent-uc: "ricerca ibrida",             // Nome mostrato sulla linguetta; default = target-uc
  target-uc: use-case-nome,
  actors: ("Companion",),
  ext-actors: (
        "Modello di re-ranking",
  ),
  includes: (),
  extends: (:),
  generalizations: (),
  spacing: (4cm, 3cm),
  width: 100%,
  max-height: none,
  actor-offset: 0,
  ext-actor-offset: 0,
  note-offset: (1, 0.6),
  tab-offset: (-25pt, -25pt),
  top-padding: 0.1,   
        )
}
#use-case(
        codice: get-use-case-code(use-case-nome),
        nome: use-case-nome,
        attore-principale:[Companion],
        attore-secondario: "Modello di re-ranking",
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
                + Companion inserisce i pesi da usare durante la fusione dei risultati di ricerca ibrida e full-text #sym.arrow #utils.uc-link("Aggiunta pesi di fusione ricerca linked")
                + Il sistema esegue la query valutando la pertinenza in base alla ricerca semantica
                + Il sistema esegue la query valutando la pertinenza in base alla ricerca full-text
                + Il sistema fonde i risultati tramite un modello di re-ranking
                + Companion riceve i risultati #sym.arrow #utils.uc-link("ricezione risultati ricerca linked")
        ],
        scenari-alternativi:none,
        trigger: [Companion vuole eseguire una ricerca su una singola entità],
        inclusioni: none,
        estensioni: none,
        specializzazioni: none,
        immagine: diagram,
        caption: none,
)
