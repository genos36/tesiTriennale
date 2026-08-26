#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Visualizza dashboard performance"
// #let depth=
#let diagram=none


#if utils.debug == true{
        diagram=utils.draw-uc-diagram(
                system-name:"Sistema test",
  target-uc: use-case-nome,
  actors: ("Supervisore",),
  ext-actors: (),
  includes: (
        "Visualizza id run test",
        "Visualizza metriche di performance",
  ),
  extends: ("Nessuna run di test trovata":[
        Nel sistema non sono presenti run di test registrate
  ]),
  generalizations: (
        "Visualizza dashboard performance test in corso",
        "Visualizza dashboard performance test terminato",
  ),
  spacing: (4cm, 3cm),
  width: 100%,
  max-height: none,
  actor-offset: 0,
  ext-actor-offset: 0,
  note-offset: (1, -0.6),
        )
}
#use-case(
        codice: get-use-case-code(use-case-nome),
        nome: use-case-nome,
        attore-principale:[Supervisore],
        attore-secondario: none,
        pre-condizioni:[
                - Il sistema di test è attivo
                - Il sistema core è attivo        ],
        post-condizioni: [
                - Il supervisore ha visualizzato lo stato dell'ultima run di test avviata
                        ],
        scenario-principale:[
                + Il supervisore visualizza l'id della run di test #sym.arrow #utils.uc-link("Visualizza id run test")
                + Il supervisore visualizza la lista delle metriche #sym.arrow #utils.uc-link("Visualizza metriche di performance")
        ],
        scenari-alternativi:[
                - Nel sistema non vi sono run di test registrate #sym.arrow #utils.uc-link("Nessuna run di test trovata")
        ],
        trigger: none,
        inclusioni: [
                - #utils.uc-link("Visualizza id run test")
                - #utils.uc-link("Visualizza metriche di performance")
        ],
        estensioni: [
                - #utils.uc-link("Nessuna run di test trovata")
        ],
        specializzazioni: [
                - #utils.uc-link("Visualizza dashboard performance test in corso")
                - #utils.uc-link("Visualizza dashboard performance test terminato")
        ],
        immagine: diagram,
        caption: none,
)
