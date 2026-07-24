#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Inserimento query linked"
// #let depth=

#use-case(
        codice: get-use-case-code(use-case-nome),
        nome: use-case-nome,
        attore-principale:[],
        attore-secondario: none,
        pre-condizioni:[
                - Nel sistema è stata avviata una query di ricerca linked
                - La query di ricerca contiene le informazioni da recuperare
                - Le informazioni da recuperare sono marcate con la relativa entità
                - La query di ricerca contiene il numero di risultati da restituire.
                - La query di ricerca contiene le informazioni su cui filtrare
                - La query di ricerca contiene il testo da usare per valutare la pertinenza dei dati sul sistema di pertinenza
                - La query di ricerca contiene la lingua del testo da usare per valutare la pertinenza dei dati sul sistema di pertinenza
                
        ],
        post-condizioni: [
                - Il sistema ha elaborato la query
                        ],
        scenario-principale:[
                + Companion inserisce la query di ricerca
        ],
        scenari-alternativi:none,
        trigger: none,
        inclusioni: none,
        estensioni: none,
        specializzazioni: none,
        immagine: none,
        caption: none,
)
