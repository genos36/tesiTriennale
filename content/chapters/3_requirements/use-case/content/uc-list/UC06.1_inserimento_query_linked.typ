#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Inserimento query linked"
// #let depth=
#let diagram=none


#if utils.debug == true{
        diagram=utils.draw-uc-diagram(
                system-name: "Sistema core - API",
  target-uc: use-case-nome,
  actors: ("Companion",),
  ext-actors: (),
  includes: (),
  extends: (
        "Inserimento query linked non valida":[Companion inserisce una query non valida],
        ),
  generalizations: (),
  spacing: (0.5cm, 3cm),
  width: 100%,
  max-height: none,
  actor-offset: 4,
  ext-actor-offset: 0.9,
  note-offset: (2, -0.2),
  
  )
} 
#use-case(
        codice: get-use-case-code(use-case-nome),
        nome: use-case-nome,
        attore-principale:[Companion],
        attore-secondario: none,
        pre-condizioni:[
                - Nel sistema è in corso una ricerca linked
        ],
        post-condizioni: [
                - Il sistema ha elaborato la query
                        ],
        scenario-principale:[
                + Companion inserisce la query di ricerca
        ],
        scenari-alternativi:[
                - Errore query non valida #sym.arrow #utils.uc-link("Inserimento query linked non valida")

        ],
        trigger: none,
        inclusioni: none,
        estensioni: [
                - #utils.uc-link("Inserimento query linked non valida")
        ],
        specializzazioni: none,
        immagine: diagram,
        caption: none,
)
