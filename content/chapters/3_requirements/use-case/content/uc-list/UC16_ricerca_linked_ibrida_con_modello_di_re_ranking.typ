#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Ricerca linked ibrida con modello di reranking"
// #let depth=
#let diagram=none


#if utils.debug == true{
        diagram=utils.draw-uc-expansion(
                system-name:"Sistema di ricerca",
  parent-uc: "Ricerca linked ibrida",             // Nome mostrato sulla linguetta; default = target-uc
  target-uc: use-case-nome,
  actors: ("Companion",),
  ext-actors: (
        "Modello di reranking",
  ),
  includes: (),
  extends: (:),
  generalizations: (),
  spacing: (4cm, 3cm),
  width: 100%,
  max-height: none,
  actor-offset: 0,
  ext-actor-offset: 0,
  note-offset: (1, 0.6),
  tab-offset: (-25pt, -25pt),
  top-padding: 0.1,
        )
}
#use-case(
        alt-diagramma:"Questo diagramma dei casi d'uso rappresenta la realizzazione della ricerca ibrida linked con modello di reranking esterno",
        codice: get-use-case-code(use-case-nome),
        nome: use-case-nome,
        attore-principale:[Companion],
        attore-secondario: "Modello di reranking",
        pre-condizioni:[
                - Il sistema di ricerca è attivo
        ],
        post-condizioni: [
                - Companion ha ricevuto i risultati della ricerca
//                - Companion riceve l'identificativo del chunk su cui è stato trovato il match
//                - Companion riceve solo il chunk di testo su cui è stato trovato un match
],
        scenario-principale:[
                + Companion inserisce una query #sym.arrow #utils.uc-link("Inserimento query linked")
                + Companion inserisce i pesi da usare durante la fusione dei risultati di ricerca semantica e full-text #sym.arrow #utils.uc-link("Aggiunta pesi di fusione ricerca linked")
                + Il sistema di ricerca utilizza il modello di embedding per calcolare il vettore di embedding da usare durante la ricerca
                + Il sistema di ricerca esegue la query valutando la pertinenza in base alla ricerca semantica
                + Il sistema di ricerca esegue la query valutando la pertinenza in base alla ricerca full-text
                + Il sistema di ricerca fonde i risultati tramite un modello di reranking
                + Companion riceve i risultati #sym.arrow #utils.uc-link("ricezione risultati ricerca linked")
        ],
        scenari-alternativi:none,
        trigger: [Companion vuole eseguire una ricerca ibrida su tutte le entità usando una combinazione dei risultati basata su modello di reranking],
        inclusioni: none,
        estensioni: none,
        specializzazioni: none,
        immagine: utils.image-path(use-case-nome),
        caption: none,
)
