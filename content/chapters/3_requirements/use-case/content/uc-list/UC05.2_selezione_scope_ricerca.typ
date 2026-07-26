#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Selezione scope ricerca"
// #let depth=
#let diagram=none


#if utils.debug == true{
        diagram=utils.draw-uc-expansion(
                system-name:"Benchmark-Frontend",
  parent-uc: "aggiungi query di test",             // Nome mostrato sulla linguetta; default = target-uc
  target-uc: use-case-nome,
  actors: ("Supervisore",),
  ext-actors: (),
  includes: (),
  extends: (:),
  generalizations: (
        "selezione ricerca su singola entità",
        "selezione ricerca linked",
        
  ),
  spacing: (4cm, 1cm),
  width: 100%,
  max-height: none,
  actor-offset: 0.1,
  ext-actor-offset: 0,
  note-offset: (1, 0.6),
  tab-offset: (-25pt, -25pt),
  top-padding: 1,   
        )
}
#use-case(
        codice: get-use-case-code(use-case-nome),
        nome: use-case-nome,
        attore-principale:[Supervisore],
        attore-secondario: none,
        pre-condizioni:[
                - Nel sistema è in corso l'aggiunta di una query di test
        ],
        post-condizioni: [
                - Il sistema ha registrato lo scope della ricerca
                        ],
        scenario-principale:[
                + Il supervisore seleziona lo scope della ricerca
        ],
        scenari-alternativi:none,
        trigger: none,
        inclusioni: none,
        estensioni: none,
        specializzazioni: [
                - #utils.uc-link("Selezione ricerca su singola entità")
                - #utils.uc-link("Selezione ricerca linked ")
        ],
        immagine: diagram,
        caption: none,
)
