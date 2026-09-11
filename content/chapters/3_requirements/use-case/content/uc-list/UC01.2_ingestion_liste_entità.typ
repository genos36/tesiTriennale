#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Ingestion liste entità"
// #let depth=
#let diagram=none


#if utils.debug == true{
        diagram=utils.draw-uc-expansion(
                system-name:"Sistema di ricerca",
  parent-uc: "Ingestion di documenti",             // Nome mostrato sulla linguetta; default = target-uc
  target-uc: use-case-nome,
  actors: ("Companion",),
  ext-actors: (),
  includes: ("Ingestion lista entità",),
  extends: (:),
  generalizations: (),
  spacing: (3.5cm, 0.5cm),
  width: 100%,
  max-height: none,
  actor-offset: 0,
  ext-actor-offset: 0,
  note-offset: (-1, 0.6),
  tab-offset: (-25pt, -25pt),
  top-padding: 1.0,
        )
}
#use-case(
        alt-diagramma:"Questo diagramma descrive il caricamento delle varie liste di entità del modello dati",
        codice: get-use-case-code(use-case-nome),
        nome: use-case-nome,
        attore-principale:[Companion],
        attore-secondario: none,
        pre-condizioni:[
                - Nel sistema di ricerca è attiva una sessione di ingestion
        ],
        post-condizioni: [
                - Il sistema di ricerca ha salvato le informazioni relative alle liste di entità
                - Il sistema di ricerca ha salvato gli embedding relativi alle liste di entità
                - Il sistema di ricerca ha salvato le informazioni di lingua relative alle liste di entità
                        ],
        scenario-principale:[
                + Companion carica le liste di entità
                        + Companion carica una lista di entità #sym.arrow #utils.uc-link("ingestion lista entità")
        ],
        scenari-alternativi:none,
        trigger: none,
        inclusioni: [
                - #utils.uc-link("ingestion lista entità")
        ],
        estensioni: none,
        specializzazioni: none,
        immagine: diagram,
        caption: none,
)
