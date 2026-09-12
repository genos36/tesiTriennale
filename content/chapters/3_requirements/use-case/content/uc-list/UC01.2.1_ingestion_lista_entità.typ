#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Ingestion lista entità"
// #let depth=
#let diagram=none


#if utils.debug == true{
        diagram=utils.draw-uc-expansion(
                system-name: "Sistema di ricerca"
,  parent-uc: "Ingestion liste entità",             // Nome mostrato sulla linguetta; default = target-uc
  target-uc: use-case-nome,
  actors: ("Companion",),
  ext-actors: (),
  includes: ("Caricamento blocco entità",),
  extends: (:),
  generalizations: (
        "Ingestion lista ticket",
        "Ingestion lista conversation item",
        "Ingestion lista attachment"),
  spacing: (0.5cm, 3cm),
  width: 100%,
  max-height: none,
  actor-offset: 3,
  ext-actor-offset: 0.9,
  note-offset: (1, 0.6),
  tab-offset: (-25pt, -25pt),
  top-padding: 0.8,
        )
}
#use-case(
        alt-diagramma:"Questo diagramma dei casi d'uso rappresenta il caricamento e l'elaborazione di una singola lista di entità",
        codice: get-use-case-code(use-case-nome),
        nome: use-case-nome,
        attore-principale:[Companion],
        attore-secondario: none,
        pre-condizioni:[
                - Nel sistema di ricerca è attiva una sessione di ingestion
        ],
        post-condizioni: [
                - Il sistema di ricerca ha salvato le informazioni relative alla lista di entità
                - Il sistema di ricerca ha salvato gli embedding relativi alla lista di entità
                - Il sistema di ricerca ha salvato le informazioni di lingua relative alla lista di entità
                        ],
        scenario-principale:[
                + Companion carica la lista di entità
                        + Companion carica un blocco di entità #sym.arrow #utils.uc-link("Caricamento blocco entità")
        ],
        scenari-alternativi:none,
        trigger: none,
        inclusioni: [
                - #utils.uc-link("Caricamento blocco entità")
        ],
        estensioni: none,
        specializzazioni: [
        - #utils.uc-link("Ingestion lista ticket")
        - #utils.uc-link("Ingestion lista conversation item")
        - #utils.uc-link("Ingestion lista attachment")
        ],
        immagine: diagram,
        caption: none,
)
