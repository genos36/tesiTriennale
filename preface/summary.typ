#import "/metadata/mod.typ": data
#import "/plugin/mod.typ": code-snippet, gl
#import "/plugin/glossary/glossary-style.typ": glossary-style
#import "/style/components/components.typ": apply-style-internal-ref, apply-style-external-link
#pagebreak(to: "odd")
#v(4em)

// Usiamo data.abstract per recuperare la traduzione corretta
#text(24pt, weight: "semibold", data.abstract)

#v(1em)
Il presente documento descrive il lavoro svolto durante il periodo di stage curricolare, della durata di circa trecentosedici ore, dal laureando #data.myName presso l'azienda #data.myCompany. Lo stage è stato condotto sotto la supervisione del tutor aziendale #data.myTutor, mentre il Prof. #data.myProf ha ricoperto il ruolo di tutor accademico.

\ \
  Al centro di questo elaborato vi è la progettazione e lo sviluppo del modulo di information retrieval basato su ricerca semantica, ricerca full-text e ricerca ibrida.
  Tale modulo è concettualmente destinato a essere utilizzato in un contesto RAG.
\ \
Lo scopo principale del progetto è valutare l'adeguatezza, la fattibilità tecnica e le performance dell'estensione pgvector per Postgres, impiegandola come database unificato. L'obiettivo è verificare se tale tecnologia possa supportare efficacemente l'indicizzazione dei documenti, la ricerca ibrida (combinazione di ricerca full-text e semantica), l'applicazione di strategie di ranking avanzate e la correlazione relazionale con entità strutturate.
In particolare, si valuterà una modalità di ricerca detta linked, che permette di cercare un'informazione all'interno dell'intero database e di ricostruirne il contesto.
\ \
Per convalidare questa ipotesi e fornire una misura della qualità del sistema, l'infrastruttura progettata verrà sottoposta a test di valutazione ed eventualmente test comparativi contro un sistema basato su Elasticsearch, tecnologia attualmente adottata all'interno dell'impresa.

I due sistemi potrebbero non adottare approcci equivalenti qualora pgvector e Postgres permettano di implementare funzionalità utili non attualmente utilizzate sul sistema basato su Elasticsearch.
\ \
Tale progetto è da intendersi come proof of concept con finalità puramente esplorativa e mira a verificare il reale rapporto costi e benefici di un cambiamento dello stack tecnologico.

L'utilità e il valore aggiunto che questa ricerca vuole verificare stanno nella potenziale semplificazione dell'infrastruttura IT aziendale. Gestire dati relazionali, testuali e vettoriali all'interno di un unico ecosistema permetterebbe di eliminare i workaround che implementano concetti relazionali e la necessità di due sistemi di persistenza dei dati che utilizzano linguaggi diversi.
Questo approccio promette di abbattere l'overhead di sincronizzazione dei dati, ridurre i costi di manutenzione sistemistica e garantire transazioni più sicure.

#linebreak()
#text(24pt, weight: "semibold")[Organizzazione del testo]
#linebreak()
#v(1em)

/ #link(
    <cap:introduzione>,
  )[Il primo capitolo]: introduce l'azienda, il progetto e le motivazioni che mi hanno portato a sceglierlo;
/ #link(
    <cap:descrizione-stage>,
  )[Il secondo capitolo]: descrive il progetto e l'organizzazione del lavoro, definendo gli obiettivi e analizzando i rischi;
/ #link(
    <cap:analisi-requisiti>,
  )[Il terzo capitolo]: descrive l'analisi dei requisiti del progetto, indicando un'analisi degli utenti, i casi d'uso e il tracciamento dei requisiti;
/ #link(
    <cap:introduzione-teorica>,
  )[Il quarto capitolo]: descrive le tecnologie usate per risolvere i problemi indicando gli aspetti teorici alla base, gli strumenti che sono stati scelti e con quali criteri;
/ #link(
      <cap:analisi-iniziale>,
  )[Il quinto capitolo]: descrive le fasi iniziali di ricerca, le informazioni così ricavate e come queste hanno influenzato lo sviluppo;
/ #link(
    <cap:lavoro-svolto-search-system>,
  )[Il sesto capitolo]: descrive i punti più significativi dell'implementazione concreta del sistema di ricerca e le problematiche a esso collegate;
/ #link(
    <cap:lavoro-svolto-test-system>,
  )[Il settimo capitolo]: descrive l'implementazione del sistema di test utilizzato per la valutazione, illustrandone le scelte progettuali e le difficoltà incontrate;
/ #link(
    <cap:conclusioni>,
  )[L'ottavo capitolo]: raggruppa le conclusioni tratte dallo svolgimento del progetto.
#linebreak()
#pagebreak(weak:true)
#text(24pt, weight: "semibold", "Convenzioni tipografiche")
#linebreak()
#v(1em)
Durante la stesura del testo ho scelto di adottare le seguenti convenzioni tipografiche:
- Gli acronimi, le abbreviazioni e i termini di uso non comune menzionati vengono definiti nel #link(<glossary>)[glossario], situato alla fine del documento (#link(<glossary>)[p. #context counter(page).at(<glossary>).at(0)]);
- Per la prima occorrenza dei termini riportati nel glossario viene utilizzata la seguente nomenclatura: #glossary-style("Termine")\;
- I nomi di funzioni o variabili appartenenti a un linguaggio di programmazione vengono scritti con un carattere `monospaziato`;
- Le citazioni ad un libro o ad una risorsa presente nella #link(<bibliography>)[bibliografia (p. #context counter(page).at(<bibliography>).at(0))] saranno affiancate dal rispettivo numero identificativo, es. [1];
- I link a fonti esterne al documento sono contraddistinti dal #apply-style-external-link("colore blu e da una sottolineatura")\;
- I link a sezioni, tabelle, figure, codici o altro testo interni al documento sono contraddistinti dal #apply-style-internal-ref("peso semibold e da una sottolineatura")\;
- I blocchi di codice sono rappresentati nel seguente modo:
#code-snippet(caption: "Codice d'esempio")[
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
