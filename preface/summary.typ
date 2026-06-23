#import "/metadata/mod.typ": data
#import "/plugin/mod.typ": code-snippet, gl
#import "/plugin/glossary/glossary-style.typ": glossary-style

#pagebreak(to: "odd")
#v(4em)

// Usiamo data.abstract per recuperare la traduzione corretta
#text(24pt, weight: "semibold", data.abstract)

#v(1em)
Il presente documento descrive il lavoro svolto durante il periodo di stage curricolare, della durata di circa trecentoventi ore, dal laureando #data.myName presso l'azienda #data.myCompany. Lo stage è stato condotto sotto la supervisione del tutor aziendale #data.myTutor, mentre il prof. #data.myProf ha ricoperto il ruolo di tutor accademico.

\ \

Al centro di questo elaborato vi è la progettazione e lo sviluppo di un sistema #gl("rag"). Questa architettura è oggi fondamentale poiché permette agli #gl("llm") di accedere a basi di conoscenza private e informazioni aggiornate senza la necessità di ricorrere a costosi processi di retraining, abbattendo drasticamente il rischio di allucinazioni da parte dell'Intelligenza Artificiale.
\ \
Lo scopo principale del progetto è valutare l'adeguatezza, la fattibilità tecnica e le performance dell'estensione #gl("pgvector") per PostgreSQL, impiegandola come database unificato per l'intera pipeline RAG. Nello specifico, l'obiettivo è verificare se tale tecnologia possa supportare efficacemente l'indicizzazione dei documenti, la ricerca ibrida (combinando ricerca full-text e semantica), l'applicazione di strategie di ranking avanzate e la correlazione relazionale con entità strutturate.
\ \
Per convalidare questa ipotesi e fornire una misura rigorosa della qualità del sistema, l'infrastruttura progettata verrà sistematicamente sottoposta a test comparativi contro una pipeline equivalente basata su #gl("elasticsearch"), tecnologia attualmente adottata all'interno dell'impresa.
\ \
L'utilità e il valore aggiunto di questa ricerca risiedono nella potenziale semplificazione dell'infrastruttura IT aziendale. Gestire dati relazionali, testuali e vettoriali all'interno di un unico ecosistema (il database unificato) permetterebbe di superare il paradigma della persistenza poliglotta, eliminando la necessità di mantenere sistemi separati. Questo approccio promette di abbattere l'overhead di sincronizzazione dei dati, ridurre i costi di manutenzione sistemistica e garantire transazioni più sicure.

Sono previsti test comparativi tra il nuovo sistema e il sistema attualmente in uso.

#linebreak()
#text(24pt, weight: "semibold")[Organizzazione del testo]
#linebreak()
#v(1em)

/ #link(
    <cap:introduzione>,
  )[Il primo capitolo]: introduce l'azienda, il progetto e le motivazioni che mi hanno portato a sceglierlo;
/ #link(
    <cap:descrizione-stage>,
  )[Il secondo capitolo]: descrive l'azienda, il progetto e l'organizzazione del lavoro, definendo gli obiettivi e analizzando i rischi;
/ #link(
    <cap:analisi-requisiti>,
  )[Il terzo capitolo]: descrive l’analisi dei requisiti del progetto, indicando un’analisi degli utenti, i casi d’uso e il tracciamento dei requisiti;
/ #link(
    <cap:introduzione-teorica>,
  )[Il quarto capitolo]: descrive le tecnologie esistenti per risolvere i problemi indicando gli aspetti teorici alla base, gli strumenti che sono stati scelti e con quali criteri;
/ #link(
    <cap:lavoro-svolto>,
  )[Il quinto capitolo]: descrive nel dettaglio le problematiche sorte nel concreto durante lo svolgimento del progetto;
/ #link(
    <cap:conclusioni>,
  )[Il sesto capitolo]: raggruppa le conclusioni tratte dallo svolgimento del progetto.
#linebreak()
#text(24pt, weight: "semibold", "Convenzioni tipografiche")
#linebreak()
#v(1em)
Durante la stesura del testo ho scelto di adottare le seguenti convenzioni tipografiche:

// Preferenze personali modificabili a discrezione tua o del relatore
- Gli acronimi, le abbreviazioni e i termini di uso non comune menzionati vengono definiti nel #link(<glossary>)[glossario], situato alla fine del documento (#link(<glossary>)[p. #context counter(page).at(<glossary>).at(0)]);
- Per la prima occorrenza dei termini riportati nel glossario viene utilizzata la seguente nomenclatura: #glossary-style("Termine"); // <-- Usa direttamente l'Adapter!
- I termini in lingua straniera non di uso comune o facenti parti del gergo tecnico sono evidenziati con il carattere _corsivo_;
- I nomi di funzioni o variabili appartenenti ad un linguaggio di programmazione vengono scritte con un carattere `monospaziato`;
- Le citazioni ad un libro o ad una risorsa presente nella #link(<bibliography>)[bibliografia] (#link(<bibliography>)[p. #context counter(page).at(<bibliography>).at(0)]) saranno affiancate dal rispettivo numero identificativo, es. [1];
- I blocchi di codice sono rappresentati nel seguente modo:

// Usiamo il nostro Adapter personalizzato per i blocchi di codice!
#code-snippet(caption: "Codice d'esempio.")[
  #raw(
    lang: "c",
    block: true,
    "float Q_rsqrt( float number ){
            long i;
            float x2, y;
            const float threehalfs = 1.5F;
            x2 = number * 0.5F;
            y  = number;
            i  = * (long * ) &y;
            i  = 0x5f3759df - (i>>1);
            y  = * (float * ) &i;
            y  = y * ( threehalfs - ( x2 * y * y ) );
            //y  = y * ( threehalfs - ( x2 * y * y ) );
            return y;
        }",
  )
]
