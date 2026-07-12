#import "/plugin/mod.typ": gl, glpl
#import "/template/mod.typ": img
#import "/metadata/mod.typ": data

#let myTutor = data.myTutor
= Introduzione <cap:introduzione>
#text(style: "italic", [
  In questo capitolo descrivo l'azienda, introduco il progetto, e spiego le motivazioni che mi hanno portato a sceglierlo.
])
#v(1em)

== L'azienda
#data.myCompany è un'azienda parte del Gruppo Zucchetti, vanta un'esperienza ultra trentennale nello sviluppo di soluzioni software destinate sia ad aziende private che a istituzioni pubbliche. L'azienda si posiziona come partner tecnologico specializzato nella progettazione di piattaforme per la gestione e l'automazione dei processi aziendali e dei servizi di assistenza e supporto.
#img(
  "logo-azienda.svg",
  caption: [Logo #text(data.myCompany)],
  alt: "",
)<fig:logo>

== Il progetto
Il progetto ha come obiettivo principale la riprogettazione e la sostituzione dell'attuale architettura dati utilizzata per la persistenza e il recupero delle informazioni all'interno dei prodotti aziendali.

Attualmente, l'impresa adotta una soluzione consolidata basata sul paradigma della persistenza poliglotta.

Tale architettura prevede l'utilizzo congiunto di due sistemi separati: PostgreSQL per la gestione dei dati strettamente relazionali ed Elasticsearch per l'indicizzazione dei documenti, la ricerca full-text, la gestione degli embedding vettoriali e le operazioni di filtraggio avanzato.

Sebbene questo approccio ibrido sia funzionale e ampiamente utilizzato,
la divisione dei carichi di lavoro su motori di database differenti
comporta diverse limitazioni architettoniche e operative:
#list(
  [
    Denormalizzazione dei dati:
    la natura orientata ai documenti e non relazionale di Elasticsearch obbliga a replicare e denormalizzare
    i dati relazionali per consentire un filtraggio efficiente, aumentando la ridondanza.

  ],
  [
    Overhead di sincronizzazione:
    il mantenimento della coerenza tra il database primario PostgreSQL e il motore di ricerca Elasticsearch
    richiede complesse pipeline di allineamento,
    esponendo il sistema a ritardi di sincronizzazione o disallineamenti.

  ],
  [
    Mancanza di garanzie ACID globali:
    operando su sistemi separati, risulta complesso garantire l'atomicità e
    la consistenza transazionale durante l'inserimento o l'aggiornamento simultaneo di dati
    strutturati e vettoriali.

  ],
)

Per superare queste criticità, il progetto esplora la transizione verso un paradigma a database unificato.
L'obiettivo è accentrare l'intero carico di lavoro su PostgreSQL sfruttando pgvector,
un'estensione open-source che introduce il supporto nativo alla persistenza dei vettori di embedding
e alle operazioni di algebra lineare direttamente all'interno dell'ecosistema relazionale.

Nello specifico, il nuovo sistema dovrà soddisfare i seguenti requisiti implementativi:
#list(
  [
    Ingestion unificata:
    sviluppo di un modulo dedicato all'inserimento simultaneo di
    metadati relazionali e documenti non strutturati.

  ],
  [
    Ottimizzazione degli indici:
    sfruttamento delle capacità di indicizzazione full-text native di PostgreSQL
    e creazione di indici vettoriali dedicati tramite
    pgvector per garantire l'efficienza scalabile della ricerca semantica.

  ],
  [
    Integrazione relazionale:
    utilizzo di costrutti SQL per correlare dinamicamente i documenti e
    i vettori alle entità strutturate di dominio preesistenti nel gestionale.

  ],
  [
    Ricerca Ibrida:
    implementazione di una logica di recupero che combini la precisione lessicale
    della ricerca testuale con la profondità concettuale della ricerca semantica,
    fondendo i risultati tramite l'algoritmo di Reciprocal Rank Fusion.

  ],
)
Al fine di validare rigorosamente l'efficacia di questa nuova architettura unificata, il sistema verrà sottoposto a una fase di benchmarking contro la soluzione attualmente in uso.

I test comparativi si concentreranno sulle seguenti metriche chiave:
#list(
  [
    Latenza di interrogazione: misurazione dei tempi di risposta durante la ricerca testuale, semantica e ibrida.

  ],
  [
    Velocità di indicizzazione: tempi necessari per l'elaborazione e l'inserimento a database di nuovi record complessi.

  ],
  [
    Impatto sullo storage: analisi dello spazio su disco occupato dai dati e dai relativi indici.

  ],
  [
    Complessità della pipeline: valutazione qualitativa della semplificazione architetturale.

  ],
)





== Scelta del progetto
Ho scelto questo progetto per 3 ragioni principali:
+ Rilevanza dell'argomento: nell'informatica moderna, l'integrazione di funzionalità basate sull'Intelligenza Artificiale rappresenta un fattore competitivo e innovativo.

+ Centralità della manutenzione: il progetto permette di intervenire direttamente sulla fase più estesa, costosa e critica del ciclo di vita di un prodotto software aziendale.

+ Stack tecnologico all'avanguardia: offre l'opportunità di operare sul campo con strumenti e framework moderni.
