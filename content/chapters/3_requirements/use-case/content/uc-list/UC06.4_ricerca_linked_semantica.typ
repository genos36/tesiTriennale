#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Ricerca linked semantica"
// #let depth=
#let diagram=none


#if utils.debug == true{
        diagram=utils.draw-uc-expansion(
                system-name:"Sistema core - API",
  parent-uc: "ricerca linked",             // Nome mostrato sulla linguetta; default = target-uc
  target-uc: use-case-nome,
  actors: ("Companion",),
  ext-actors: (
        "Modello di embedding",
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
        attore-secondario: [Modello di embedding],
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
                + Il sistema esegue la query valutando la pertinenza in base alla ricerca semantica
                + Companion riceve i risultati #sym.arrow #utils.uc-link("ricezione risultati ricerca linked")
        ],
        scenari-alternativi:none,
        trigger: [Companion vuole eseguire una ricerca su tutte le entità],
        inclusioni: none,
        estensioni: none,
        specializzazioni: none,
        immagine: diagram,
        caption: none,
)