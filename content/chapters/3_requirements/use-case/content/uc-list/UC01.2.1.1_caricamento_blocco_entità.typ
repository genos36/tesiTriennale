#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Caricamento blocco entità"
// #let depth=
#let diagram=none


#if utils.debug == true{
        diagram=utils.draw-uc-expansion(
                system-name:"Sistema core",
  parent-uc: "Ingestion lista entità",             // Nome mostrato sulla linguetta; default = target-uc
  target-uc: use-case-nome,
  actors: ("Companion",),
  ext-actors: (
        "Modello di embedding",
  ),
  includes: (),
  extends: ("Fallimento ingestion":"Uno o più record non validi"),
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
        attore-secondario: [Modello di embedding],
        pre-condizioni:[
                - Il processo di caricamento lista di entità è in corso
                // - N è una costante nota al sistema
                // - Il blocco da salvare contiene massimo N entità
                // - I entità contengono i loro metadati
                // - I entità contengono i campi testuali divisi in chunk.
        ],
        post-condizioni: [
                - Il sistema ha salvato le informazioni relative al blocco di entità  
                - Il sistema ha salvato gli embedding relativi al blocco di entità
                - Il sistema ha salvato le informazioni di lingua relative al blocco di entità
                        ],
        scenario-principale:[
                + Companion carica un blocco di entità
                + Il sistema salva i dati dei entità
                + Il sistema calcola l'embedding da associare ai chunk di testo usando il modello di embedding
                + Il sistema rileva le informazioni di lingua da applicare ai chunk
                        + Il sistema può usare l'informazione linguistica presente nei dati caricati
                        + Il sistema può usare rileva la lingua del testo
                + Il sistema associa gli embedding al relativo frammento di testo
                + Il sistema associa la lingua al relativo frammento di testo
                + Il sistema salva il blocco di entità
        ],
        scenari-alternativi:[
                - Uno o più record del blocco non sono validi #sym.arrow #utils.uc-link("Fallimento ingestion")
        ],
        trigger: none,
        inclusioni: none,
        estensioni: [
                - #utils.uc-link("Fallimento ingestion")
        ],
        specializzazioni: none,
        immagine: diagram,
        caption: none,
)
