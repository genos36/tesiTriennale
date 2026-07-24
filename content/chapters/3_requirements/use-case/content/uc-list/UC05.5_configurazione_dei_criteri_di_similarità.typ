#import "/content/chapters/3_requirements/use-case/content/deps/utils/utils.typ" as utils: use-case,get-use-case-code


#let use-case-nome="Configurazione dei criteri di similarità"
// #let depth=

#use-case(
        codice: get-use-case-code(use-case-nome),
        nome: use-case-nome,
        attore-principale:[Supervisore],
        attore-secondario: none,
        pre-condizioni:[
                - Nel sistema è in corso l'aggiunta di una query di test
        ],
        post-condizioni: [
                - Il sistema ha registrato i criteri di similarità da applicare durante la ricerca
                        ],
        scenario-principale:[
                + Il supervisore inserisce la lista dei campi su cui eseguire la ricerca di similarità
                + il supervisore inserisce il testo da usare per il confronto e per il calcolo della similarità
                + il supervisore inserisce la lingua da associare al testo
                + Il supervisore inserisce la lista di match corretti
        ],
        scenari-alternativi:
        [
                - Configurazione di similarità non valida
        ],
        trigger: none,
        inclusioni: [
                - #utils.uc-link("Visualizza lista campi ricercabili con similarità")
                - #utils.uc-link("Inserimento testo di confronto")

                ecc...
        ],
        estensioni: none,
        specializzazioni: none,
        immagine: none,
        caption: none,
)
