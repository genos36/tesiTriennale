#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Ingestione lista conversation item"
// #let depth=

#let diagram=none


#if utils.debug == true{
        diagram=utils.draw-uc-expansion(
                system-name: "Sistema core - API"
,  parent-uc: "Ingestion di documenti",             // Nome mostrato sulla linguetta; default = target-uc
  target-uc: use-case-nome,
  actors: ("Companion",),
  ext-actors: (),
  includes: ("Carica blocco conversation item",),
  extends: (:),
  generalizations: (),
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
                - Il processo di ingestione dei file è stato avviato
        ],
        post-condizioni: [
                - Le informazioni relative alla lista di conversation item sono state salvate nel sistema 
                - Gli embedding relativi alla lista di conversation item sono salvati nel sistema
                - Le informazioni di lingua alla lista di conversation item sono salvate nel sistema
                        ],
        scenario-principale:[
                + Companion carica la lista dei conversation item
                        + Companion carica un blocco di conversation item
        ],
        scenari-alternativi:none,
        trigger: none,
        inclusioni: [
                - #utils.uc-link("Carica blocco conversation item")
        ],
        estensioni: none,
        specializzazioni: none,
        immagine: diagram,
        caption: none,
)
