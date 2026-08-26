#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Termina ingestion"
// #let depth=
#let diagram=none


#if utils.debug == true{
        diagram=utils.draw-uc-expansion(
                system-name:"Sistema core",
  parent-uc: "Ingestion di documenti",             // Nome mostrato sulla linguetta; default = target-uc
  target-uc: use-case-nome,
  actors: ("Companion",),
  ext-actors: (),
  includes: (),
  extends: ("Errore termine ingestion":"Nel sistema è ancora in corso l'elaborazione dei dati"),
  generalizations: (),
  spacing: (3cm, 3cm),
  width: 100%,
  max-height: none,
  actor-offset: 1.5,
  ext-actor-offset: 0,
  note-offset: (-1, 0.6),
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
                - Nel sistema i dati inseriti sono stati resi disponibili per la ricerca

        ],
        post-condizioni: [
                - Nel sistema viene chiusa la sessione di ingestion
                        ],
        scenario-principale:[
                + Companion chiede il termine della sessione di ingestion
                + Il sistema rende i dati disponibili per la ricerca
                + Il sistema chiude la sessione di ingestion
        ],
        scenari-alternativi:[
                - Nel sistema è ancora in corso l'elaborazione di dati #sym.arrow #utils.uc-link("errore termine ingestion")
        ],
        trigger: none,
        inclusioni: none,
        estensioni: [
                #utils.uc-link("errore termine ingestion")
        ],
        specializzazioni: none,
        immagine: diagram,
        caption: none,
)
