// #import "@preview/grayness:0.1.0": grayscale-image
#import "/plugin/mod.typ": gl, glpl
#import "/metadata/mod.typ": data
#import "/template/components/technology-sheet.typ":technology-sheet
#import "/content/chapters/3_requirements/use-case/content/deps/utils/code-set-up.typ": uc-link, uc-link-extended
#import "/content/chapters/3_requirements/requirement/requisiti-vincolo/requisiti-obbligatori/content/deps/code-set-up.typ" : req-link as rcm-link

== Contesto e problema <teoria:contesto-problema>

Il progetto ha una finalità esplorativa: valuta quanti e quali workaround siano necessari affinché un sistema basato su Postgres realizzi funzionalità di information retrieval pari all'attuale sistema aziendale, basato su Elasticsearch. Non si tratta di un confronto assoluto tra le due tecnologie, ma di una valutazione mirata ai casi d'uso specifici di questo progetto.
Elasticsearch nasce come motore di ricerca dedicato, mentre Postgres è un database relazionale a cui sono state aggiunte funzionalità di retrieval.

È prassi comune rivalutare periodicamente le tecnologie che compongono uno stack software, specialmente quando un'alternativa promette di semplificare l'architettura complessiva. I criteri tipici di una simile valutazione includono la complessità di utilizzo e manutenzione del sistema, le prestazioni, e il rispetto di proprietà come l'atomicità e la consistenza delle transazioni.
Il presente progetto si colloca in questo tipo di valutazione: verifica se Postgres, unificando ricerca full-text e semantica in un unico sistema relazionale, possa rappresentare un'alternativa valida a un'architettura che oggi si appoggia a un motore di ricerca dedicato ma disaccoppiato dal database relazionale primario, con i relativi costi di sincronizzazione tra i due sistemi.

L'adeguatezza di Postgres in questo contesto è valutata secondo i seguenti criteri:
- la complessità del database e delle funzioni di ricerca;
- i tempi di risposta;
- la qualità del retrieval, misurata tramite metriche di hit rate a diversi livelli di granularità. La definizione completa delle metriche è riportata nel caso d'uso #uc-link-extended("Visualizza metriche di performance", separator: "-").

La ground truth viene definita dall'attuale sistema di ricerca basato su Elasticsearch, in quanto rappresenta il comportamento di riferimento attualmente accettato e in uso in azienda.

È stato esplicitamente concordato con il tutor aziendale che le metriche relative al consumo di risorse non sono prioritarie per il tirocinio, in quanto una volta effettuato il deployment su server aziendale è già realizzato il tracciamento del consumo di risorse ed è quindi possibile estendere la dashboard Grafana per mostrare anche quello.

Per giustificare alcune scelte e capire meglio l'utilità di alcune funzionalità, in particolare della ricerca linked, è utile ricordare che il sistema di information retrieval si colloca dentro un sistema RAG, per ulteriori informazioni si veda @cap:descrizione-stage.

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

La ricerca per similarità viene eseguita in due modalità: su singola entità e linked.

La ricerca su singola entità esegue la ricerca solo su una delle entità del modello dati, mentre la ricerca linked cerca su tutte le entità del modello e ricostruisce per ogni entità cercata una visione globale del risultato tramite join, per poi unire i dati ottenuti in un unico risultato. Il funzionamento dettagliato è descritto in @cap:analisi-iniziale.

=== Caratteristiche di Elasticsearch <analisi-elasticsearch>
Elasticsearch è un motore di ricerca nato per l'indicizzazione e l'interrogazione di documenti, e offre nativamente funzionalità avanzate di information retrieval. Tra i suoi punti di forza rilevanti per questo confronto vi sono la flessibilità nell'uso di tokenizer linguistici, la granularità dei filtri disponibili per la ricerca full-text, e una maggiore manipolabilità dei dati indicizzati.
Elasticsearch offre inoltre sharding nativo, ma tale funzionalità non è necessaria ai fini di questo progetto.

In quanto sistema orientato ai documenti, Elasticsearch non è pensato per eseguire join tra entità distinte: i dati vengono tipicamente denormalizzati in fase di ingestion, così da rendere ogni documento autosufficiente rispetto alle query previste.
Questo è un trade-off intrinseco al suo modello di dati, non un limite implementativo: è la stessa ragione per cui, all'opposto, un database relazionale come Postgres richiede una fase di normalizzazione dei dati e l'esecuzione di join per ricostruire una visione completa delle informazioni. Nel contesto di questo progetto, tale caratteristica rende Elasticsearch meno adatto a gestire nativamente la ricerca linked, che richiede di correlare più entità del modello dati.

=== Caratteristiche di Postgres <analisi-postgres>
Postgres è un database relazionale, e supporta quindi nativamente i join necessari alla ricerca linked.
Attraverso tsvector, tsquery e pgvector, discusse nel dettaglio in @tec:main-system, è inoltre possibile realizzare ricerca full-text e semantica all'interno dello stesso sistema, riducendo la complessità architetturale rispetto all'uso di un motore di ricerca dedicato.

A differenza di Elasticsearch, le funzionalità di ricerca per similarità di Postgres non sono centrali, poiché il database è pensato principalmente per carichi di lavoro transazionali. Questo comporta che, per raggiungere un livello di funzionalità equivalente a quello offerto nativamente da Elasticsearch, siano necessari in alcuni casi workaround applicativi o strutturali, discussi in @limiti-postgres.

=== Motivi del confronto
Le principali motivazioni alla base di questa valutazione sono le seguenti:
- pgvector ha introdotto di recente funzionalità di ricerca semantica avanzate in Postgres, rendendo oggi plausibile un suo utilizzo per l'information retrieval;
- l'utilizzo di un database relazionale anche per le funzionalità di ricerca permette di arricchire più facilmente database relazionali già esistenti, senza introdurre un sistema aggiuntivo dedicato.

=== Limiti del sistema attuale <limiti-correnti>
I limiti descritti in questa sezione derivano dal modo in cui la ricerca è stata implementata nell'applicativo aziendale che utilizza Elasticsearch, e non da limitazioni intrinseche del motore di ricerca.

Un limite riguarda l'impossibilità di eseguire la ricerca per similarità su sottoinsiemi di campi di testo divisi in chunk: ad esempio, non è possibile effettuare la ricerca semantica solo sul campo Problem o solo sul campo Solution di un ticket, poiché durante il calcolo degli embedding questi campi vengono concatenati. Tale funzionalità è invece disponibile per la ricerca full-text.

Per questo motivo il sistema di ricerca realizzato durante il tirocinio non rispecchierà il sistema attuale sotto questo aspetto, allineandosi invece con il comportamento desiderato dall'impresa.

=== Limiti di Postgres e Pgvector <limiti-postgres>
Le configurazioni testuali di Postgres sono comunque piuttosto avanzate: supportano sinonimi, frasi sinonimo, stemming morfologico, e supportano un'ampia varietà di lingue.

Il limite principale non riguarda la completezza delle funzionalità linguistiche disponibili, quanto la flessibilità nel modificarle: definire o modificare una configurazione di ricerca testuale in Postgres richiede operazioni di data definition relativamente complesse, mentre in Elasticsearch un analyzer può essere definito o modificato in modo molto più semplice, anche al momento della creazione dell'indice. Di conseguenza, la disponibilità di analyzer preconfigurati equivalenti a quelli offerti di default da Elasticsearch non è replicabile in Postgres se non tramite workaround.

Un'ulteriore limitazione riguarda il filtraggio: Postgres non offre nativamente la possibilità di filtrare i risultati in base al numero di parole della query che trovano corrispondenza in un documento, funzionalità invece disponibile in Elasticsearch. Anche sul piano del ranking, la ricerca full-text nativa di Postgres non implementa l'algoritmo BM25, a differenza di Elasticsearch: le implicazioni di questa differenza sono discusse nel dettaglio in @tec:main-system.

Un limite più generale riguarda la ricerca ibrida: Elasticsearch espone nativamente un'unica interfaccia in grado di combinare ricerca full-text e vettoriale all'interno della stessa richiesta, applicando internamente algoritmi di fusione come RRF. Postgres non offre un operatore equivalente: la fusione dei risultati deve essere implementata esplicitamente, ad esempio tramite Common Table Expression, spostando sullo sviluppatore la responsabilità di una logica che in Elasticsearch è gestita dal motore stesso.

Anche la combinazione tra ricerca vettoriale e filtri relazionali presenta un limite condiviso da entrambe le tecnologie, seppur gestito con un diverso grado di automazione. Negli indici approssimati basati su grafo, applicare un filtro dopo la ricerca può restituire un numero di risultati inferiore a quello richiesto, anche quando esistono abbastanza documenti che soddisfano il filtro: questo vale sia per pgvector sia per Elasticsearch. Entrambi i sistemi offrono meccanismi di mitigazione a runtime.
Il pre-filtering nativo in Elasticsearch e le iterative scan in pgvector oltre a soluzioni strutturali come indici parziali o partizionamento. La differenza principale tra le due tecnologie risiede nel grado di automazione: in Elasticsearch il passaggio tra le diverse strategie di filtraggio è deciso automaticamente dal motore in base alla selettività del filtro, mentre in Postgres le iterative scan devono essere abilitate esplicitamente dallo sviluppatore e configurate.
