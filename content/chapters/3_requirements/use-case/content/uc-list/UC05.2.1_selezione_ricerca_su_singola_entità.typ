#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Selezione ricerca su singola entità"
// #let depth=
#let diagram=none


#if utils.debug == true{
        diagram=utils.draw-uc-expansion(
                system-name:"Benchmark-Frontend",
  parent-uc: "selezione ricerca su singola entità",             // Nome mostrato sulla linguetta; default = target-uc
  target-uc: use-case-nome,
  actors: ("Supervisore",),
  ext-actors: (),
  includes: (),
  extends: (:),
  generalizations: (
        "selezione ricerca sui ticket",
        "selezione ricerca sui conversation item",
        "selezione ricerca ",
  ),
  spacing: (1.2cm, 1cm),
  width: 100%,
  max-height: none,
  actor-offset: 9,
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
                + Il supervisore seleziona lo scope ricerca su singola entità
        ],
        scenari-alternativi:none,
        trigger: none,
        inclusioni: none,
        estensioni: none,
        specializzazioni: [
                - #utils.uc-link("Selezione ricerca sui ticket")
                - #utils.uc-link("Selezione ricerca sui conversation item")
                - #utils.uc-link("Selezione ricerca sugli attachment")
        ],
        immagine: none,
        caption: none,
)
