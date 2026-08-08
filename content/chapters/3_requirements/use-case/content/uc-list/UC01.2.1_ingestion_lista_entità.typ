#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Ingestion lista entità"
// #let depth=
#let diagram=none


#if utils.debug == true{
        diagram=utils.draw-uc-expansion(
                system-name: "Sistema core - API"
,  parent-uc: "Ingestion liste entità",             // Nome mostrato sulla linguetta; default = target-uc
  target-uc: use-case-nome,
  actors: ("Companion",),
  ext-actors: (),
  includes: ("caricamento blocco entità",),
  extends: (:),
  generalizations: (        "Ingestione lista ticket",
        "Ingestione lista conversation item",
        "Ingestione lista attachments"),
  spacing: (4cm, 3cm),
  width: 100%,
  max-height: none,
  actor-offset: 0,
  ext-actor-offset: 0.9,
  note-offset: (1, 0.6),
  tab-offset: (-25pt, -25pt),
  top-padding: 0.1,   
        )
}
#use-case(
        codice: get-use-case-code(use-case-nome),
        nome: use-case-nome,
        attore-principale:[Companion],
        attore-secondario: none,
        pre-condizioni:[
                - Nel sistema è attiva una sessione di ingestion
        ],
        post-condizioni: [
                - Il sistema ha salvato le informazioni relative alla lista di entità  
                - Il sistema ha salvato gli embedding relativi alla lista di entità 
                - Il sistema ha salvato le informazioni di lingua relative alla lista di entità 
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
        - #utils.uc-link("Ingestione lista ticket")
        - #utils.uc-link("Ingestione lista conversation item")
        - #utils.uc-link("Ingestione lista attachments")
        ],
        immagine: diagram,
        caption: none,
)
