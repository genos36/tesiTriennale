#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Visualizza metriche di performance"
// #let depth=
#let diagram=none


#if utils.debug == true{
        diagram=utils.draw-uc-expansion(
                system-name:"Sistema core",
  parent-uc: "Visualizza dashboard performance",             // Nome mostrato sulla linguetta; default = target-uc
  target-uc: use-case-nome,
  actors: ("Supervisore",),
  ext-actors: (),
  includes: (
        "Visualizzazione retrieval latency",
        "Visualizzazione retrieval answer rate",
        "Visualizzazione retrieval mrr",
        "Visualizzazione retrieval hitrate@1",
        "Visualizzazione retrieval hitrate@5",
        "Visualizzazione retrieval hitrate@10",
        "Visualizzazione retrieval wins",
        "Visualizzazione not found",
   
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
                - Companion sta visualizzando la dashboard delle metriche
        ],
        post-condizioni: [
                - Il supervisore ha visualizzato la lista delle metriche
                        ],
        scenario-principale:[
                - Il sistema calcola le metriche
                - Il supervisore visualizza l'elenco delle metriche 
                - Il supervisore visualizza la retrieval latency  #sym.arrow #utils.uc-link("Visualizzazione retrieval latency")
                - Il supervisore visualizza la retrieval answer rate #sym.arrow #utils.uc-link("Visualizzazione retrieval answer rate")
                - Il supervisore visualizza la retrieval mrr #sym.arrow #utils.uc-link("Visualizzazione retrieval mrr")
                - Il supervisore visualizza il retrieval hitrate\@1 #sym.arrow #utils.uc-link("Visualizzazione retrieval hitrate@1")
                - Il supervisore visualizza il retrieval hitrate\@5 #sym.arrow #utils.uc-link("Visualizzazione retrieval hitrate@5")
                - Il supervisore visualizza il retrieval hitrate\@10 #sym.arrow #utils.uc-link("Visualizzazione retrieval hitrate@10")
                - Il supervisore visualizza il retrieval wins #sym.arrow #utils.uc-link("Visualizzazione retrieval wins")
                - Il supervisore visualizza il not found #sym.arrow #utils.uc-link("Visualizzazione not found")
        ],
        scenari-alternativi:none,
        trigger: "Il supervisore vuole visualizzare le metriche di performance del sistema di retrieval",
        inclusioni: none,
        estensioni: none,
        specializzazioni: none,
        immagine: diagram,
        caption: none,
)
