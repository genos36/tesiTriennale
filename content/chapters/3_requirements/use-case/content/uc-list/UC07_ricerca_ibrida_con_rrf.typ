#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Ricerca ibrida con RRF"
// #let depth=

#use-case(
        codice: get-use-case-code(use-case-nome),
        nome: use-case-nome,
        attore-principale:[Companion],
        attore-secondario: none,
        pre-condizioni:[
                - Il sistema di ricerca è attivo
        ],
        post-condizioni: [
                - Companion ha ricevuto i risultati della ricerca
                        ],
        scenario-principale:[
                + Companion inserisce una query #sym.arrow #utils.uc-link("Inserimento query su singola entità")
                + Companion può inserire i pesi da utilizzare durante la fusione di ricerca full-text e semantica  #sym.arrow #utils.uc-link("Aggiunta pesi di fusione ricerca singola entità")
                + Il sistema di ricerca utilizza il modello di embedding per calcolare il vettore di embedding da usare durante la ricerca
                + Il sistema di ricerca esegue la query valutando la pertinenza in base alla ricerca semantica
                + Il sistema di ricerca esegue la query valutando la pertinenza in base alla ricerca full-text
                + Il sistema di ricerca fonde i risultati tramite RRF
                + Companion riceve i risultati #sym.arrow #utils.uc-link("ricezione risultati ricerca singola entità")
        ],
        scenari-alternativi:none,
        trigger: [Companion vuole eseguire una ricerca ibrida su una singola entità],
        inclusioni: none,
        estensioni: none,
        specializzazioni: none,
        immagine: none,
        caption: none,
)
