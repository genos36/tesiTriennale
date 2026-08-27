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
    key: "similarity-search",
    // short: "IR",
    long: "Ricerca per similarità",
    description: [
        Una funzione che cerca gli elementi della collezione più simili alla query secondo una misura di similarità e restituisce un ranking ordinato per grado di somiglianza decrescente.
    ],
  ),
  (
    key: "ranking",
    // short: [IR],
    long: [Ranking],
    description: [
        Processo algoritmico con cui un sistema assegna un punteggio di rilevanza a un insieme di documenti rispetto a una query, ordinandoli in una lista decrescente.
    ],
  ),
)
