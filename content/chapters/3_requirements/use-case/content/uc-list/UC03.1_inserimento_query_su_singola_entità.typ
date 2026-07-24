#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Inserimento query su singola entità"
// #let depth=

#use-case(
        codice: get-use-case-code(use-case-nome),
        nome: use-case-nome,
        attore-principale:[],
        attore-secondario: none,
        pre-condizioni:[
                - Nel sistema è stata avviata una query di ricerca su una singola entità
                - La query di ricerca specifica un'entità valida per la ricerca
                - La query di ricerca contiene le informazioni da recuperare
                - La query di ricerca contiene il numero di risultati da restituire.
                - La query di ricerca contiene le informazioni su cui filtrare
                - La query di ricerca contiene il testo da usare per valutare la pertinenza dei dati sul sistema di pertinenza
                - La query di ricerca contiene l'informazione sulla presenza della lingua
                
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
