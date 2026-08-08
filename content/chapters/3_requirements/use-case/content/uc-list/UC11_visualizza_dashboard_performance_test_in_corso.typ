#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Visualizza dashboard performance test in corso"
// #let depth=

#use-case(
        codice: get-use-case-code(use-case-nome),
        nome: use-case-nome,
        attore-principale:[Supervisore],
        attore-secondario: none,
        pre-condizioni:[
                - Il sistema è attivo
                - Nel sistema è in corso una run di test
        ],
        post-condizioni: [
                - Il supervisore ha visualizzato lo stato in tempo reale dell'ultima run di test avviata 
                        ],
        scenario-principale:[
                + Il sistema mantiene aggiornata la dashboard
                + Il supervisore visualizza l'id della run di test #sym.arrow #utils.uc-link("Visualizza id run test")
                + Il supervisore visualizza la lista delle metriche #sym.arrow #utils.uc-link("Visualizza metriche di performance")
        ],
        scenari-alternativi:[
                - Nel sistema non vi sono run di test registrate #sym.arrow #utils.uc-link("Nessuna run di test trovata")
        ],
        trigger: none,
        inclusioni: none,
        estensioni:none,
        specializzazioni: none,
        immagine: none,
        caption: none,
)
