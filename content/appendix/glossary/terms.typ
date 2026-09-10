#let glossary-terms = (
  (
    key: "rag",
    short: [RAG],
    long: [Retrieval Augmented generation],
    description: [
      Tecnica che permette ai agli LLM di reperire e incorporare informazioni da fonti di dati esterne.
      \
      Questo permette di recuperare informazioni rilevanti da database, documenti caricati, fonti web, ecc...
      \
      Il vantaggio principale è l'attualità delle risposte fornite dall'LLM e la possibilità di non dover usare documenti privati in fase di addestramento.
    ],
  ),
  (
    key: "llm",
    short: [LLM],
    long: [Large Language Model],
    description: [
      Modello di intelligenza artificiale
      addestrato su enormi quantità di testo per comprendere e generare
      linguaggio naturale, come GPT, Gemini o Mistral. Viene impiegato in
      compiti di analisi, estrazione di informazioni e generazione testuale.
    ],
  ),
  (
    key: "pgvector",
    short: [Pgvector],
    // long: [Large Language Model],
    description: [
      Estensione per Postgres, un database management system, che semplifica l'utilizzo dei vettori, consentendoti di archiviarli, cercarli e indicizzarli direttamente nel tuo database relazionale.
    ],
  ),
  (
    key: "elasticsearch",
    short: [Elasticsearch],
    // long: [Large Language Model],
    description: [
      Motore di analisi e ricerca distibuita.
      Funge da piattaforma di retrieval e salva dati strutturati, non strutturati e dati vettoriali.
    ],
  ),
  (
    key: "linked-search",
    short: [Linked search],
    // long: [Large Language Model],
    description: [
        Modalità di ricerca che analizza ogni entità del database, con la possibilità di applicare un filtro,
        e combina i risultati secondo una configurazione che specifica come eseguire i join,
        vi è anche la possibilità di applicare un filtro al termine del join
    ],
  ),
  (
    key: "information-retrieval",
    short: "IR",
    long: "Information retrieval",
    description: [
        Insieme delle tecniche utilizzate per gestire la rappresentazione, la memorizzazione, l'organizzazione e l'accesso ad oggetti contenenti informazioni
    ],
  ),
  (
    key: "rrf",
    short: "RRF",
    long: "Reciprocal rank fusion",
    description: [
            Algoritmo di aggregazione comunemente usato nell'abito della ricerca ibrida, permette di combinare due o più elenchi di risultati con punteggi non direttamente paragonabili, utilizza solo la posizione di ogni elemento in ogni classifica al fine di calcolare il nuovo punteggio.
    ],
  ),
  (
    key: "similarity-search",
    long: "Ricerca per similarità",
    description: [
        Una funzione che cerca gli elementi della collezione più simili alla query secondo una misura di similarità e restituisce un ranking ordinato per grado di somiglianza decrescente.
    ],
  ),
  (
    key: "ranking",
    long: [Ranking],
    description: [
        Processo algoritmico con cui si assegna un punteggio di rilevanza a un insieme di documenti rispetto a una query, ordinandoli in una lista decrescente.
    ],
  ),
  (
    key: "principio-dei-cassetti",
    long: [Principio dei cassetti],
    description: [
        Noto anche come _pigeonhole principle_, indica una classe di problemi in cui _n_ oggetti vengono distribuiti in _m_ contenitori, con $n > m$; ne consegue necessariamente che almeno un contenitore conterrà più di un oggetto.
    ],
  ),
  (
    key: "acid",
    short: [ACID],
    long: [Atomicità, Coerenza, Isolamento e Durabilità],
    description: [
            Rappresentano le quattro proprietà fondamentali di un DBMS che garantiscono affidabilità e correttezza.
    ],
  ),
  (
    key: "sql",
    short: [SQL],
    long: [Structured Query Language],
    description: [
        Linguaggio di programmazione standardizzato utilizzato per creare, gestire, modificare e interrogare database relazionali.
    ],
  ),
)
