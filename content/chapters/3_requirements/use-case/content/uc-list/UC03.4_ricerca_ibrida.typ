#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Ricerca ibrida"
// #let depth=
#let diagram=none


#if utils.debug == true{
        diagram=utils.draw-uc-expansion(
                system-name:"Sistema core - API",
  parent-uc: "ricerca su singola entità",             // Nome mostrato sulla linguetta; default = target-uc
  target-uc: use-case-nome,
  actors: ("Companion",),
  ext-actors: (
        "Modello di embedding",
  ),
  includes: (),
  extends: (:),
  generalizations: (
        "Ricerca ibrida con rrf",
        "Ricerca ibrida con modello di re ranking",
  ),
  spacing: (4cm, 3cm),
  width: 100%,
  max-height: none,
  actor-offset: 0,
  ext-actor-offset: 0,
  note-offset: (1, 0.6),
  tab-offset: (-25pt, -25pt),
  top-padding: 0.5,   
        )
}
#use-case(
        codice: get-use-case-code(use-case-nome),
        nome: use-case-nome,
        attore-principale:[Companion],
        attore-secondario:[Modello di embedding],
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
                + Il sistema esegue la query valutando la pertinenza in base alla ricerca semantica
                + Il sistema esegue la query valutando la pertinenza in base alla ricerca full-text
                + Il sistema fonde i risultati
                + Il sistema ritorna i risultati
        ],
        scenari-alternativi:none,
        trigger: [Companion vuole eseguire una ricerca su una singola entità],
        inclusioni: none,
        estensioni: none,
        specializzazioni: [
                - #utils.uc-link("Ricerca ibrida con rrf")
                - #utils.uc-link("Ricerca ibrida con modello di re ranking")
        ],
        immagine: diagram,
        caption: none,
)