#import "/plugin/mod.typ": gl, glpl
#import "/metadata/mod.typ": data
#import "/plugin/mod.typ" : code-snippet
#pagebreak(to: "odd")

#heading("Implementazione del sistema di test", depth: 1)<cap:lavoro-svolto-test-system>

#text(style: "italic", [
  In questo capitolo approfondisco le fasi di sviluppo del progetto legate al sistema di test, descrivendo le scelte implementative concrete e le problematiche affrontate nella sua realizzazione.
])
#v(1em)

Il sistema di test, indicato anche come retriever-trial, ha una struttura più semplice rispetto al sistema di ricerca, e ne è cliente: espone due soli casi d'uso, l'avvio di una sessione di test, *start test*, e l'esecuzione di una singola query di test, *run one*.


Locust simula un numero configurabile di client paralleli che eseguono ricerche contro il sistema di ricerca. Lo start test viene invocato una sola volta, all'avvio della sessione di Locust; ciascun client simulato si limita poi a invocare ripetutamente run one.

Il sistema di test riusa la schema configuration del sistema di ricerca, ma in una forma semplificata contenente le sole entità necessarie ai fini del test, e riutilizza le classi di query già definite nel sistema di ricerca, estese con una classe dedicata per rappresentare la ground truth di ciascuna query.

Ogni esecuzione di run one, tramite una porta dedicata, recupera una query di test e la relativa ground truth; tramite una seconda porta esegue la query contro il sistema di ricerca, ottenendo sia il risultato reale sia lo stato corrente della sessione di ingestion (per poter distinguere, in fase di analisi, i risultati raccolti durante un'ingestion in corso da quelli raccolti a dati stabili); infine, tramite una terza porta, registra l'esito su un database dedicato. Da questo database, tramite una vista, vengono calcolate le metriche di interesse, che Grafana si limita a leggere e visualizzare.
== Perimetro di test
L'implementazione e la realizzazione dei test sono state ritenute molto dispendiose in termini di tempo, sia a livello di codice che preparazione dei dati di test; ciò ha portato alla scelta di ridurre l'esecuzione automatica alla ricerca linked ibrida non ottimizzata per lingua: essendo la più complessa tra tutte, costituisce un limite superiore ai tempi di esecuzione delle altre. I problemi di accuratezza delle singole ricerche sono intrinseci al tipo di ricerca (@analisi-teorica-ricerche) e vengono mitigati proprio dall'uso della ricerca ibrida.

Le altre tipologie di ricerca vengono comunque analizzate tramite test manuali e script al fine di poter comunque esprimere un giudizio su di esse.
L'estensione del sistema di test al fine di gestire tutte le tipologie di ricerca è lasciata a evoluzioni successive del sistema di test.

== Architettura del codice
Anche il sistema di test segue il principio dell'architettura esagonale, con la stessa suddivisione in adapter, port, service e classi di dominio già vista per il sistema di ricerca.

Le classi relative al data modelling riutilizzate dal sistema di ricerca sono le relative alle query e ai search result.
Sono state anche riutilizzate le classi entity seppur in modo ridotto, viene usata anche una classe schema configuration ma ridimensionata a collezione di entità.

Sono state aggiunte le seguenti classi di dominio:
#list(
        [TestQuery, un semplice wrapper che contiene un id e una SearchRequest;],
        [SearchRequest, aggrega una SimilarityQuery o una hybrid search request alla relativa GroundTruth;],
        [GroundTruth, rappresenta il risultato atteso dalla ricerca;],
        [RealResult, rappresenta il risultato reale di una ricerca;        ],
        [LogItem, aggrega una query di test con il relativo risultato e altre informazioni come l'id della sessione o lo stato di attività dell'ingestion],
)

La logica applicativa vera è realizzata da un singolo service descritto in @evaluation-service.
Il service utilizza delle porte outbound per comunicare con l'esterno:
- TestQueryRepositoryPort, rappresenta il sistema di permanenza per le query da eseguire;
- LinkedSearchExecutorPort, rappresenta il sistema di ricerca da sottoporre a valutazione;
- IngestionStatusPort, recupera lo stato di attività della sessione di ingestion;
- LinkedEvaluationLogPort, rappresenta il sistema di permanenza su cui vengono salvati le TestQuery e il relativo RealResult.

#code-snippet(
  caption:"Sistema di test - EvaluationService",
  code-label:"evaluation-service",
  raw(
  lang:"python",
  `
  class EvaluationService(StartTestUseCase, RunOneUseCase):

      def __init__(
          self,
          repository: TestQueryRepositoryPort,
          linked_executor: LinkedSearchExecutorPort,
          ingestion_status: IngestionStatusPort,
          linked_logger: LinkedEvaluationLogPort,
      ) -> None:
      `.text+sym.dots.v+`
      def start_test(self) -> TestSessionId:
`.text+sym.dots.v+`
      def run_one(self) -> bool:
`.text+sym.dots.v
  )
)


== Sistema di persistenza
Il sistema di test ha due sistemi di permanenza con funzionalità ed esigenze distinte;
uno si occupa di memorizzare le query di ricerca da eseguire, TestQueryRepositoryPort, l'altro registra i risultati delle ricerche, LinkedEvaluationLogPort.

*TestQueryRepositoryPort* viene solo letto in modo sequenziale, perciò si è scelto di utilizzare un semplice file jsonl, rende facile la deserializzazione, viene riutilizzato lo stesso codice usato dal sistema di ricerca
per la deserializzazione del payload json delle richieste HTTP.
La sua modifica si traduce in una modifica ad un file. Ha anche una maggiore facilità di condivisione e tracciamento.

*LinkedEvaluationLogPort* viene usato dal backend python per scritture continue al fine di registrare i risultati delle ricerche, serve inoltre un ricalcolo continuo al fine di calcolare le metriche. Postgres risponde a queste esigenze, le scritture sono veloci e il ricalcolo continuo è eseguito tramite una view.
Inoltre Grafana e Postgres  sono  direttamente compatibili, quindi il backend non deve occuparsi né di calcolare le metriche né di comunicarle alla dashboard.



== Start test
La sessione di test viene avviata da Locust tramite un apposito adapter inbound, viene sempre rispettata la struttura esagonale.

Un'esecuzione tipica segue il seguente flusso:
#enum(
        [
        avvio, il service si occupa di generare e memorizzare l'id della sessione di test e di recuperare la lista delle TestQuery da eseguire tramite la porta TestQueryRepositoryPort e le organizza in una coda;
        ],
        [
        esecuzione periodica delle ricerche, sono avviate da Locust sempre attraverso un adapter,
        + la TestQuery viene recuperata dalla coda,
        + tramite la porta IngestionStatusPort il service recupera l'informazione relaitva allo stato di attività dell'ingestion,
        + l'adapter RemoteIngestionStatusAdapter recupera l'informazione relativa allo stato di attività dell'ingestion,
        + eseguita tramite la LinkedSearchExecutorPort per recuperare il RealResult,
        + l'adapter RemoteLinkedSearchExecutorAdapter invia la query di ricerca all'endpoint appropriato,
        + il LogItem e l'id della sessione di test corrente vengono persistiti tramite la porta LinkedEvaluationLogPort,
        + l'adapter PostgresLinkedEvaluationLogAdapter si occupa di salvare sul database il LogItem, eventualmente rendendo esplicite informazioni come la posizione della GroundTruth.
        ]
)

== Visualizzazione dei risultati
Grafana si interfaccia direttamente con il database postgres utilizzando una sintassi sql-like.
Per mantenere le query semplici ho scelto di utilizzare la seguente vista per semplificare l'accesso.



#code-snippet(
  caption:"Sistema di test - Vista metriche",
  code-label: "metriche",
  raw(
  lang:"sql",
  `
CREATE VIEW evaluation_metrics AS WITH session_starts AS (
      SELECT test_session_id, min(executed_at) AS session_started_at
      FROM evaluation_log GROUP BY test_session_id)
SELECT e.test_session_id, s.session_started_at, e.ingestion_active, count(*) AS total_queries, avg(e.elapsed_time) AS avg_elapsed_time,
avg(CASE
        WHEN e.rank_of_expected IS NOT NULL THEN 1.0
        ELSE 0.0
    END) AS retrieval_answer_rate,
avg(CASE
        WHEN e.rank_of_expected IS NOT NULL THEN 1.0 / e.rank_of_expected
        ELSE 0.0
    END) AS mean_reciprocal_rank,
avg(CASE
        WHEN e.rank_of_expected IS NOT NULL
        AND e.rank_of_expected <= 1 THEN 1.0
        ELSE 0.0
    END) AS hit_rate_1,
avg(CASE
        WHEN e.rank_of_expected IS NOT NULL
        AND e.rank_of_expected <= 5 THEN 1.0
        ELSE 0.0
    END) AS hit_rate_5,
avg(CASE
        WHEN e.rank_of_expected IS NOT NULL
        AND e.rank_of_expected <= 10 THEN 1.0
        ELSE 0.0
    END) AS hit_rate_10,
avg(CASE
        WHEN NOT e.has_results THEN 1.0
        ELSE 0.0
    END) AS not_found_rate
FROM evaluation_log e JOIN session_starts s USING (test_session_id)
GROUP BY e.test_session_id,s.session_started_at,e.ingestion_active;
`.text
  )
)
Grafana utilizza una variabile che recupera in automatico la sessione più recente e parametrizza su di essa la dashboard.
#code-snippet(
  caption:"Sistema di test - Variabile Grafana",
  code-label: "metriche-vita",
  raw(
  lang:"sql",
"SELECT
    test_session_id AS __value,
    to_char(session_started_at, 'YYYY-MM-DD HH24:MI:SS') || ' — ' || test_session_id AS __text
FROM (
    SELECT DISTINCT test_session_id, session_started_at
    FROM evaluation_metrics
) sessions
ORDER BY session_started_at DESC"
  )
)

Per la visualizzazione dei dati sono adottati 2 schemi, un indicatore di tipo time series per vedere i tempi di ingestion e un indicatore di tipo gauge per i valori unitari, indipendentemente dalla scala dei dati(percentuale o scalare).
#code-snippet(
  caption:"Sistema di test - Time series",
  raw(
  lang:"sql",
"SELECT
    executed_at AS time,
    elapsed_time
FROM evaluation_log
WHERE test_session_id = '$session' AND NOT ingestion_active
ORDER BY executed_at;"
  )
)
#code-snippet(
  caption:"Sistema di test - Gauge",
  raw(
  lang:"sql",
"SELECT
    not_found_rate
FROM evaluation_metrics
WHERE test_session_id = '$session'
  AND ingestion_active = false"
  )
)
== Limitazioni imposte da elementi esterni
Nell'adapter dedicato al calcolo degli embedding tramite modello remoto è stato necessario introdurre un rallentamento artificiale delle prestazioni, a causa di blocchi temporanei imposti dal servizio remoto: un numero eccessivo di chiamate in un breve intervallo causa un periodo di blocco durante il quale il servizio restituisce sistematicamente un errore 503.

Questo adapter è condiviso da più componenti del sistema di ricerca — la fase di arricchimento dell'ingestion e i service di ricerca semantica e ibrida — motivo per cui la limitazione descritta in questa sezione, per quanto discussa qui in un unico punto, si ripercuote su tutte queste componenti.

Da un punto di vista architetturale, questo intervento non introduce un nuovo collo di bottiglia nel sistema, ma sposta parzialmente, dall'esterno verso l'interno del sistema, un collo di bottiglia già esistente e non altrimenti evitabile. Per gestirlo sono stati introdotti meccanismi di retry con attesa esponenziale e numero massimo di tentativi, oltre a un limite al numero di richieste concorrenti verso il servizio remoto, realizzato tramite semafori e contatori.
