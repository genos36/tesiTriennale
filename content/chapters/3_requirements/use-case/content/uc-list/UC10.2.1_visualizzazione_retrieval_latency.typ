#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Visualizzazione retrieval latency"
// #let depth=
#let diagram=none


#if utils.debug == true{
        diagram=utils.draw-uc-expansion(
                system-name:"Sistema test",
  parent-uc: "Visualizzazione retrieval latency ",             // Nome mostrato sulla linguetta; default = target-uc
  target-uc: use-case-nome,
  actors: ("Supervisore",),
  ext-actors: (),
  includes: (
        "Visualizzazione retrieval latency con ingestion attiva",
        "Visualizzazione retrieval latency con ingestion non attiva"
  ),
  extends: (:),
  generalizations: (),
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
        attore-principale:[Supervisore],
        attore-secondario: none,
        pre-condizioni:[
                - Il supervisore sta visualizzando la lista delle metriche
                - Nel sistema sono presenti i dati relativi all'ultimo test svolto o in corso
        ],
        post-condizioni: [
                - Il supervisore ha visualizzato la retrieval latency media
                        ],
        scenario-principale:[
                + Il supervisore visualizza la retrieval latency media calcolata durante la presenza di un processo di ingestion #sym.arrow #utils.uc-link("Visualizzazione retrieval latency con ingestion attiva")
                + Il supervisore visualizza la retrieval latency calcolata media durante l'assenza di un processo di ingestion #sym.arrow #utils.uc-link("Visualizzazione retrieval latency con ingestion non attiva")
        ],
        scenari-alternativi:none,
        trigger: none,
        inclusioni: [
                - #utils.uc-link("Visualizzazione retrieval latency con ingestion attiva")
                - #utils.uc-link("Visualizzazione retrieval latency con ingestion non attiva")
        ],
        estensioni: none,
        specializzazioni: none,
        immagine: diagram,
        caption: none,
)
