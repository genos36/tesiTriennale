#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Avvia test"
// #let depth=
#let diagram=none


#if utils.debug == true{
        diagram=utils.draw-uc-diagram(
                system-name:"Sistema di test",
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
        alt-diagramma:"Questo diagramma dei casi d'uso rappresenta il processo di avvio di una sessione di test",
        codice: get-use-case-code(use-case-nome),
        nome: use-case-nome,
        attore-principale:[Supervisore],
        attore-secondario: none,
        pre-condizioni:[
                - Il sistema di test è attivo
                - Il sistema di ricerca è attivo
                - Nel sistema di test non ci sono altre run di test attive
        ],
        post-condizioni: [
                - Il sistema di test ha avviato l'esecuzione delle ricerche di test
                        ],
        scenario-principale:[
                + Il supervisore seleziona l'avvio dei test
                + Il sistema di test avvia i test
        ],
        scenari-alternativi:none,
        trigger: "Il supervisore vuole avviare un test di performance",
        inclusioni: none,
        estensioni: none,
        specializzazioni: none,
        immagine: utils.image-path(use-case-nome),
        caption: none,
)
