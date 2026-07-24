#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Aggiungi query di test"
// #let depth=

#use-case(
        codice: get-use-case-code(use-case-nome),
        nome: use-case-nome,
        attore-principale:[Supervisore],
        attore-secondario: none,
        pre-condizioni:[
                - Il sistema è attivo
        ],
        post-condizioni: [
                - Il sistema ha aggiunto la query di test al sistema
                        ],

        scenario-principale:[
                + Il supervisore seleziona il tipo di ricerca da eseguire
                + Il supervisore seleziona lo scope della ricerca da eseguire 
                + Il supervisore inserisce i campi di ritorno

                + Il supervisore inserisce il filtro di ricerca 

                + Il supervisore configura i criteri di similarità per la ricerca

                + Il supervisore inserisce la lista dei match per la valutazione dei risultati della query


        ],
        scenari-alternativi:
        [
                - Query non valida
        ],
        trigger: [
                Il supervisore vuole aggiungere una query di test
        ],
        inclusioni: [
                - #utils.uc-link("Selezione tipo ricerca")
                - #utils.uc-link("Selezione scope ricerca")
                - #utils.uc-link("Inserimento lista campi di ritorno")
                - #utils.uc-link("Inserimento filtri di ricerca")
                - #utils.uc-link("Configurazione dei criteri di similarità")
                - #utils.uc-link("Inserimento dei match corretti")
        ],
        estensioni: none,
        specializzazioni: none,
        immagine: none,
        caption: none,
)
