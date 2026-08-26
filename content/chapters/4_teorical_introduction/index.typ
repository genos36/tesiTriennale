#import "/plugin/mod.typ": gl, glpl
#import "/metadata/mod.typ": data

#import "/content/chapters/3_requirements/use-case/content/deps/utils/code-set-up.typ": uc-link, uc-link-extended
#import "/content/chapters/3_requirements/requirement/requisiti-vincolo/requisiti-obbligatori/content/deps/code-set-up.typ" : req-link as rcm-link
#pagebreak(to: "odd")

= Introduzione Teorica<cap:introduzione-teorica>
#text(style: "italic", [
  In questo capitolo approfondisco le basi teoriche rilevanti per la realizzazione del progetto, le tecnologie rilevanti per il progetto e relativi ruoli nella risoluzione dei problemi affrontati, quali strumenti sono stati adottati e altri strumenti adottati durante lo sviluppo.
])
#v(1em)

== Contesto e problema <teoria:contesto-problema>

Il progetto ha una finalità esplorativa, mira solo a valutare l'adeguatezza di Postgres come sistema di information retrieval.

L'adeguatezza è valutata secondo due criteri: i tempi di risposta e la qualità del retrieval, misurata tramite metriche di hit rate a diversi livelli di granularità. La definizione completa delle metriche è riportata nel caso d'uso #uc-link-extended("Visualizza metriche di performance",separator: "-").

#upper("è") stato esplicitamente concordato con il tutor aziendale che le metriche relative al consumo di risorse non sono prioritarie per il tirocinio, in quanto una volta effettuato il deployment su server aziendale è già realizzato il tracciamento del consumo di risorse ed è quindi possibile estendere la dashboard Grafana per mostrare anche quello


L'azienda dispone già di un sistema di information retrieval basato su Elasticsearch, tuttavia questo sistema ha delle limitazioni legate alla sua natura non relazionale e orientata ai documenti. Il sistema basato su Postgres mira a replicarne le funzionalità in modo fedele eccetto per alcune deviazioni, indicate nella @limiti-elasticsearch, che rispecchiano quanto realmente voluto dall'azienda ma che non è possibile realizzare nel sistema basato su Elasticsearch 

Per giustificare alcune scelte e capire meglio l'utilità di alcune funzionalità, in particolare della ricerca linked, è utile ricordare che il sistema di information retrieval si colloca dentro un sistema RAG, per ulteriori informazioni si veda @cap:descrizione-stage

#block(breakable: false)[
Come già detto nel requisito #rcm-link("Rispetto modello dati hda") il modello dati di riferimento è quello del ticket service HDA.

Costituito dai seguenti elementi:
- Ticket
- Conversation item
- Attachments 

E dalle seguenti relazioni 1 a molti:
- Ticket #sym.arrow.long Conversation item
- Ticket #sym.arrow.long Attachment
- Conversation item #sym.arrow.long Attachment

]

La ricerca per similarità viene eseguita in due modalità: su singola entità e linked 

La ricerca su singola entità esegue la ricerca solo su una delle entità del modello dati mentre la ricerca linked cerca su tutte le unità del modello e ricostruisce per ogni entità cercata una visione globale del risultato tramite join e poi unisce i dati ottenuti in un unico risultato, il funzionamento dettagliato è descritto in TODO CAP PROGETTAZIONE

=== Limiti di Elasticsearch <limiti-elasticsearch>
Il limite principale di Elasticsearch è la non natività dei join, non nascendo come database relazionale il supporto ai join non è nativo e richiede work-around.

Un altro limite del sistema basato su Elasticsearch è l'impossibilità di eseguire la ricerca per similarità su sottoinsiemi di campi di testo divisi in chunk, questo non è un limite esclusivo di Elasticsearch ma anche dell'applicativo aziendale che lo usa. Tale funzionalità però è implementata per la ricerca full-text.

Per rendere più chiaro in cosa consiste questo limite utilizziamo un esempio, è possibile che si voglia effettuare la ricerca semantica solo sul campo dati Problem o solo sul campo Solution di un ticket, con l'attuale sistema basato su Elasticsearch non è possibile.

Per questo motivo il sistema di ricerca realizzato durante il tirocinio non rispecchierà Elasticsearch sotto questo aspetto, invece si allineerà con il comportamento desiderato dall'impresa.

== Basi teoriche
L'#gl("information-retrieval",long:true) si occupa di individuare, all'interno di una collezione di dati, gli elementi più pertinenti rispetto a una richiesta espressa dall'utente. Nel contesto di questo progetto la richiesta è rappresentata da una query testuale, mentre la collezione può coincidere con i dati di una singola entità del modello oppure con l'insieme delle entità collegate secondo le regole di join configurate.

I risultati restituiti da un sistema di IR non costituiscono un insieme non ordinato, ma una lista ordinata secondo un criterio di rilevanza decrescente, detta #gl("ranking"). Questo concetto è alla base delle metriche di valutazione adottate nel progetto, discusse in @teoria:contesto-problema

Per recuperare i dati da un sistema di information retrieval vengono usate delle funzioni di #gl("similarity-search").

All'interno del progetto vengono usati i seguenti tipi di ricerca per similarità:
#list(
  [
    *ricerca full-text*, usa un criterio di similarità basato sulla corrispondenza di lessemi e parole chiave;
  ],
  [
    *ricerca semantica*, usa un criterio di similarità basato sulla distanza dei vettori di embedding corrispondenti alle frasi confrontate;
  ],
  [
    *ricerca ibrida*, utilizza sia ricerca semantica sia ricerca full-text e ne combina i risultati con tecniche che ne gestiscono la diversa scala di punteggi.
  ]
)

La ricerca ibrida è la tipologia più rilevante ai fini del progetto. Le altre due assumono invece un ruolo secondario, principalmente di supporto al debugging: valutare le query di ricerca full-text e semantica in isolamento permette di individuare più facilmente la causa di un comportamento inaspettato nella ricerca ibrida, che altrimenti ne combinerebbe gli effetti rendendone più difficile l'analisi.

La ricerca ibrida combina i punti di forza della ricerca semantica e di quella full-text. La ricerca semantica non offre buone prestazioni nel keyword matching, punto di forza della ricerca full-text; quest'ultima, di contro, non è in grado di tracciare termini simili ma con forma testuale molto diversa, né di cogliere significati legati al contesto, aspetti in cui la ricerca semantica eccelle.

La combinazione unisce i risultati di entrambe le ricerche, assegnando un punteggio maggiore (boost) a quelli individuati da entrambe, senza scartare i risultati rilevanti prodotti da una sola delle due.

Questa fusione avviene principalmente tramite Reciprocal Rank Fusion (RRF) (casi d'uso #uc-link-extended("Ricerca ibrida con RRF") e #uc-link-extended("Ricerca linked ibrida con RRF")) oppure tramite modelli di re-ranking (casi d'uso #uc-link-extended("Ricerca ibrida con modello di re-ranking") e #uc-link-extended("Ricerca linked ibrida con modello di re-ranking")).

== Architettura del progetto
Ho scelto di separare il progetto in due sistemi distinti e indipendenti: #link(<teoria:main-system>,"sistema principale") e #link(<teoria:test-system>,"sistema di test").

Tale separazione garantisce lo sviluppo e la manutenzione indipendenti dei due sistemi.

=== Sistema principale <teoria:main-system>
Il sistema principale è responsabile dell'implementazione del sistema di information retrieval: offre funzionalità di ingestion dei dati e di ricerca secondo le diverse modalità descritte in @teoria:contesto-problema.

Segue il pattern dell'architettura esagonale per ridurre il rischio che dei bias modellino il sistema in modo da dare un vantaggio ingiusto a Postgres, come indicato dal rischio #link(<r-bias-requisiti>,"R10").

È pensato per l'esecuzione su server.

=== Sistema di test <teoria:test-system>
Il sistema di test ha il ruolo di eseguire i test di performance della ricerca e calcolare le relative metriche. Simula un numero configurabile di utenti paralleli che inviano richieste di ricerca al sistema principale, confronta i risultati ottenuti con la ground truth attesa, e registra query di test, ground truth e risultati su un database dedicato.

Segue anch'esso il pattern dell'architettura esagonale, per coerenza con il sistema principale e per facilitarne la manutenzione.

È pensato per l'esecuzione locale, sulla macchina da cui viene avviato il test.

=== Dashboard Grafana
Nel rispetto del requisito #rcm-link("Utilizzo di grafana") la dashboard per il controllo delle performance è gestita con Grafana.

Legge il database del sistema di test per calcolare le metriche, gestendo automaticamente il refresh e la selezione della dashboard relativa all'esecuzione di test più recente.

Grafana non fa parte dei sistemi applicativi sviluppati: vengono forniti solamente i file YAML e JSON necessari a costruirla.

=== Relazione tra i sistemi
I due sistemi non condividono né codice (eccetto un riuso di tipo copia-incolla, per convenienza) né risorse, e sono sviluppati su repository separati.

Il sistema di test comunica con il sistema principale simulando client esterni che inviano richieste di ricerca, mentre Grafana accede direttamente al database del sistema di test, bypassandolo, per leggerne le metriche.



== Criteri di scelta delle tecnologie 
I criteri di scelta delle tecnologie sono differenti per i due sistemi, per cui vengono approfonditi separatamente nelle sezioni #link(<criteri:main-system>)[sistema principale] e #link(<criteri:test-system>)[sistema di test].
=== Sistema principale <criteri:main-system>
La maggior parte delle tecnologie è fissata dai requisiti di vincolo (@tab:requisiti-vincolo). Sono rimaste come scelte libere la libreria di language detection e la scelta del meccanismo di ricerca full-text.

Per la ricerca full-text, oltre alla soluzione nativa di Postgres basata su tsvector e tsquery, sono state valutate alcune estensioni che la implementano tramite l'algoritmo BM25. I criteri richiesti sono: assenza di problemi di licenza compatibili con l'uso in un prodotto commerciale, e un livello di funzionalità sufficientemente avanzato rispetto alle esigenze del progetto.

Un'altra scelta libera riguarda la libreria utilizzata per il riconoscimento della lingua del testo. Il criterio decisivo non è la compatibilità con la versione di Python utilizzata dal progetto (3.14).

Inoltre si è preferito non adottare librerie di query building, per mantenere il massimo controllo possibile sul codice SQL prodotto e non nasconderne la complessità, coerentemente con il criterio già seguito per l'architettura del sistema (@teoria:main-system).

=== Sistema di test <criteri:test-system>
Non sono stati posti vincoli specifici sulle tecnologie adottate: la scelta è stata guidata dalla loro capacità di soddisfare i requisiti, cercando al contempo di non introdurre tecnologie ulteriori rispetto a quelle già usate nel sistema principale, per non aumentare la curva di apprendimento necessaria allo sviluppo.

== Tecnologie del sistema di ricerca principale
Il progetto è composto da 2 sistemi distinti e indipendenti, perciò i relativi stack tecnologici sono analizzati separatamente nelle sezioni 
#link(<tec:main-system>)[sistema principale] e #link(<tec:test-system>)[sistema principale].

Fanno eccezione Python e Postgres, in quanto comuni ad entrambi gli stack tecnologici.

=== Sistema principale <tec:main-system>
Le tecnologie adottate all'interno del sistema principale sono divise come segue.
=== backend
=== database
=== deployment


=== Sistema di test <tec:test-system>
=== database
=== deployment
== Librerie e strumenti di supporto
== Strumenti di sviluppo
