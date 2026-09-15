#import "/plugin/glossary/glossary-key-prefix.typ":glossary-key-prefix
#let glossary-terms=(
   (key: "api",
           short: [API],
           long: [Application Programming Interface],
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
        Una funzione che cerca gli elementi della collezione più simili alla query secondo una misura di similarità e restituisce un ranking ordinato per somiglianza.
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
        Noto anche come _pigeonhole principle_, indica una classe di problemi in cui _n_ oggetti vengono distribuiti in _m_ contenitori, con n maggiore di m; ne consegue necessariamente che almeno un contenitore conterrà più di un oggetto.
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
      Alcuni esempi sono il rescoring quando i punteggi delle diverse fonti sono direttamente comparabili, RRF quando non direttamente comparabili.
    ],
  ),
  (
    key: "mrr",
    short: [MRR],
    long: [Mean Reciprocal Rank],
    description: [
            #upper("è") un indice statistico usato per valutare i sistemi di ricerca e recupero informazioni in base a quanto in alto posizionano la prima risposta corretta.
            Il reciproco del rank di una risposta ad una query è l'inverso della posizione (rank) della prima risposta corretta nella lista ordinata delle risposte. Il MRR è la media dei rank reciproci dei risultati per un insieme di query Q.
            // $"MRR"=1/Q sum^Q_(i=1)"RelevanceLabelValue"/"rank"_i$
    ],
  ),
  (
    key: "hitrate",
    short: [Hitrate\@k],
    // long: [],
    description: [
            #upper("è") un indice statistico usato per valutare i sistemi di ricerca e recupero informazioni in base a quanto in alto posizionano la prima risposta corretta.
            Misura la percentuale di tentativi o interazioni che hanno prodotto un risultato corretto con rank minore o uguale a k rispetto al totale dei tentativi compiuti.
            Ad esempio hitrate\@1 misura quanto spesso il primo risultato è corretto.
            // $"MRR"=1/Q sum^Q_(i=1)"RelevanceLabelValue"/"rank"_i$
    ],
  ),
  (
    key: "retrieval-latency",
    short: [Retrieval latency],
    // long: [],
    description: [
            Indica il tempo di attesa medio trascorso tra l'avvio di una ricerca e la ricezione dei risultati dal punto di vista di chi invia la ricerca.

    ],
  ),
  (
    key: "retrieval-answer-rate",
    short: [Retrieval answer rate],
    // long: [],
    description: [
            Indica la percentuale di volte in cui una ricerca produce un risultato corretto indipendentemente dalla posizione.

    ],
  ),
  (
    key: "retrieval-wins",
    short: [Retrieval wins],
    // long: [],
    description: [
            Indica il numero di volte in cui una ricerca produce un risultato indipendentemente dalla sua correttezza.

    ],
  ),
  (
    key: "not-found",
    short: [Not found],
    // long: [],
    description: [
            Indica il numero di volte in cui una ricerca non produce alcun risultato.

    ],
  ),
  (
    key: "ingestion",
    short: [Ingestion],
    // long: [],
    description: [
            Indica il processo di caricamento e trasformazione dei documenti sorgente all'interno di un sistema di ricerca, che comprende l'estrazione dei dati, il calcolo degli embedding e la loro memorizzazione in una forma indicizzata e interrogabile.

    ],
  ),
  (
    key: "gin",
    short: [GIN],
    long: [Generalized Inverted Index],
    description: [
            Indica una struttura dati che mappa i contenuti direttamente alle loro posizioni o ai documenti in cui compaiono, consentendo ricerche full-text rapide.
            Nel contesto di Postgres indica un tipo di indice progettato per gestire valori composti ed effettuare ricerche efficienti su di essi.
            // [1] (https://www.postgresql.org/docs/current/gin.html)

    ],
  ),
  (
    key: "cte",
    short: [CTE],
    long: [Common Table Expression],
    description: [
            Indica un set di risultati temporaneo e con un nome proprio, definito all'interno dell'ambito di esecuzione di una singola istruzione SQL (come `SELECT`, `INSERT`, `UPDATE` o `DELETE`).
            Funziona come una tabella virtuale o una sottoquery con un nome, creata al volo durante l'esecuzione della query principale ed eliminata subito dopo.

             // [1] (https://learnsql.it/blog/che-cose-una-cte-in-sql-server/), [2] (https://www.datacamp.com/it/tutorial/cte-sql), [3] (https://www.youtube.com/watch?v=qGx0TISr8Q8&t=981)
    ],
  ),
  (
    key: "tsvector",
    short: [Tsvector],
    // long: [],
    description: [
            Indica un tipo di dato nativo di PostgreSQL progettato specificamente per la ricerca testuale.
        Rappresenta un elemento del corpus documentale che viene cercato tramite una tsquery.
    ],
  ),
  (
    key: "tsquery",
    short: [Tsquery],
    // long: [],
    description: [
            Indica un tipo di dato nativo di PostgreSQL progettato specificamente per la ricerca testuale.
            Rappresenta il testo da cercare nel corpus documentale, viene usato nelle interrogazioni.
    ],
  ),
  (
    key: "ground-truth",
    short: [Ground truth],
    // long: [],
    description: [
            Indica un singolo risultato o un insieme di risultati considerati corretti e usati come riferimento per valutare l'accuratezza e le prestazioni di un sistema.
    ],
  ),
  (
    key: "bm25",
    short: [BM25],
    // long: [],
    description: [
            Indica una funzione di scoring avanzata usata nella ricerca full-text.
            Questa funzione è in grado di gestire lo scoring in base alla composizione della base documentale, attribuisce punteggi più bassi a parole molto frequenti e punteggi più alti a quelle più rare.
    ],
    ),

    (
      key: "tokenizer",
      short: "Tokenizer",
      long: none,
      description: [
        Componente che suddivide un testo in unità elementari (dette token),
        tipicamente parole o sotto-parole, come primo passo
        dell'elaborazione linguistica in un motore di ricerca
        @elastic-tokenizers.
      ],
    ),
    (
      key: "sharding",
      short: "Sharding",
      long: none,
      description: [
        Tecnica di partizionamento orizzontale dei dati in più unità
        indipendenti (dette shard), distribuite su nodi diversi, per migliorare
        scalabilità e prestazioni di un sistema distribuito.
      ],
    ),
    (
      key: "block-max-wand",
      short: "Block-Max WAND",
      long: none,
      description: [
        Algoritmo di pruning per l'ordinamento top-k che sfrutta limiti
        superiori precalcolati sul punteggio dei documenti per escludere
        candidati che non potrebbero rientrare nei risultati finali,
        riducendo il costo computazionale della ricerca.
      ],
    ),
    (
      key: "analyzer",
      short: "Analyzer",
      long: none,
      description: [
        Componente che definisce come il testo viene elaborato prima di
        essere indicizzato o interrogato, tipicamente composto da una
        catena di filtri di normalizzazione e da un tokenizer,
        responsabile della segmentazione del testo in singoli token.
      ],
    ),
    (
      key: "stemming",
      short: "Stemming",
      long: none,
      description: [
        Tecnica linguistica che riduce una parola alla sua radice
        morfologica, in modo da far corrispondere varianti flesse dello
        stesso termine (ad esempio singolare e plurale) durante la
        ricerca @elastic-stemming.
      ],
    ),
    (
      key: "iterative-scan",
      short: "Iterative scan",
      long: none,
      description: [
        Strategia di esecuzione che, in presenza di un filtro applicato
        dopo una ricerca approssimata su indice vettoriale, ripete la
        scansione dell'indice fino a recuperare il numero di risultati
        richiesto, compensando la possibile scarsità di risultati causata
        dal filtro @pgvector-iterative-scan.
      ],
    ),
    (
      key: "configurazione-testuale",
      short: "Configurazione testuale",
      long: none,
      description: [
        Insieme di regole che definisce come Postgres elabora il testo
        per l'indicizzazione e la ricerca full-text: comprende la
        scelta del parser che suddivide il testo in token e dei
        dizionari che, per ciascun tipo di token, applicano
        trasformazioni come normalizzazione, rimozione delle stop word
        e stemming @postgres-text-search-config.
      ],
    ),

    (
      key: "oversampling",
      short: "Oversampling",
      long: none,
      description: [
        Tecnica abbinata alle ricerche approssimate che recupera un numero
        di candidati superiore a quello richiesto dall'utente, per poi
        ricalcolarne il punteggio esatto e restituire solo i migliori k,
        compensando eventuali perdite di precisione.
      ],
    ),
    (
      key: "rescoring",
      short: "Rescoring",
      long: none,
      description: [
        Fase successiva al recupero di un insieme di candidati in cui il
        punteggio di rilevanza viene ricalcolato con maggiore precisione,
        tipicamente per correggere le approssimazioni introdotte da ottimizzazioni di ricerca.
      ],
    ),
    (
      key: "hnsw",
      short: "HNSW",
      long: "Hierarchical Navigable Small World",
      description: [
        Struttura dati per la ricerca approssimata del vicino più prossimo,
        organizzata come un grafo gerarchico multilivello che permette di
        navigare efficientemente verso i vettori più simili senza
        confrontare l'intero insieme di dati, particolarmente adatta a
        scenari con inserimenti incrementali.
      ],
    ),
    (
      key: "cosine-similarity",
      short: "Cosine similarity",
      long: none,
      description: [
        Metrica di similarità tra due vettori basata sul coseno dell'angolo
        che li separa, indipendente dalla loro magnitudine e quindi adatta
        a confrontare vettori di embedding normalizzati o di lunghezza
        variabile.
      ],
    ),
    (
      key: "inner-product",
      short: "Inner product",
      long: none,
      description: [
        Metrica di similarità tra due vettori calcolata come somma dei
        prodotti delle rispettive componenti; a differenza della cosine
        similarity tiene conto anche della magnitudine dei vettori, per cui
        è equivalente ad essa solo quando i vettori confrontati sono già
        normalizzati.
      ],
    ),
    (
      key: "phrase-query",
      short: "Phrase query",
      long: none,
      description: [
        Modalità di ricerca full‑text che richiede la corrispondenza
        esatta di una sequenza di parole nell'ordine specificato, anziché
        la semplice presenza dei singoli termini indipendentemente dalla
        loro posizione reciproca.
      ],
    ),
    (
      key: "all-words-query",
      short: "All-words query",
      long: none,
      description: [
        Modalità di ricerca full‑text che richiede la corrispondenza un intero insieme di parole senza un ordine specifico.
      ],
    ),
    (
      key: "any-word-query",
      short: "Any-word query",
      long: none,
      description: [
        Modalità di ricerca full‑text che richiede la corrispondenza di una singola parola.
      ],
    ),
    (
      key: "composition-root",
      short: "Composition root",
      long: none,
      description: [
        Punto unico del programma in cui vengono create e collegate tra
        loro le istanze concrete delle dipendenze dell'applicazione,
        separando la costruzione degli oggetti dalla logica applicativa
        che li utilizza.
      ],
    ),
    (
      key: "aggregate-root",
      short: "Radice dell'aggregato",
      long: "Aggregate root",
      description: [
        Nel Domain-Driven Design, oggetto che funge da punto di accesso
        unico a un insieme di entità e valori correlati che devono essere
        trattati come un'unica unità consistente, garantendo che le
        invarianti dell'intero aggregato siano rispettate a ogni
        modifica.
      ],
    ),
    (
      key: "visitor",
      short: "Visitor",
      long: none,
      description: [
        Design pattern comportamentale che permette di aggiungere nuove
        operazioni su una gerarchia di tipi senza modificarne le classi,
        incapsulando ciascuna operazione in un oggetto separato a cui
        ogni tipo della gerarchia delega l'esecuzione tramite un metodo
        dedicato.
      ],
    ),
    (
      key: "upsert",
      short: "Upsert",
      long: none,
      description: [
        Operazione di scrittura su database che inserisce un nuovo record
        oppure, qualora esista già un record in conflitto con un vincolo di
        unicità, ne aggiorna i valori, evitando così di dover eseguire
        separatamente un controllo di esistenza seguito da un inserimento
        o un aggiornamento espliciti.
      ],
    ),
    (
      key: "quantizzazione-binaria",
      short: "Quantizzazione binaria",
      long: none,
      description: [
        Tecnica di riduzione di precisione di un vettore che ne rappresenta
        ciascuna componente con un singolo bit anziché con un valore in
        virgola mobile, riducendo lo spazio occupato e il
        costo di confronto a scapito della precisione, tipicamente
        utilizzata per generare rapidamente un insieme di candidati da
        raffinare in una fase successiva.
      ],
    ),
    (
      key: "distanza-hamming",
      short: "Distanza di Hamming",
      long: none,
      description: [
        Metrica di distanza tra due sequenze di bit di uguale lunghezza,
        definita come il numero di posizioni in cui i bit corrispondenti
        differiscono; è la metrica naturalmente associata al confronto tra
        vettori quantizzati in forma binaria.
      ],
    ),
    (
      key: "dependency-injection",
      short: "Dependency injection",
      long: none,
      description: [
        Tecnica secondo cui le dipendenze di un componente non vengono
        create direttamente al suo interno, ma fornite dall'esterno al
        momento della sua costruzione, disaccoppiando il componente
        dall'implementazione concreta delle proprie dipendenze e
        facilitandone la sostituzione e il test.
      ],
    ),
    (
      key: "asgi",
      short: "ASGI",
      long: "Asynchronous Server Gateway Interface",
      description: [
              Interfaccia standard per server, framework e applicazioni web Python che permette la gestione asincrona delle richieste.]
    ),
    (
      key: "lessema",
      short: "Lessema",
      // long: "",
      description: [
              Unità astratta di significato che raggruppa tutte le forme flesse di una parola; costituisce l'unità di riferimento in molti task di elaborazione del linguaggio naturale, come la lemmatizzazione e l'indicizzazione nei sistemi di information retrieval.]
    ),



        ).map(it=>{

        (
                ..it,
                key:glossary-key-prefix+it.key,
        )
        }
)
