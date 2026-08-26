#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Ricerca ibrida"
// #let depth=
#let diagram=none


#if utils.debug == true{
        diagram=utils.draw-uc-expansion(
                system-name:"Sistema core",
  parent-uc: "ricerca su singola entità",             // Nome mostrato sulla linguetta; default = target-uc
  target-uc: use-case-nome,
  actors: ("Companion",),
  ext-actors: (
        "Modello di embedding",
  ),
  includes: ("Aggiunta pesi di fusione ricerca singola entità",),
  extends: (:),
  generalizations: (
        "Ricerca ibrida con rrf",
        "Ricerca ibrida con modello di re ranking",
  ),
  spacing: (2cm, 3cm),
  width: 100%,
  max-height: none,
  actor-offset: 0,
  ext-actor-offset: (1,-0.7),
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
//                - Companion riceve l'identificativo del chunk su cui è stato trovato il match
//                - Companion riceve solo il chunk di testo su cui è stato trovato un match
                        ],
        scenario-principale:[
                + Companion inserisce una query #sym.arrow #utils.uc-link("Inserimento query su singola entità")
                + Companion può inserire i pesi da utilizzare durante la fusione di ricerca full-text e semantica  #sym.arrow #utils.uc-link("Aggiunta pesi di fusione ricerca singola entità")
                + Il sistema esegue la query valutando la pertinenza in base alla ricerca semantica
                + Il sistema esegue la query valutando la pertinenza in base alla ricerca full-text
                + Il sistema fonde i risultati                
                + Companion riceve i risultati #sym.arrow #utils.uc-link("ricezione risultati ricerca singola entità")
        ],
        scenari-alternativi:none,
        trigger: [Companion vuole eseguire una ricerca su una singola entità],
        inclusioni: [
                - #utils.uc-link("Aggiunta pesi di fusione ricerca singola entità")
        ],
        estensioni: none,
        specializzazioni: [
                - #utils.uc-link("Ricerca ibrida con rrf")
                - #utils.uc-link("Ricerca ibrida con modello di re ranking")
        ],
        immagine: diagram,
        caption: none,
)