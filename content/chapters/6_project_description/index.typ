#import "/plugin/mod.typ": gl, glpl
#import "/metadata/mod.typ": data
#import "/plugin/mod.typ" : code-snippet
#pagebreak(to: "odd")

#heading("Implementazione", depth: 1)<cap:lavoro-svolto>

#text(style: "italic", [
  In questo capitolo approfondisco le fasi di sviluppo del progetto, descrivendo le scelte implementative concrete e le problematiche affrontate nella realizzazione del sistema di information retrieval e del sistema di test.

])
#v(1em)

// == Struttura del database

// === Tabelle
// Il database ha la seguente struttura:
// #list(
//   [
//     Per ogni entità vengono create le seguenti tabelle:
//     - Tabella principale, contiene i dati dell'entità eccetto quelli CHUNKED_TEXT + SEARCHABLE (data la loro natura a chunk e la necessità di ottimizzarle per le ricerche full text e semantica richiedono una tabella apposita di supporto), chiavi primarie e chiavi esterne vengono create in accordo con la SchemaConfiguration
//     - Tabella dei chunk, funge da supporto per le ricerche, contiene i seguenti dati: #[
//       - Chive primaria della tabella principale, funge anche da chiave esterna
//       - field_name, il nome del campo dati CHUNKED_TEXT + SEARCHABLE, necessario a supportare la ricerca di similarità su sotto insiemi, chiave esterna verso un'apposita tabella, non necessaria ma utile a garantire integrità
//       - numero del chunk, intero che indica il numero del chunk
//       - lingua del testo, chiave esterna verso una tabella globale
//       - testo del chunk
//       - il vettore di embedding calcolato sul testo del hunk
//       - tsv_simple, il tsvector calcolato automaticamente dal database dal testo del chunk sfruttando una configurazione agnostica rispetto alla lingua
//       - tsv_lang, il tsvector calcolato automaticamente dal database dal testo del chunk sfruttando una configurazione specifica per la lingua indicata nel campo di lingua 
//       - campi filterable denormalizzati
//     chiave primaria formata dalla chiave esterna verso l'entità di origine, field_name, numero del chunk
//     ]

//     - tabella dei field_name, utile ma non obbligatoria
//   ],
//   [
//     tabella delle lingue, utile a fornire vincoli sul supporto linguistico.
//   ],
//   [ingestion sessions, tabella usata per tracciare la presenza e l'attività di una sessione di ingestion],
//   [session streams, tabella che traccia l'esecuzione dei singoli stream di inserimento, serve a non far terminare l'ingestion se degli stream stanno ancora eseguendo],
// )
// === Staging

// All'interno del database sono anche presenti delle tabelle di staging necessarie a gestire il probabile non arrivo in ordine dei dati

// Le tabelle di staging  sono relative sia alle entità che ai loro chunk, non vine usata la vera chiave primaria ma uno staging id che permette di gestire conflitti in caso di caricamento duplicato di valori, la chiave primaria della tabella originale rimane sottoposta a vincolo unique a sua volta indicizzato per facilitare i join per la fase di promozione

// sono più semplici rispetto alle loro controparti reali, le altre differenze sono le seguenti:
// - non hanno la materializzazione dei ts vector, 
// - i vettori di embedding non sono di tipo vector ma double array, questo permette di non registrare l'estensione vector dentro il pool di connessioni dedicato all'ingestion dei dati, rendendola più leggera, (il casting è automatico in fase di promozione)
// - i non vi è denormalizzazione dei campi filterable 
// - non vi è alcuna indicizzazione oltre al btree sulle chiavi primarie reali

// ==== promozione
// la promozione avviene in batch di dimensione configurabile tramite query che selezionano ciò che può essere promosso, lo scheduling viene calcolato dinamicamente basandosi sui vincoli di integrità referenziale descritti nello schema configuration

// #code-snippet(
//   raw(
//     lang:"sql",
//     `WITH staging_window AS (
//     SELECT staging_id FROM {source_table}
//     WHERE {where_clause}
//     ORDER BY staging_id
//     LIMIT {self._batch_size}
// ),
// batch AS (
//     SELECT DISTINCT ON ({conflict_columns}) s.staging_id
//     FROM {source_table} s
//     JOIN staging_window w ON s.staging_id = w.staging_id
//     ORDER BY {conflict_columns}, s.staging_id DESC
// ),
// promoted AS (
//     DELETE FROM {source_table}
//     WHERE staging_id IN (SELECT staging_id FROM staging_window)
//     RETURNING staging_id, {column_list}
// ),
// inserted AS (
//     INSERT INTO {target_table} ({column_list})
//     SELECT {column_list} FROM promoted
//     WHERE staging_id IN (SELECT staging_id FROM batch)
//     ON CONFLICT ({conflict_columns}) {conflict_action}
//     RETURNING 1
// )
// SELECT count(*) FROM staging_window`.text
//   ),
// )


// === Partitioning
// le tabelle dei chunk sono partizionate sul campo fieldname,
// questo è fondamentale al supporto efficiente della ricerca per sotto insiemi

// === Indici
// Nell'analisi degli indici vengono omessi gli indici creati in modo autonomo da Postgres in corrispondenza di chiavi primarie
// va comunque ricordato che essi esistono

// le seguenti tabelle hanno i seguenti indici:
// #list(
//   [
//     - Tabelle dei chunk:
//       - Indice vettoriale hnsw, va impostato sul tipo di vettore e sul tipo distanza che si desidera utilizzare in fase di oversampling #[
//         Pgvector raccomanda che le ricerche che fanno uso di indici abbiano un parametro di oversampling, ciò è dovuto alla natura di indici approssimati di hnsw e ivfflat.

//         un'altra raccomandazione è utilizzare gli indici composti per indicizzare una versione a precisione ridotta dei vettori e utilizzare il re-ranking sui valori esatti
//       ]
//       - Indici btree su tutti i campi denormalizzati, questo ha la funzionalità di mitigare i problemi di filtering associati agli indici approssimati vettoriali, se una query con filtro è particolarmente selettiva è possibile che il planner di Postgres decida di apllicare prima il filtro e poi fare un calcolo della similarità sui risutlati ottenuti, senza l'inidce Postgres avrebbe prima recuperato i risultati e poi applicato il filtro, potenzialemtne perdendo tutti i risultati, per i filtri poco selettivi invece l'oversampling e iterative scan mitigano la perdita di risultati
//       - Indici testuali GIN, sulle colonne ts vector vengono creati degli indici testuali per il filtering durante la ricerca full text
//         - su tsv simple viene costruito un normale indice gin normale
//         - su tsv lang viene costruito un indice parziale per lingua 
//         - su tsv simple viene costruito un indice gin con l'inclusione di array ops
//         #code-snippet(raw(lang:"sql","CREATE INDEX ... ON ... USING GIN ((tsvector_to_array(tsv_simple)) array_ops)"))
//         - su tsv lang viene costruito un indice parziale per lingua con l'inclusione di array ops

//       vi è una duplicazione sugli indici ts vector a causa di una funzionalità che va supportata ma che la full text nativa non supporta, ricerca con matching di solo un tot di parole
//       per tale ricerca è necessario considerare i tsvector come semplici array di testo, entrambi gli indici sono utilizzati solo in fase di filtering, quindi solo un tipo di indici rimane necessario
//       il ranking rimane affidato alla full text search di Postgres che non necessità comunque dell'indice.

//   ],
//   [tabella delle ingestion session
//   - unique index sui valori dello status delle sessioni di ingestion per garantire solo una sessione attiva alla volta
//         #code-snippet(raw(lang:"sql","CREATE UNIQUE INDEX ix_ingestion_sessions_single_open ON public.ingestion_sessions USING btree (status) WHERE (status = 'open'::text)"))
//   ]
// )

// == Struttura generale del sistema
// Il progetto si divide in 2 sistemi separati

// - Retriever, il sistema principale che implementa le logiche di ricerca e ingestion dei dati
// - Retriever-trial, sistema di test, si interfaccia al sistema principale usando locust per simulare diversi utenti che eseguono query, poi logga i risultati della ricerca su un db che tramite una view calcola le metriche

// === Retriever
// Segue il principio dell'architettura esagonale, questo permette di modellare il sistema basandosi solo sul problema senza modellare funzioni non utili in questa fase esplorativa e che potrebbero andare a lodare Postgres per via di un bias

// le porte sono realizzate con ereditarietà da ABC e abstract method

// ==== Struttura della pipeline di ingestion
// La pipeline di ingestion segue il principio dell'architettura esagonale
// #enum(
//   [
//     4 adapter inbound:
//     - start ingestion session controller
//     - ingest batch list controller
//     - end ingestion session controller
//     - is ingestion active

//     hanno tutti una porta inbound specifica (suffisso use case) per lo scopo che devono realizzare
//     La serializzazione e deserializzazione è in automatico con pydantic

//     l'adapter inbound per l'ingestion è realizzato con fastapi, prende in input un array di raw batch un'entità che rappresenta un blocco di dati grezzi in input
//     ritorna una streaming response che comunica su quali record è fallito il processo di ingestion

//     inizialmente è stata progettata per avere uno stream sia in input che in output ma fastapi non supporta tale funzione, perciò il passaggio a lista di blocchi è stato un fix di convenienza 

//   ],
//   [
//     per le 4 porte use case vi sono 4 servizi
    
//     i service di avvio, termine e tracciamento di una sessione di ingestion utilizzano una porta outbound ingestion status tracker per realizzare le loro funzionalità

//     il service di ingestion vero e proprio accetta un async iterator di raw entity batch e usa una porta outbound per tracciare lo status dell'esecuzione dello stream 

//     per l'elaborazione dati vera e propria si avvale di 2 classi helper iniettate alla costruzione, un validator che controlla la correttezza dei dati e si occupa anche di fare casting di tipi non deducibili nell'adapter
//     nell'adapter inbound il tipo di un dato viene dedotto dal suo formato senza richiedere che tale informazione arrivi esplicitamente, tuttavia per i date time la conversione da string a datetime può essere ambigua(se un campo dati che deve rimanere testo ha come valore una data che però deve rimanere come stringa genererebbe errori più avanti,quindi il service durante la validazione dei tipi applica questa trasformazione dove necessario guardando i dati della schema configuration), poi vi è un processor che riceve alla costruzione le porte outbound per la language detection e per il calcolo degli embedding.

//     si occupa di aggregare le liste di testi da passare alle porte e costruire i refined entity batch

//     infine scrive il refined entity batch tramite una porta write repository

//     il metodo che realizza tutto ciò accetta in input un async iterator e mada in output un async iterator di rejected record comprensivi di identificativo e ragione del fallimento 


//   ],
//   [
//     le porte outbound sono quelle :
//     - per la gestione del tracking della sessione 
//     - per la gestione del tracking degli stream
//     - per il calcolo degli embedding (accetta una lista di stringhe per poter applicare ottimizzazioni lato adapter)
//     - per il rilevamento della lingua (accetta una lista di stringhe per poter applicare ottimizzazioni lato adapter)
//     - per il salvataggio dei dati su db


//   ],
//   [
//     gli adapter sono gli unici a conoscere il db Postgres, ricevono il connection pool alla creazione

//     gli adapter per il tracciamento della sessione usano le tabelle per loggare lo stato, una sessione di ingestion può avere tre stati aperta chiusa e finalizzata, da aperta a chiusa vuol dire che si possono ricevere richiest di inserimento dati e non si possono aprire altre sessioni, da closed a finalized non è più possibile caricare dati ma non si possono avviare nuove sessioni

//     la write repository scrive sulle tabelle di staging (sia tabelle principali che tabelle dei chunk), utilizza copy invece di insert per poter eseguire l'operazione in modo più veloce, reso possibile tramite lo staging id auto increment


//     quando arriva la notifica di termine dell'ingestion viene assegnato lo stato closed e avviato il processo di promozione, il processo di promozione avviene come descritto prima, al suo termine viene asseganto lo stato finalized

//     il processo di promozione avviene a batch di dimensione configurabile alla costruzione del sistema


//   ],
// )


// === Progettazione della ricerca

// viene sempre seguita l'architettura esagonale 

// si usano delle classi di dominio per rappresentare le informazioni necessarie all'esecuzione 

// #code-snippet(
//   raw(
//     lang:"python",
  
//   `
//   #rappresenta una query generale
// @dataclass(frozen=True, slots=True)
// class Query(Generic[R]):
//     #valori da inserire nella clausola select
//     return_fields: frozenset[R]
//     #serve a costruire parte della clausola where
//     filter: FilterCondition[R] | None = None

  
  
//   `.text
//   )
// )



// #code-snippet(
//   raw(
//     lang:"python",
  
//   `
//   #arricchisce la query con le informazioni per la ricerca semantica
// @dataclass(frozen=True, slots=True)
// class SimilarityQuery(Generic[R]):
//     query: Query[R]
//     target_similarity_fields: frozenset[R]
//     similarity_search_text: str
//     field_weights: _Weights[R] |None =None #overridable
//     language: LanguageCode | None=None #opzionale
//     top_k: int = 20 #overridable
  
  
//   `.text
//   )
// )
// questa è la classe con cui gli adapter inbound inviano richieste alle porte inbound


// #code-snippet(
//   raw(
//     lang:"python",
  
//   `
// #wrapper della similarity query arricchito con le info per la fusione di ibrida e semantica
// @dataclass(frozen=True, slots=True)
// class HybridSearchRequest(Generic[R]):


//     query: SimilarityQuery[R]
//     merge_weights: MergeWeights | None = None #overridable
  
  
//   `.text
//   )
// )

// #code-snippet(
//   raw(
//     lang:"python",
  
//   `
// #Risultato base di una query
// @dataclass(frozen=True, slots=True)
// class QueryResult(Generic[R]):
    
//     results: tuple[Mapping[R, FieldValue], ...]
  
  
//   `.text
//   )
// )

// #code-snippet(
//   raw(
//     lang:"python",
  
//   `
//   #info aggiuntive legate alla ricerca semantica
// @dataclass(frozen=True, slots=True)
// class SimilaritySearchResult(Generic[R]):
//     query_result: QueryResult[R]
//     matched_field: R
//     chunk_counter:int
//     matched_text: str
//     score: float
  
// # wrapper creato per comodità
// class SimilaritySearchResults(Generic[R]):

//     results: tuple[SimilaritySearchResult[R], ...]

//   `.text
//   )
// )

// #code-snippet(
//   raw(
//     lang:"python",
  
//   `

//   #wrapper da usare per la porta outbound che esegue la ricerca full text
// @dataclass(frozen=True, slots=True)
// class FullTextQueryCommand(Generic[R]):


//     query: SimilarityQuery[R]
  
  
//   `.text
//   )
// )

// #code-snippet(
//   raw(
//     lang:"python",
  
//   `

// @dataclass(frozen=True, slots=True)
// class HybridQueryCommand(Generic[R]):  #wrapper da usare per la porta outbound che esegue la ricerca ibrida
//     query: SimilarityQuery[R]
//     embedding: VectorEmbedding
//     merge_weights: MergeWeights
  
  
//   `.text
//   )
// )

// #code-snippet(
//   raw(
//     lang:"python",
  
//   `
// class HybridQueryCommand(Generic[R]):  #wrapper da usare per la porta outbound che esegue la ricerca semantica
// @dataclass(frozen=True, slots=True)
// class SemanticQueryCommand(Generic[R]):


//     query: SimilarityQuery[R]
//     embedding: VectorEmbedding
  
  
//   `.text
//   )
// )

// viene utilizzato un generic solo perché all'inizio le 2 gerarchie linked e hybrid erano identiche e quindi un alias per le versioni con field name e field reference era sufficiente
// successivamente disallineati lato query per necessità di specificare dei filtri sia per la singola entità che per la ricerca linked nel complesso

// sono ancora allineate sui risultati


// ==== Progettazione della ricerca semantica su singola entità
// la progettazione delle query semantiche si divide su 2 livelli

// classi che gestiscono la corrispondenza tra alcuni concetti della ricerca semantica e pg vector e classi che costruiscono concretamente la query.

// #code-snippet(
//   raw(
//     lang:"python",
  
//   `
//   #classe base usata per buildare la query
//     sql: str = ""
//     params: tuple[Any, ...] = ()
  
  
//   `.text
//   )
// )
// permette di concatenare 2 frammenti di query costruiti separatamente mantenendo corretti legami tra i segnaposto e i parametri

// ho preferito non usare query builder per assicurare che la complessità della pipeline di ricerca rimanga in chiaro e che ci sia un buon controllo sulle ottimizzazioni





// #code-snippet(
//   raw(
//     lang:"python",
  
//   `
// class PgVectorDistances(StrEnum):
//     """Basata sul principio 'lower raw distance = more similar', vero per
//     tutte le distanze in questo spazio raw nativo di pgvector.

//     Per COSINE e INNER_PRODUCT esiste inoltre uno spazio di similarità
//     limitato e naturale per chi chiama (higher = more similar): pgvector
//     calcola il raw in forma invertita/negata per ottimizzare l'ordinamento,
//     quindi va convertito prima di essere esposto o confrontato con una
//     soglia espressa in termini di similarità.

//     Per L2, L1, HAMMING, JACCARD non esiste un simile spazio limitato: sono
//     distanze intrinsecamente illimitate, lower=better è la loro unica forma
//     sensata. Chi chiama per queste distanze esprime SEMPRE la soglia (e
//     riceve SEMPRE lo score) nello stesso spazio raw - to_raw_threshold e
//     to_public_score sono no-op per questi casi, non conversioni.
//     """
//     L2 = auto()
//     INNER_PRODUCT = auto()
//     COSINE = auto()
//     L1 = auto()
//     HAMMING = auto()
//     JACCARD = auto()
  
  
//   `.text
//   )
// )

// #code-snippet(
//   raw(
//     lang:"python",
  
//   `

// class PgVectorType(StrEnum):
//     VECTOR=auto()
//     HALFVEC=auto()
//     BIT=auto()
//     # SPARSEVEC=auto() #il sistema non lo usa e non è neanche possibile il casting

  
  
//   `.text
//   )
// )

// #code-snippet(
//   raw(
//     lang:"python",
  
//   `


// @dataclass(frozen=True, slots=True)
// class SemanticSimilarityThreshold:
//     """Soglia di attivazione per ranking semantico, espressa in spazio
//     'normalizzato' (higher = more similar) insieme alla distanza per cui
//     è stata pensata - vedi nota su PgVectorDistances sul perché i due non
//     vanno mai disaccoppiati.

//     L'operatore in spazio raw è sempre <=: sia normalized_distance_expression
//     per INNER_PRODUCT (-1*raw) sia per COSINE (1-raw) sono trasformazioni
//     monotone DECRESCENTI di raw, quindi 'normalized >= soglia' si riduce
//     sempre a 'raw <= soglia_convertita', qualunque delle due distanze.
//     Non è un dettaglio da iniettare: è conseguenza algebrica della
//     trasformazione stessa.
//     """

//     distance: PgVectorDistances
//     value: float
  
  
//   `.text
//   )
// )
// queste classi servono a coniugare il comportamento di pgvector in un modo più coerente con le metriche andando a eseguire le trasformazioni inverse alle ottimizzazioni applicate durante la ricerca


// per la costruzione della query vera e propria si procede prima eseguendo le query sulle singole partizioni della tabella basandosi sui field name, vengono materializzate con cte e poi unite tramite union all e viene fatto il rescoring,

// union all e rescoring sono corretti perchè tutti i vettori usano la stessa distanza e i vettori vengono tutti dallo stesso modello di embedding

// per rendere più facilmente configurabile il sistema la descrizione della configurazione di pg vector è iniettata tramite dependency injection di un oggetto apposito
// #code-snippet(
//   raw(
//     lang:"python",
  
//   `
// @dataclass(frozen=True, slots=True)
// class PgVectorEngineConfig:
//     distance: PgVectorDistances
//     vector_type: PgVectorType
//     user_threshold: float
//     oversampling: int
//     embedding_dimensions: int
//     oversampling_distance: PgVectorDistances | None = None

//   `.text
//   )
// )
// il progetto adotta la seguente configurazione
// #code-snippet(
//   raw(
//     lang:"python",
  
//   `
//         PgVectorEngineConfig(
//             distance= PgVectorDistances.INNER_PRODUCT,
//             vector_type= PgVectorType.VECTOR,
//             user_threshold=0.3,
//             oversampling=20,
//             oversampling_vector_type=PgVectorType.BIT,
//             oversampling_distance=PgVectorDistances.HAMMING,
//             embedding_dimensions=768
//         )
  
  
//   `.text
//   )
// )
// per modificarla è sufficiente modificare una factory apposita che ostruisce tutti i vari oggetti di configurazione, questa gestisce in automatico le variabili ambientali 
// anche se non sono stati utilizzati if per la configurazione l'integrazione di questa funzione è veloce e avviene come modifica a un singolo metodo di una singola classe

// l'sql così generato ha circa la seguente forma
// #code-snippet(
//   raw(
//     lang:"sql",
  
//   `
// WITH candidates AS MATERIALIZED (
//     SELECT
//         "id_7a3c",                                   -- PK fisica (ID)
//         'Problem' AS "field_name",                    -- nome logico del campo cercato
//         "chunk_text" AS matched_text,

//         -- fase 1: candidati generati con cast leggero (oversampling)
//         -- BIT + HAMMING, non a piena precisione
//         binary_quantize("embedding"::vector)::bit(768)
//             <~> binary_quantize(:query_embedding::vector)::bit(768) AS candidate_score,

//         -- fase 2: rescoring a piena precisione (VECTOR + INNER_PRODUCT),
//         -- calcolato SOLO sui candidati già scremati dal LIMIT sotto
//         "embedding" <#> :query_embedding AS raw_score,
//         "chunk_counter"
//     FROM tk_chunks_9f21
//     WHERE "field_name" = 'problem_ab12'                -- nome FISICO del campo (per il filtro)
//       AND "status_id_44b1" = :ticket_status             -- filtro di dominio opzionale (es. 'OPEN')
//     ORDER BY candidate_score ASC                          -- ordina sul cast leggero
//     LIMIT :oversampling_limit                              -- es. 30 (top_k=10 + oversampling=20)
// )
// SELECT
//     "id_7a3c", "field_name", chunk_counter, matched_text, raw_score,
//     1.0::float8 AS field_weight                           -- peso del campo, noto a build-time
// FROM candidates
// WHERE raw_score <= :raw_threshold                          -- 0.3 utente -> -0.3 raw (INNER_PRODUCT invertito)
  
  
//   `.text
//   )
// )
// #code-snippet(
//   raw(
//     lang:"python",
  
//   `
// WITH ranked AS MATERIALIZED (
//     SELECT
//         "id_7a3c", "field_name", "matched_text", "chunk_counter", "raw_score",
//         (-1 * ("raw_score")) * "field_weight" AS weighted_score
//     FROM (
//         ( /* partizione "Problem",  vedi sopra */ )
//         UNION ALL
//         ( /* stessa struttura, campo "Solution" */ )
//         UNION ALL
//         ( /* stessa struttura, campo "Subject" */ )
//     ) AS all_candidates
//     ORDER BY weighted_score DESC          -- INNER_PRODUCT: higher = più simile
//     LIMIT :top_k                            -- es. 10
// )
// SELECT
//     main."created_at_5c10" AS "CreationDate",
//     main."subject_2e9f"    AS "Subject",
//     main."status_id_44b1"  AS "TicketStatusID",
//     ranked."field_name", ranked."matched_text",
//     ranked."chunk_counter", ranked."weighted_score"
// FROM ranked
// JOIN tk_main_9f21 AS main
//   ON main."id_7a3c" = ranked."id_7a3c"     -- JOIN una sola volta, solo sulle righe già a top_k
// ORDER BY ranked."weighted_score" DESC
  
  
//   `.text
//   )
// )
// #code-snippet(
//   raw(
//     lang:"python",
  
//   `

  
  
//   `.text
//   )
// )
// le partizioni singole eseguono internemnte il rerankin e materializzano il loro punteggio moltiplicato per il peso assegnato

// così la query esterna si limita a fare un union all order by


// == Progettazione della ricerca full text

// la ricerca full text ha adottato un'approccio simile alla semantica, viene mantenuta la struttura a partition queries perchè servono a mantenere semplice la ricerca su sotto insiemi di field name e ad applicare facilemnte i pesi, in questo caso questa forma non è vincolante ma stat più un riuso del codice della ricerca semantica
// la ranking function nativa di Postgres per la ricerca full text non ha come in elastic search la funzione di boosting progressivo, ad esmpio non è possibile dire alla ranking function di dare un boost grande se è un match su frase uno piccolo se è un match su tutte le parole ma non in ordine e poco se vi sono corrispondenze parziali di parole

// per simulare questo comportamento è necessario sommare più ranking function una phrase query e una allwords query se usatein una funzione rank danno lo stesso punteggio se si tratta di un match di frase, mentre se non vi è l'ordine la phrase query da 0


// un'altra limitazione è l'impossibilità di filtrare con criterio match tot parole, che però è possibile reimplementarlo tramite operazioni sugli array


// estraiamo i lessemi del testo della query, lo fa dentro Postgres altrimenti vi è il rischio di stemming incoerente se fatto con un tool esterno

// #code-snippet(

//   raw(
    
//     lang:"sql",
  
//   `
// WITH query_lexemes AS (
//   SELECT arr, cardinality(arr) AS n,
//          LEAST(
//            CASE
//              WHEN cardinality(arr) > 9 THEN GREATEST(CEIL(cardinality(arr) * 0.5)::int, 1)
//              WHEN cardinality(arr) > 4 THEN GREATEST(CEIL(cardinality(arr) * 0.6)::int, 1)
//              WHEN cardinality(arr) > 2 THEN GREATEST(CEIL(cardinality(arr) * 0.9)::int, 1)
//              ELSE cardinality(arr)
//            END,
//          15) AS k
//   FROM (
//     SELECT array_agg(lex ORDER BY lex) AS arr
//     FROM unnest(tsvector_to_array(to_tsvector('italian', 'problema di accesso al portale utente'))) AS lex
//   ) AS lexemes
// ),
//   `.text
//   )
// )
// esegue la ricerca


// #code-snippet(
//   raw(
    
//     lang:"sql",
  
//   `

// candidates AS MATERIALIZED (
//   SELECT
//     "ticket_id",
//     "chunk_text" AS matched_text,
//     "chunk_counter",
//     (
//         ts_rank_cd("tsv_lang", to_tsquery('italian', (plainto_tsquery('italian', 'problema di accesso al portale utente'))::text || ':*'))
//       + ts_rank_cd("tsv_lang", to_tsquery('italian', (phraseto_tsquery('italian', 'problema di accesso al portale utente'))::text || ':*'))
//       + ts_rank_cd("tsv_lang", to_tsquery('italian', replace(plainto_tsquery('italian', 'problema di accesso al portale utente')::text, ' & ', ' | ')))
//     ) AS raw_score,
//     cardinality(ARRAY(
//       SELECT unnest(tsvector_to_array("tsv_lang"))
//       INTERSECT
//       SELECT unnest(arr) FROM query_lexemes
//     )) AS matched_count,
//     (SELECT k FROM query_lexemes) AS required_k
//   FROM public.ticket_chunks
//   WHERE "field_name" = 'description'
//     AND tsvector_to_array("tsv_lang") && (SELECT arr[1 : GREATEST(n - k + 1, 1)] FROM query_lexemes)
//     AND "chunk_language" = 'it'
// )

  
  
//   `.text
//   )
// )
//   #code-snippet(raw(
    
//     lang:"sql",
  
//   `

// SELECT
//   "ticket_id",
//   'description' AS "field_name",
//   matched_text,
//   "chunk_counter",
//   raw_score,
//   1.0::float8 AS field_weight
// FROM candidates
// WHERE raw_score >= 0.0
//   AND matched_count >= required_k;
  
  
//   `.text
//   )
// )
// non essendo funzionalità di ricerca full text non è possibile usarla nella funzione di ranking, nel config è possibile configurare le soglie e le percentuali, 

// è comunque utilizzabile nella configurazione  una tsquery, solo che una anyword query su query grandi e basi di dati ampie non limita significativamente la base di dati

// la ricerca su lingua non nota esegue questa esegue una tre volte la ricerca, una volta sul vettore tsv_simple, 1 svolta su tsv lang where lang = it e una volta where lang = en 
// scorre la base d idati 2 volte e poi i risutlati vengono nuovamente combinati con union all

// === ricerca ibrida

// le query costuite precendentemente non vengono eseguite subito ma vengono prima create tramite classi helper e poi eseguite.

// questo permette di realizzare la ricerca ibrida come rrf che prende i 2 frammeti di query ricevuti e applica l'rrf lato db, tramite cte vengono materilizzate e la posizione vien materializzata usando RANK OVER


// == Progettazione della ricerca linked
// vengono generati gli sql fragemnt di tutte le entità poi in base alla linked search configuration vengono stabilit i join per espandere le tabelle poi union all e rescoring


// rimane sempre solo una chiamata sql


// == retriever trial

// === esecuzione query



// === logging risultati



// === Dashboard