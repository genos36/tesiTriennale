#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Avvia test"
// #let depth=
#let diagram=none


#if utils.debug == true{
        diagram=utils.draw-uc-diagram(
                system-name:"Sistema test - API",
  target-uc: use-case-nome,
  actors: ("Supervisore",),
  ext-actors: (),
  includes: (),
  extends: (:),
  generalizations: (),
  spacing: (4cm, 3cm),
  width: 100%,
  max-height: none,
  actor-offset: 0,
  ext-actor-offset: 0,
  note-offset: (1, 0.6),
        )
}
#use-case(
        codice: get-use-case-code(use-case-nome),
        nome: use-case-nome,
        attore-principale:[Supervisore],
        attore-secondario: none,
        pre-condizioni:[
                - Il sistema è attivo
        ],
        post-condizioni: [
                - Il sistema ha avviato l'esecuzione delle ricerche di test
                        ],
        scenario-principale:[
                + Il supervisore seleziona l'avvio dei test
                + Il sistema avvia i test
        ],
        scenari-alternativi:none,
        trigger: "Il supervisore vuole avviare un test di performance",
        inclusioni: none,
        estensioni: none,
        specializzazioni: none,
        immagine: diagram,
        caption: none,
)
