#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Ricerca full text"
// #let depth=


#use-case(
        codice: get-use-case-code(use-case-nome),
        nome: use-case-nome,
        attore-principale:[Companion],
        attore-secondario: none,
        pre-condizioni:[
                - Il sistema è attivo
        ],
        post-condizioni: [
                - Companion ha ricevuto i risultati della ricerca.
                // - Companion riceve l'identificativo del chunk su cui è stato trovato il match
                // - Companion riceve solo il chunk di testo su cui è stato trovato un match
                        ],
        scenario-principale:[
                + Companion inserisce una query #sym.arrow #utils.uc-link("Inserimento query su singola entità")
                + Il sistema esegue la query valutando la pertinenza in base alla ricerca full text
                + Il sistema può ottimizzare la ricerca basandosi sulla lingua
                + Companion riceve i risultati #sym.arrow #utils.uc-link("ricezione risultati ricerca singola entità")
        ],
        scenari-alternativi:none,
        trigger: [Companion vuole eseguire una ricerca full-text su una singola entità],
        inclusioni: none,
        estensioni: none,
        specializzazioni: none,
        immagine: none,
        caption: none,
)
