#let glossary-terms=(
   (key: "api",
           short: [API],
           long: [Application Program Interface],
           description: [
                   È un’interfaccia utile a permettere o facilitare la comunicazione tra diversi software o parti di un singolo software.
           ],
   ),
  (
    key: "rag",
    short: [RAG],
    long: [Retrieval Augmented Generation],
    description: [
      Tecnica che permette agli LLM di reperire e incorporare informazioni da fonti di dati esterne.
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
      Estensione per Postgres, un database management system, che semplifica l'utilizzo dei vettori, consentendo di archiviarli, cercarli e indicizzarli direttamente in un database relazionale.
    ],
  ),
  (
    key: "elasticsearch",
    short: [Elasticsearch],
    // long: [],
    description: [
      Motore di analisi e ricerca distribuita.
      Funge da piattaforma di retrieval e salva dati strutturati, non strutturati e dati vettoriali.
    ],
  ),
  (
    key: "ricerca-linked-glossario",
    short: [Ricerca linked],
    // long: [],
    description: [
        Modalità di ricerca che analizza ogni entità del database, con la possibilità di applicare un filtro,
        e combina i risultati secondo una configurazione che specifica come eseguire i join,
        vi è anche la possibilità di applicare un filtro al termine del join.
    ],
  ),
  (
    key: "ricerca-semantica-glossario",
    short: [Ricerca semantica],
    // long: [],
    description: [
        Anche detta ricerca vettoriale. Questo tipo di ricerca valuta la similarità basandosi su un criterio matematico di distanza tra due vettori di embedding.
    ],
  ),
  (
    key: "ricerca-full-text-glossario",
    short: [Ricerca full-text],
    // long: [],
    description: [
            #upper("è") una tecnica informatica che permette di cercare parole o frasi all'interno di un intero documento o di un database, esaminando ogni singola parola archiviata e non solo parti limitate come i titoli o i metadati.
    ],
  ),
  (
    key: "embedding",
    short: [Embedding],
    long: [Vettore di embedding],
    description: [
        #upper("è") una sequenza di numeri reali che trasforma un oggetto complesso (una parola, una frase, un'immagine o un file audio) in una rappresentazione matematica comprensibile per un computer.
    ],
  ),
  (
    key: "framework",
    short: [Framework],
    // long: [],
    description: [
        Indica un insieme strutturato di componenti software, librerie e regole che forniscono una base riutilizzabile per sviluppare applicazioni.
        Un framework offre funzionalità già pronte e un’architettura predefinita, guidando lo sviluppatore nelle scelte progettuali e riducendo il lavoro necessario per creare nuovi programmi.
    ],
  ),
  (
    key: "parade",
    short: [ParadeDB],
    // long: [],
    description: [
          Estensione per Postgres che integra un motore di ricerca full-text basato su BM25 direttamente nel database relazionale, sfruttando l'indice Tantivy (una libreria di ricerca scritta in Rust). Si propone come alternativa a Elasticsearch per i casi d'uso in cui si vuole evitare la sincronizzazione tra un sistema di persistenza primario e un motore di ricerca esterno, mantenendo le query in SQL standard e le garanzie ACID di Postgres.
    ],
  ),
  (
    key: "poc",
    short: [PoC],
    long: [Proof of concept],
    description: [
          #upper("è") un test pratico e mirato che serve a dimostrare se un'idea, un metodo o un software è realmente fattibile nel mondo reale.
          Fornisce una soluzione astratta al problema dell'interoperabilità tra interfacce differenti.
    ],
  ),
  (
    key: "ricerca-ibrida-glossario",
    short: [Ricerca ibrida],
    // long: [],
    description: [
           Indica una tecnica di recupero delle informazioni che unisce la ricerca full-text e la ricerca semantica in un'unica richiesta.
    ],
  ),
  (
    key: "adapter",
    short: [Adapter],
    // long: [],
    description: [
          Denota un design pattern utilizzato in informatica nella programmazione orientata agli oggetti.
    ],
  ),
  (
    key: "information-retrieval",
    short: "IR",
    long: "Information Retrieval",
    description: [
        Insieme delle tecniche utilizzate per gestire la rappresentazione, la memorizzazione, l'organizzazione e l'accesso ad oggetti contenenti informazioni
    ],
  ),
  (
    key: "rrf",
    short: "RRF",
    long: "Reciprocal Rank Fusion",
    description: [
            Algoritmo di aggregazione comunemente usato nell'ambito della ricerca ibrida, permette di combinare due o più elenchi di risultati con punteggi non direttamente paragonabili, utilizza solo la posizione di ogni elemento in ogni classifica al fine di calcolare il nuovo punteggio.
    ],
  ),
  (
    key: "similarity-search",
    short:"Similarity search",
    long: "Ricerca per similarità",
    description: [
        Una funzione che cerca gli elementi della collezione più simili alla query secondo una misura di similarità e restituisce un ranking ordinato per grado di somiglianza decrescente.
    ],
  ),
  (
    key: "ranking",
    short: [Ranking],
    description: [
        Processo algoritmico con cui si assegna un punteggio di rilevanza a un insieme di documenti rispetto a una query, ordinandoli in una lista decrescente.
    ],
  ),
  (
    key: "principio-dei-cassetti",
    short: [Principio dei cassetti],
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
  (
    key: "persistenza-poliglotta",
    short: [Persistenza poliglotta],
    // long: [],
    description: [
      Paradigma architetturale secondo cui un sistema adotta più tecnologie di persistenza dei dati distinte, ciascuna scelta in base alle caratteristiche del carico di lavoro o del modello dati che deve gestire, anziché affidarsi a un'unica soluzione generalista per tutti i casi d'uso.
    ],
  ),
  (
    key: "architettura-esagonale",
    short: [Architettura esagonale],
    // long: [],
    description: [
      Paradigma di progettazione del software ideato da Alistair Cockburn il cui obiettivo principale è isolare la logica di business centrale dai sistemi esterni, come database, interfacce utente o API di terze parti.
    ],
  ),
  (
    key: "chunk-testo",
    short: [Chunk],
    long: [Chunk di testo],
    description: [
      Indica un segmento di testo frutto di divisioni di testi più lunghi.
      Necessario a trattare in modo più semplice testi lunghi, in particolare il significato di un testo eccessivamente lungo non può essere trasposto in un vettore di embedding.
    ],
  ),
  (
    key: "reranking",
    short: [Reranking],
    // long: [Chunk di testo],
    description: [
      Indica il processo di combinazione dei risultati prodotti da diverse fonti o ricerche.
      Alcuni esempi sono il rescoring quando i punteggi delle diverse fonti sono direttamente comparabili, rrf o combinazione con modelli appositi quando non direttamente comparabili.
    ],
  ),
)
