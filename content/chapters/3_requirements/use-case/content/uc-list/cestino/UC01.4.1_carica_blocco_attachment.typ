#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Carica blocco attachment"
// #let depth=
#let diagram=none


#if utils.debug == true{
        diagram=utils.draw-uc-expansion(
                system-name:"Sistema core - API",
  parent-uc: "Ingestione lista attachments",             // Nome mostrato sulla linguetta; default = target-uc
  target-uc: use-case-nome,
  actors: ("Companion",),
  ext-actors: (
        "Modello di embedding",
        "Modello di language detection",
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
        codice: get-use-case-code(use-case-nome),
        nome: use-case-nome,
        attore-principale:[Companion],
        attore-secondario: [
                - Modello di embedding
                - Modello di language detection
        ],
        pre-condizioni:[
                - Il processo di caricamento dei ticket è in corso
                // - N è una costante nota al sistema
                // - Il blocco da salvare contiene massimo N ticket
                // - I ticket contengono i loro metadati
                // - I ticket contengono i campi testuali divisi in chunk.
        ],
        post-condizioni: [
                - Il sistema ha salvato le informazioni relative al blocco di ticket  
                - Il sistema ha salvato gli embedding relativi al blocco di ticket
                - Il sistema ha salvato le informazioni di lingua relative al blocco di ticket
                        ],
        scenario-principale:[
                + Companion carica un blocco di ticket
                + Il sistema salva i dati dei ticket
                + Il sistema calcola l'embedding da associare ai chunk usando il modello di embedding
                + Il sistema rileva le informazioni di lingua da applicare ai chunk
                        + Il sistema può usare l'informazione linguistica presente nei dati caricati
                        + Il sistema può usare un modello language detection
                + Il sistema associa gli embedding al relativo frammento di testo
                + Il sistema associa la lingua al relativo frammento di testo
                + Il sistema salva il blocco di ticket
        ],
        scenari-alternativi:none,
        trigger: none,
        inclusioni: none,
        estensioni: none,
        specializzazioni: none,
        immagine: diagram,
        caption: none,
)
