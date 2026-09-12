#import "/plugin/mod.typ": gl, glpl
#import "/template/mod.typ": img
#import "/metadata/mod.typ": data

#let myTutor = data.myTutor
= Introduzione <cap:introduzione>
#text(style: "italic", [
  In questo capitolo descrivo l'azienda, introduco il progetto e spiego le motivazioni che mi hanno portato a sceglierlo.
])
#v(1em)

== L'azienda
#data.myCompany è un'azienda parte del Gruppo Zucchetti, che vanta un'esperienza ultratrentennale nello sviluppo di soluzioni software destinate sia ad aziende private che a istituzioni pubbliche. L'azienda si posiziona come partner tecnologico specializzato nella progettazione di piattaforme per la gestione e l'automazione dei processi aziendali e dei servizi di assistenza e supporto.
#img(
  "logo-azienda.svg",
  caption: [Logo #text(data.myCompany)],
  alt: "",
)<fig:logo>

== Il progetto
Il progetto ha come obiettivo principale la realizzazione di un #gl("poc", display:"proof of concept (PoC)") valutativo della riprogettazione e della sostituzione dell'attuale architettura dati utilizzata per la persistenza e il recupero delle informazioni all'interno dei prodotti aziendali.

Attualmente, l'impresa adotta una soluzione basata sul paradigma della #gl("persistenza-poliglotta",display:"persistenza poliglotta").

Tale architettura prevede l'utilizzo congiunto di due sistemi separati: Postgres per la gestione dei dati strettamente relazionali ed #gl("elasticsearch") per l'indicizzazione dei documenti, la #gl("ricerca-full-text-glossario", display:"ricerca full-text"), la gestione degli #gl("embedding",display:"embedding") vettoriali e le operazioni di filtraggio avanzato.

Sebbene questo approccio ibrido sia funzionale e ampiamente utilizzato,
la divisione dei carichi di lavoro su motori di database differenti
comporta diverse limitazioni architettoniche e operative:
#list(
  [denormalizzazione dei dati,
    la natura orientata ai documenti e non relazionale di Elasticsearch obbliga a replicare e denormalizzare
    i dati relazionali per consentire un filtraggio efficiente, aumentando la ridondanza e forzando a implementare in modo non ottimale funzioni come i join;

  ],
  [overhead di sincronizzazione,
    il mantenimento della coerenza tra il database primario Postgres e il motore di ricerca Elasticsearch
    richiede complesse pipeline di allineamento,
    esponendo il sistema di ricerca a ritardi di sincronizzazione o disallineamenti;

  ],
  [mancanza di garanzie #gl("acid") globali,
    operando su sistemi separati, risulta complesso garantire l'atomicità e
    la consistenza transazionale durante l'inserimento o l'aggiornamento simultaneo di dati
    strutturati e vettoriali.

  ],
)

Per superare queste criticità, il progetto esplora la transizione verso un paradigma a database unificato.
L'obiettivo è accentrare l'intero carico di lavoro su Postgres sfruttando #gl("pgvector", display:"pgvector"),
un'estensione open-source che introduce il supporto nativo alla persistenza dei vettori di embedding
e alle operazioni di algebra lineare direttamente all'interno dell'ecosistema relazionale.

Nello specifico, il nuovo sistema di ricerca dovrà soddisfare i seguenti requisiti implementativi:
#list(
  [
    #gl("ingestion",display:"ingestion"),
    sviluppo di un modulo dedicato all'inserimento simultaneo di
    dati relazionali e documenti;

  ],
  [
    ottimizzazione degli indici,
    sfruttamento delle capacità di indicizzazione full-text native di Postgres
    e creazione di indici vettoriali dedicati tramite
    pgvector per garantire l'efficienza scalabile della #gl("ricerca-semantica-glossario", display:"ricerca semantica")\;

  ],
  [
    integrazione relazionale,
    utilizzo di costrutti #gl("sql") per correlare dinamicamente i documenti e
    i vettori tra le varie entità del sistema di ricerca;

  ],
  [
    #gl("ricerca-ibrida-glossario", display:"ricerca ibrida"),
    implementazione di una logica di recupero che combini la precisione lessicale
    della ricerca testuale con la profondità concettuale della ricerca semantica,
    fondendo i risultati tramite l'algoritmo di #gl("rrf")\;

  ],
  [
    #gl("ricerca-linked-glossario", display:"ricerca linked"),
    modalità che permette di analizzare automaticamente ogni entità del sistema di ricerca e di ricostruire un quadro complessivo dell'informazione tramite join.

  ],
)
Al fine di validare rigorosamente l'efficacia di questa nuova architettura unificata, il sistema di ricerca verrà sottoposto a una fase di benchmarking contro la soluzione attualmente in uso.

I test comparativi si concentreranno sulle seguenti metriche chiave:
#list(
  [
    latenza di interrogazione: misurazione dei tempi di risposta durante la ricerca testuale, semantica e ibrida;

  ],
  [
    velocità di indicizzazione: tempi necessari per l'elaborazione e l'inserimento nel database di nuovi record complessi;

  ],
  [
    impatto sullo storage: analisi dello spazio su disco occupato dai dati e dai relativi indici;

  ],
  [
    complessità della pipeline: valutazione qualitativa della semplificazione architetturale.

  ],
)





== Scelta del progetto
Ho scelto questo progetto per tre ragioni principali:
+ rilevanza dell'argomento, alla base dei moderni sistemi di intelligenza artificiale, come la #gl("rag"), che utilizzano l'#gl("information-retrieval", display:"information retrieval  (IR)") per fornire contesto agli #gl("llm")\;

+ evoluzione di un sistema di ricerca reale, permette di partecipare all'evoluzione di un software, sfida che durante il percorso universitario non ho affrontato;

+ stack tecnologico, offre l'opportunità di operare con strumenti e framework moderni.
