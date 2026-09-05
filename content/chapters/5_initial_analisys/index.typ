// #import "@preview/grayness:0.1.0": grayscale-image
#import "/plugin/mod.typ": gl, glpl
#import "/metadata/mod.typ": data
#import "/template/components/technology-sheet.typ":technology-sheet
#import "/content/chapters/3_requirements/use-case/content/deps/utils/code-set-up.typ": uc-link, uc-link-extended
#import "/content/chapters/3_requirements/requirement/requisiti-vincolo/requisiti-obbligatori/content/deps/code-set-up.typ" : req-link as rcm-link
#pagebreak(to: "odd")

= Principi e caratteristiche del sistema  <cap:analisi-iniziale>
#text(style: "italic", [
  In questo capitolo descrivo i principi architetturali e le caratteristiche progettuali che guidano lo sviluppo del sistema di information retrieval e del sistema di test a supporto della sua validazione.
])
#v(1em)

== Studio iniziale
Coerentemente con quanto stabilito nella @pianificazione-settimane, le prime due settimane sono state dedicate allo studio e all'analisi del contesto, con l'obiettivo di acquisire una comprensione solida dell'information retrieval, delle potenzialità di Postgres e delle capacità di Elasticsearch.

Nell'ambito di questo studio sono state valutate anche estensioni più evolute rispetto agli strumenti nativi di Postgres, come ParadeDB e pg_textsearch; entrambe sono state escluse dall'implementazione finale per i motivi discussi nell' #link(<tec:fts-nativa>)[analisi della full-text search nativa], ma il loro studio ha comunque contribuito alla comprensione delle capacità disponibili nell'ecosistema.

Per acquisire una comprensione adeguata delle capacità di Elasticsearch è stato condotto uno studio della documentazione ufficiale, che ha evidenziato, come atteso, una maggiore maturità e potenza rispetto a Postgres sia nell'ambito della ricerca full-text sia in quello della ricerca semantica.

Sul fronte della ricerca semantica non sono state individuate differenze sostanziali tra le due tecnologie in termini di funzionalità di base; Elasticsearch offre tuttavia una maggiore granularità nel controllo della precisione dei dati (con supporto a diversi livelli di precisione numerica, come float e double) e implementa un meccanismo di pre-filtering automatico quando una clausola di filtro risulta sufficientemente selettiva.

Sul fronte della ricerca full-text, lo studio ha invece evidenziato alcuni limiti significativi di Postgres rispetto a Elasticsearch:
- le pipeline di elaborazione del testo sono utilizzabili solo se predefinite come configurazioni di testo, senza possibilità di composizione dinamica;
- manca il supporto a text analyzer multipli;
- i filtri disponibili sono limitati (corrispondenza a frase, a tutte le parole o ad almeno una parola), mentre Elasticsearch consente di richiedere la corrispondenza di un numero specifico di parole, anche determinato dinamicamente in base alla lunghezza della query;
- la funzione di scoring nativa risulta meno evoluta.

Parallelamente allo studio teorico, sono stati realizzati progressivamente alcuni proof of concept, con l'obiettivo di acquisire familiarità pratica con le tecnologie valutate.

Non tutte le capacità di Postgres analizzate in questa fase sono state successivamente impiegate nel sistema, in parte per la mancanza di un'integrazione organica con i casi d'uso del progetto; le scelte effettive sono motivate nelle sezioni seguenti.

== Principi del sistema principale
In questa sezione vengono trattati principi e caratteristiche relativi al sistema principale.
=== Definizione modello dati <main-system-definizione-modello-dati>
Il modello dati del sistema principale deve rappresentare le entità del dominio del service desk HDA, articolate in ticket, conversation item e attachment #rcm-link("Rispetto modello dati hda"), collegate tra loro secondo una struttura relazionale gerarchica.

Aggiungendo le caratteristiche richieste dal requisito #rcm-link("Alta configurabilità del sistema"), il modello dati così definito costituisce la fonte di verità del sistema, e comprende:
- l'elenco delle entità;
- per ciascuna entità, la definizione dei campi (nome, tipo e obbligatorietà), i campi identificativi (con supporto anche a chiavi composte), i ruoli dei campi e i relativi pesi di default;
- l'elenco dei vincoli tra le entità. Questi non sono stati limitati fin da subito al solo vincolo relazionale, ma definiti in forma generica, di cui il vincolo relazionale rappresenta una specializzazione: si tratta di un punto di estensione esplicito, pensato per accomodare eventuali tipologie di vincolo non relazionale che potrebbero emergere in futuro;
- l'elenco delle regole di linking, trattate nel dettaglio nella @analisi-ricerca-linked dedicata alla ricerca linked.

I dati effettivamente utilizzati in produzione dall'azienda non coincidono necessariamente con il modello analizzato in questo documento, poiché variano in base alle esigenze specifiche di ciascun cliente. Questa variabilità è una delle motivazioni alla base del requisito di configurabilità del sistema.

I ruoli supportati per i campi sono due:
- searchable, indica i campi su cui è possibile eseguire una ricerca di similarità;
- filterable, indica i campi utilizzabili come filtro.

A partire da questi due ruoli sono state definite alcune regole di progetto. Una parte è imposta direttamente dai requisiti raccolti, un'altra è frutto di scelte autonome, resa necessaria dalla natura esplorativa del progetto:

Per decisione di progetto, non esiste un ruolo dedicato ai campi restituibili da una ricerca: si assume che siano restituibili tutti i campi privi di ruolo o con ruolo filterable. I campi searchable non sono restituibili per intero, per evitare di riportare porzioni di testo estese e poco significative; ogni ricerca restituisce comunque, a prescindere, il chunk di testo che ha determinato il match, il nome del campo di provenienza e il numero del chunk. Il recupero di porzioni di testo più estese è demandato a un caso d'uso dedicato, trattabile in implementazioni future, che a partire dalle informazioni identificative del match ricostruisce l'intorno testuale del chunk corrispondente.

Un campo deve avere ruolo searchable se e solo se rappresenta testo suddiviso in chunk. La necessità che un campo searchable sia sempre chunkato è un vincolo imposto dalla natura del problema; il vincolo complementare, ovvero che ogni testo chunkato debba necessariamente avere ruolo searchable, è invece una decisione di progetto.

Come richiesto dal requisito #rcm-link("Alta configurabilità del sistema"), la fonte di verità deve essere definita esternamente, in modo da poter modificare il modello dati senza intervenire sul codice applicativo quando il sistema deve essere adattato all'evoluzione del contesto. Lo stesso requisito impone inoltre che siano configurabili esternamente i pesi di default della ricerca ibrida e i pesi di default utilizzati nelle singole ricerche di similarità; ogni richiesta di ricerca deve poter effettuare l'override di questi pesi, semplicemente fornendo i valori da utilizzare per quella specifica ricerca.

Per gestire l'arrivo di grandi volumi di dati non ordinati durante la fase di ingestion #rcm-link("Ingestion"), preservando al contempo la consistenza del sistema, il modello dati adotta un principio di staging: i dati in ingresso transitano attraverso un'area intermedia prima di essere resi disponibili alla ricerca, disaccoppiando così il processo di scrittura da quello di lettura.
=== Caratteristiche del database
Il modello dati si traduce sul database secondo le seguenti regole.

Per ogni entità sono previste due tabelle:
- una tabella principale, contenente tutti i campi non searchable definiti dal modello dati (privi di ruolo o con ruolo filterable);
- una tabella dei chunk, dedicata alla gestione dei molteplici campi chunkabili. Ha come chiave primaria la coppia composta dalla chiave esterna verso la tabella principale, dal campo di provenienza del testo e dal numero del chunk. Contiene inoltre tutti i campi necessari alla ricerca: il vettore di embedding, la lingua, il testo in chiaro e la rappresentazione utilizzata per la ricerca full-text (approfondita nella @gestione-tsv).

Per motivi di ottimizzazione, i campi con ruolo filterable vengono inoltre replicati sulla tabella dei chunk, in aggiunta alla loro presenza nella tabella principale. Questa denormalizzazione mira a riprodurre il meccanismo di pre-filtering di Elasticsearch: avendo i campi filterable già presenti e indicizzati direttamente sulla tabella dei chunk, il query planner di Postgres può scegliere di applicarlo autonomamente quando una clausola di filtro risulta sufficientemente selettiva.

Questa necessità nasce da una differenza di principio tra le due tecnologie: Elasticsearch ottimizza per default tutto ciò che non viene esplicitamente escluso dall'indicizzazione, mentre Postgres adotta l'approccio opposto, ottimizzando solo ciò che viene esplicitamente predisposto a tale scopo. La denormalizzazione dei campi filterable sulla tabella dei chunk è quindi il meccanismo con cui il sistema compensa questa differenza, rendendo esplicitamente disponibile al planner ciò che in Elasticsearch sarebbe già ottimizzato di default.

La stessa struttura facilita inoltre l'introduzione futura di ottimizzazioni mirate a sottoinsiemi di dati, ad esempio con gli indici parziali.

==== Gestione della staging area <gestione-staging-area>
Nella staging area vengono replicate solo le tabelle delle entità e dei chunk.

Poiché le sessioni di ingestion vengono avviate e concluse esplicitamente, il database deve tenerne traccia dello stato. A tale scopo sono previste due tabelle:
- una tabella per registrare lo stato delle sessioni di ingestion;
- una tabella per tenere traccia delle richieste di ingestion, necessaria per verificare se vi siano ancora scritture in corso.

Una sessione può assumere i valori aperta, chiusa e finalizzata: aperta indica che l'ingestion è attiva e può accettare nuovi dati; chiusa indica che l'ingestion è ancora attiva ma non accetta più dati, poiché è in corso la promozione dei dati dalla staging area verso le tabelle reali; finalizzata indica una sessione conclusa, unica condizione a partire dalla quale può essere aperta una nuova sessione. Deve inoltre essere garantito che possa esistere al più una sessione di ingestion attiva (aperta o chiusa) alla volta.

La promozione è il processo che trasforma e trasferisce i dati dalla staging area verso le tabelle reali, eliminando contestualmente i dati trascritti con successo.

La staging area si differenzia dalle tabelle originali nei seguenti punti:
- la chiave primaria è uno staging id incrementale, il che permette di gestire eventuali duplicati in fase di staging e garantisce una maggiore velocità di scrittura;
- non viene utilizzato il tipo vector: la staging area non necessita di essere interrogabile per similarità, pertanto gli embedding sono memorizzati come vettori di double;
- gli indici vengono creati esclusivamente sulle chiavi esterne, al fine di favorire i join necessari in fase di verifica per la promozione dei dati verso le tabelle definitive;
- le tabelle di staging dei chunk non sono denormalizzate: la denormalizzazione viene gestita dalla logica di promozione, in modo da mantenere l'ingestion disaccoppiata da questa responsabilità.

=== Tipologie di ricerca e requisiti implementativi
Data la natura esplorativa del progetto, per tutte le entità del modello dati vengono adottate le medesime impostazioni: i vettori di embedding sono calcolati con lo stesso modello, con le medesime ottimizzazioni e la medesima funzione di distanza; analogamente, per la ricerca full-text viene utilizzata la stessa configurazione testuale per tutte le entità e la stessa funzione di ranking.

Questa scelta semplifica la progettazione iniziale del sistema, rimandando l'eventuale differenziazione delle impostazioni per singola entità a sviluppi futuri, qualora emergessero esigenze specifiche non coperte da una configurazione uniforme.


L'adozione di impostazioni uniformi evita inoltre problemi in fase di combinazione dei risultati tra entità diverse, poiché garantisce che i punteggi prodotti dalle ricerche su entità distinte siano direttamente paragonabili. Anche qualora questa comparabilità diretta venisse meno, ad esempio in seguito a una futura differenziazione delle configurazioni per singola entità, il sistema resterebbe comunque estendibile adottando la stessa logica di fusione RRF già utilizzata per la ricerca ibrida. Questo introdurrebbe però un doppio livello di fusione una prima volta all'interno della ricerca ibrida sulla singola entità, una seconda volta nella combinazione tra entità con il rischio di appiattire sfumature o differenze significative nella fase intermedia.

Il presente lavoro non affronta la questione della paragonabilità diretta tra i punteggi prodotti da due o più fusioni RRF: stabilire se un semplice rescoring sia sufficiente, oppure se sia necessario un ulteriore livello di fusione, resta un aspetto da approfondire in lavori futuri.

==== Ricerca semantica <analisi-ricerca-semantica>
La configurazione condivisa per la ricerca semantica, richiamata in apertura di sezione, recepisce le seguenti ottimizzazioni raccomandate da pgvector:

#list(
  [
    *Partizionamento*: le tabelle dei chunk vengono partizionate sul nome del campo dati di origine. pgvector raccomanda il partizionamento quando si effettuano filtri su un insieme ristretto di valori; tale filtro è necessario per supportare le ricerche ristrette a un sottoinsieme di campi.
  ],
  [
    *Tipo di indice*: viene adottato un indice HNSW. Si tratta di una scelta relativamente arbitraria tra le opzioni disponibili, motivata dal fatto che si adatta meglio a scenari con inserimenti incrementali, coerenti con il principio di staging adottato per l'ingestion.
  ],
  [
    *Indice composto*: l'indice HNSW viene costruito su vettori a precisione ridotta, al fine di contenere il consumo di memoria.
  ],
  [
    *Oversampling*: pgvector raccomanda l'utilizzo di oversampling con rescoring in combinazione con l'uso di indici, in particolare quando questi sono costruiti su vettori a precisione ridotta, come nel caso descritto sopra.
  ],
  [
    *Convenzione sui punteggi*: per motivi di ottimizzazione interna e di coerenza tra le metriche disponibili, pgvector restituisce sia la cosine similarity sia l'inner product in una forma per cui il risultato più pertinente corrisponde al valore più basso (calcolando l'inner product con segno negativo e la cosine similarity in modo analogo). Questa convenzione viene tradotta internamente, in modo che l'utente del sistema non debba conoscere né ragionare in base al funzionamento interno di pgvector.
  ],
  [
    *Scelta della metrica*: per i vettori già normalizzati viene utilizzato l'inner product al posto della cosine similarity, poiché sui vettori normalizzati i due valori sono equivalenti a meno di una costante, ma il calcolo dell'inner product risulta meno oneroso.
  ],
)
==== Ricerca full-text <descr:ricerca-full-text>
Le funzionalità e le caratteristiche della ricerca full-text derivano principalmente dal requisito #rcm-link("Ricerca full text ottimizzata su lingua") e dalla necessità di implementare un insieme minimo di funzionalità che avvicinino la ricerca full-text a quella offerta da Elasticsearch, limitatamente ai casi d'uso di questo progetto.

Le caratteristiche minime da replicare e i relativi workaround elaborati sono i seguenti:

#list(
  [
    *Text analyzer multipli*:

    per ogni chunk di testo sono necessari due text analyzer distinti, uno agnostico rispetto alla lingua e uno specifico per la lingua. Per sopperire alla mancanza di un supporto nativo a configurazioni di testo multiple, si sfrutta il fatto che il numero di configurazioni necessarie per campo è limitato (una language-agnostic e una language-specific), utilizzando due tsvector distinti per la ricerca non specifica e per quella specifica per lingua. La gestione dei tsvector è approfondita nella @gestione-tsv.
  ],
  [
    *Funzione di ranking granulare*:

    Elasticsearch e altri motori di ricerca full-text avanzati permettono di definire query con meccanismi di boosting dei risultati basati sull'accuratezza della corrispondenza, ad esempio assegnando un punteggio più alto a un testo che soddisfa tutte le clausole di una query composta (clausole in OR, phrase query, all-words query, ecc.).

    La ricerca full-text di Postgres non implementa nativamente questo comportamento: le sue funzioni di ranking si limitano a verificare il rispetto della query, calcolando un punteggio solo in caso positivo e restituendo zero altrimenti. Per simulare il comportamento desiderato è quindi necessario calcolare e sommare separatamente il punteggio delle singole sotto-query.
  ],
  [
    *Query di filtro*:

    Nativamente Postgres offre tre tipologie di query per ranking e filtraggio: phrase query (corrispondenza di una frase), all-words query (corrispondenza di tutte le parole) e any-word query (corrispondenza di almeno una parola); a ciascuna di queste è possibile aggiungere, per singola parola, un carattere jolly per la ricerca per prefisso.

    Non è previsto alcun supporto nativo per una corrispondenza di almeno X parole. La sua replicazione tramite composizione di tsquery è stata esclusa per l'eccessiva complessità computazionale. È stato quindi adottato un workaround che tratta i tsvector come array di testo ordinati lessicograficamente, ordinamento gestito nativamente da Postgres in fase di creazione del tsvector: questa precondizione di ordinamento consente di ridurre significativamente la complessità della ricerca, richiedendo tuttavia, ai fini dell'ottimizzazione, un tipo di indice diverso da quello utilizzato per le altre query full-text. Da questa scelta deriva che tale meccanismo non può essere utilizzato per il ranking, poiché non produce una tsquery; questo non costituisce una limitazione, poiché anche in Elasticsearch un vincolo di questo tipo viene utilizzato solo ai fini del filtraggio, mentre l'ultimo livello di ranking è affidato a una any-word query.
  ],
)

La ricerca avviene sempre per partizione, anche quando ciò non è strettamente necessario: questa scelta semplifica l'applicazione dei pesi e consente di riutilizzare la struttura già adottata per la ricerca semantica.

Per quanto riguarda il comportamento richiesto dal requisito #rcm-link("Ricerca full text ottimizzata su lingua"), la ricerca ottimizzata su lingua si limita a filtrare sul campo lingua del chunk, operazione ottimizzata tramite un indice parziale dedicato per ciascuna lingua supportata. La ricerca multilingua, invece, esegue una prima ricerca utilizzando la configurazione di testo non language-specific, seguita da una ricerca language-specific per ciascuna delle lingue previste a catalogo. Questo approccio è sostenibile proprio perché il numero di lingue supportate è ridotto, a fronte di un volume di dati considerevole per ciascuna di esse. I risultati delle diverse ricerche vengono infine combinati tramite rescoring.

===== Ricerca con soglia di corrispondenza <overlap-text-query>
Elasticsearch permette di definire una soglia di corrispondenza minima tramite il parametro minimum_should_match, che consente di richiedere che solo una percentuale o un numero minimo di termini della query sia presente nel documento, con soglie che possono variare in funzione della lunghezza della query stessa (query già elaborata dalla configurazione testuale, con le stopword rimosse). Postgres non offre alcun operatore nativo equivalente.

Prima di arrivare alla soluzione adottata, sono stati considerati e scartati due approcci alternativi:
- un prefiltro costruito come OR di tutti i termini della query, seguito dal conteggio esatto dei match sui soli candidati. Sebbene l'OR sia indicizzabile tramite GIN, per query lunghe o composte da termini poco selettivi il filtro produce un insieme di candidati che copre una porzione consistente della tabella, vanificando il beneficio dell'indice;
- la generazione combinatoria di tutte le clausole AND di k termini su n, unite da OR. Il numero di combinazioni cresce secondo C(n,k), risultando rapidamente insostenibile all'aumentare della lunghezza della query.

La soluzione adottata sfrutta il fatto che Postgres ordina nativamente i lessemi in fase di creazione del tsvector (approfondito in @gestione-tsv): il tsvector viene trattato come un array ordinato lessicograficamente, e il problema della corrispondenza minima viene ricondotto a un controllo di overlap tra array, tramite l'indice dedicato già introdotto nella sezione precedente.

L'ordinamento lessicografico è ciò che rende possibile ricondurre il problema a un semplice controllo su un prefisso dell'array, anziché a un'esplosione combinatoria di sottoinsiemi da verificare: garantendo un ordine deterministico e condiviso tra la query e ogni documento candidato, permette di individuare tramite un singolo slice, calcolato una sola volta sull'array della query, quali posizioni è sufficiente controllare.

Questo meccanismo costituisce un prefiltro, secondo lo stesso principio già adottato dalla ricerca full-text nativa di Postgres, dove il filtraggio tramite indice GIN precede il calcolo del ranking. Il prefiltro rappresenta una condizione necessaria, ma non sufficiente, rispetto alla soglia richiesta: per costruzione, un documento che soddisfa realmente la soglia richiesta contiene necessariamente almeno un match tra i lessemi verificati dal filtro, per un argomento riconducibile al #gl("principio-dei-cassetti").
Se un documento matcha almeno k lessemi su n totali, non è possibile che tutti i match cadano al di fuori del prefisso controllato dal filtro, poiché al di fuori di esso restano solo k-1 posizioni, insufficienti a raggiungere la soglia. 
Il filtro può tuttavia produrre falsi positivi, poiché verifica solo la presenza di almeno un match nel prefisso, senza garantire che il numero totale di match nel documento raggiunga effettivamente la soglia richiesta. Per questo motivo il prefiltro deve sempre essere seguito da un conteggio esatto dei match sui soli candidati sopravvissuti, così da scartare gli eventuali falsi positivi e verificare la soglia effettiva.

Rispetto all'approccio precedentemente adottato, basato su una any-word query utilizzata anche ai fini del filtraggio, questa soluzione riduce sensibilmente il numero di candidati da valutare singolarmente, poiché il filtro per overlap è più selettivo pur restando indicizzabile.
===== Gestione dei tsvector <gestione-tsv>
La documentazione ufficiale di Postgres non esprime una preferenza netta tra due strategie di ottimizzazione delle ricerche full-text: l'uso di indici su espressione oppure la materializzazione dei tsvector in colonne dedicate. I primi sono più leggeri in termini di spazio occupato, ma più difficili da gestire rispetto ai vettori materializzati.

Per questo progetto si è scelto di materializzare i tsvector. Alla tabella dei chunk sono state aggiunte due colonne: una per il tsvector language-agnostic e una per quello language-specific. È stata prevista una sola colonna per la versione language-specific, e non una per lingua, poiché ogni chunk ha una singola lingua assegnata e non richiede supporto multilingua a livello di singolo chunk.

La scelta di materializzare è motivata in particolare dal workaround adottato per il filtro di corrispondenza minima descritto in @overlap-text-query, che richiede un indice dedicato costruito sull'array derivato dal tsvector.

L'alternativa sarebbe stata mantenere due indici su espressione distinti, uno per il ranking full-text nativo e uno per il filtro overlap. A livello di spazio occupato dagli indici stessi, le due strategie sono equivalenti: la materializzazione non comporta alcun risparmio in tal senso, e anzi introduce un costo aggiuntivo, poiché le colonne materializzate occupano spazio extra su disco rispetto al calcolo del tsvector a runtime tramite indici su espressione. Il motivo principale della scelta è quindi di comodità implementativa: avere le colonne materializzate consente di costruire su di esse entrambi gli insiemi di indici senza dover ripetere la stessa espressione in più punti dello schema.

Resta aperto, e non è stato oggetto di analisi approfondita in questo lavoro, il trade-off tra il costo di ricalcolare il tsvector a ogni interrogazione (nel caso di indici su espressione) e lo spazio extra occupato dalla loro materializzazione: una valutazione più rigorosa richiederebbe ulteriori valutazioni e i risultati di sperimentazioni reali.

I due insiemi di indici, quello per la ricerca full-text nativa e quello per il filtro overlap, coesistono sulle stesse colonne materializzate. Questa scelta è coerente con la natura esplorativa del progetto: mantenerli distinti mantiene le due strategie intercambiabili, semplificando la sperimentazione. Qualora si decidesse in futuro di abbandonare il filtro overlap o l'uso delle tsquery per il filtraggio, l'indice corrispondente può essere eliminato senza conseguenze, poiché le funzioni di ranking native di Postgres non richiedono la presenza di un indice per funzionare.

In entrambi i casi è necessario un indice generico per la ricerca language-agnostic e una serie di indici parziali, uno per lingua, per la ricerca language-specific.
==== Ricerca ibrida
La ricerca ibrida combina i risultati della ricerca semantica e della ricerca full-text sulla medesima entità, fondendoli tramite l'algoritmo di Reciprocal Rank Fusion. Si tratta di una tecnica standard per la fusione di risultati provenienti da fonti con punteggi non direttamente paragonabili tra loro, quali quelli prodotti dalla ricerca semantica e dalla ricerca full-text.

La fusione viene eseguita interamente lato database, in un'unica query, coerentemente con il requisito #rcm-link("Roundtrip unico per le ricerche"). Questa scelta non è motivata da una maggiore velocità di calcolo di Postgres rispetto al backend applicativo, piuttosto dal fatto che eseguire la fusione lato applicativo richiederebbe un round-trip di rete aggiuntivo tra database e backend per un'operazione che può essere svolta interamente all'interno del database stesso, senza necessità di scambiare dati con l'esterno.

Una pratica consigliata per la ricerca ibrida è l'applicazione di un oversampling sia sui risultati della ricerca semantica sia su quelli della ricerca full-text, prima della fusione. Questo permette di non perdere risultati che una delle due tecniche posiziona appena al di fuori del numero di risultati richiesto, mentre l'altra li colloca in una posizione sufficientemente alta: includerli nella fusione permette a tali risultati di ricevere, correttamente, un punteggio più alto di quanto riceverebbero se venissero esclusi a monte.
Tale oversampling non è in alcun modo connesso all'oversampling della ricerca semantica.

==== Ricerca linked <analisi-ricerca-linked>
La ricerca linked permette di recuperare, a partire dalle singole entità, un quadro informativo più ampio ricostruito risalendo le relazioni verso le entità collegate, anziché restituire un singolo frammento isolato. Ad esempio, a partire da un attachment è possibile risalire le relazioni passando per il conversation item associato fino ad arrivare al ticket, restituendo le informazioni di tutte le entità coinvolte in un'unica chiamata. Questa funzionalità è particolarmente rilevante nel contesto dell'information retrieval applicato a basi di conoscenza strutturate e relazionate tra loro, dove il contesto rilevante per un'informazione raramente è contenuto interamente in una singola entità isolata.

Nello specifico, la ricerca linked esegue prima una ricerca indipendente su ciascuna entità coinvolta, per poi ricostruire, seguendo le regole di linking definite nel modello dati, i collegamenti tra i risultati tramite join.

Per "risalita" si intende la navigazione delle relazioni dall'entità figlia verso l'entità genitore (ad esempio da attachment verso conversation item, e da conversation item verso ticket). Il progetto supporta esclusivamente questa direzione di navigazione: la discesa, oltre a non essere banale da implementare, non rientra tra gli interessi dell'azienda per questo tirocinio.

Alcune entità, come attachment, dispongono di più regole di linking possibili verso entità diverse (ad esempio verso conversation item oppure direttamente verso ticket). Per questi casi si è scelto di adottare la regola del primo cammino valido: viene applicata la prima regola di linking per cui è presente un riferimento effettivo, e le successive vengono considerate solo in sua assenza ad esempio, se un attachment non presenta un riferimento diretto a un ticket, viene utilizzato il riferimento al conversation item, qualora presente.

Questa regola nasce da una scelta di disaccoppiamento più generale. Nei dati reali, un attachment non può avere contemporaneamente un riferimento sia a un conversation item sia a un ticket: si tratta di un vincolo di integrità proprio del modello dati, che tuttavia non è stato implementato come constraint a livello di singola entità (né tramite controllo a database né nella logica applicativa), poiché ritenuto fuori dal perimetro di questo progetto e di scarso beneficio pratico rispetto alla complessità che avrebbe introdotto. Anche qualora fosse stato implementato, associarlo direttamente alle regole di linking non sarebbe stata una soluzione opportuna, per lo stesso principio di separazione già adottato tra la configurazione della ricerca linked e la definizione dei vincoli relazionali tramite chiavi esterne. La regola del primo cammino valido permette quindi alla ricerca linked di funzionare correttamente a prescindere dall'esistenza o meno di un simile vincolo, mantenendo il meccanismo disaccoppiato e più facilmente estendibile in futuro.

Per la ricerca linked ibrida, la fusione RRF tra i risultati di ricerca semantica e full-text viene eseguita a livello di singola entità, prima dell'esecuzione del linking. Questa scelta rispecchia il comportamento di Elasticsearch nello stesso scenario.


==== Pipeline di esecuzione delle ricerche
In questa sezione viene illustrato l'ordine delle operazione eseguite per ogni tipo di ricerca.
#list(
  [
    La *ricerca semantica* si articola come segue:
    + ricerca sulla singola partizione della tabella dei chunk, con applicazione dell'oversampling necessario, come descritto in precedenza, quando si opera su indici a precisione ridotta e applicazione del filtro definito dall'utente;
    + applicazione della soglia di threshold sul raw score;
    + applicazione del peso configurato per campo, successivamente al threshold e precedentemente alla combinazione dei risultati;
    + combinazione dei risultati delle diverse partizioni tramite rescoring semplice, sufficiente perché i punteggi sono direttamente comparabili tra loro;
    + join sulla tabella principale, per il recupero dei dati richiesti;
    + restituzione dei dati richiesti dalla query.
  ],
  [
    La *ricerca full-text* si articola in due varianti: ottimizzata sulla lingua e multilingua.

    La ricerca ottimizzata sulla lingua si articola come segue:
    + ricerca sulla singola partizione, con selezione per lingua, esecuzione dell'overlap query o di un'altra query full-text configurata, e applicazione del filtro definito dall'utente;
    + applicazione della soglia di threshold sul raw score;
    + applicazione del peso configurato per campo, successivamente al threshold e precedentemente alla combinazione dei risultati;
    + combinazione dei risultati tramite rescoring semplice, per lo stesso motivo di comparabilità già descritto per la ricerca semantica;
    + join sulla tabella principale, per il recupero dei dati richiesti;
    + restituzione dei dati richiesti dalla query.

    La ricerca multilingua riutilizza le ricerche specifiche per lingua appena descritte:
    + esecuzione della ricerca language-agnostic, articolata come le ricerche language-specific;
    + esecuzione delle ricerche language-specific, una per ciascuna lingua supportata a catalogo, ciascuna strutturata secondo i passi della ricerca ottimizzata su lingua descritta sopra;
    + combinazione dei risultati tramite rescoring semplice, non è necessario un ulteriore join, poiché ciascuna ricerca sottostante lo ha già effettuato;
    + restituzione dei dati richiesti dalla query.
  ],
  [
    La *ricerca ibrida* si articola come segue:
    + esecuzione della ricerca full-text, recuperando solo le chiavi primarie e i valori restituiti sempre (nome del campo, testo matchato, numero del chunk); la fusione RRF opera infatti sull'ordinamento dei risultati, non richiede il raw score;
    + esecuzione della ricerca semantica, con lo stesso criterio di recupero minimale;
    + combinazione dei risultati tramite RRF, applicando i pesi di bilanciamento tra ricerca semantica e full-text: a differenza del rescoring semplice, qui è necessaria la fusione RRF poiché i punteggi delle due tecniche non sono direttamente comparabili tra loro;
    + join sull'entità principale, eseguito una sola volta sui risultati già fusi, evitando di recuperare i dati completi due volte per la stessa entità;
    + restituzione dei dati richiesti dalla query.
  ],
  [
    La *ricerca linked*, indipendentemente dal tipo di ricerca sottostante, esegue le seguenti operazioni:
    + esecuzione della ricerca dello stesso tipo specificato per ciascuna entità coinvolta, garantendo la restituzione delle chiavi primarie;
    + join per ricostruire l'informazione completa, seguendo le regole di linking definite nel modello dati;
    + applicazione di un filtro successivo al join;
    + combinazione dei risultati delle ricerche sulle diverse entità tramite rescoring semplice: i punteggi prodotti dalle ricerche sulle singole entità sono in questo caso direttamente comparabili, e non richiedono quindi una fusione RRF;
    + restituzione dei dati richiesti dalla query.

    Nel caso specifico della ricerca linked ibrida, i pesi per campo vengono applicati a livello di singola entità prima della fusione RRF che le combina, anziché successivamente. Si tratta di una deviazione rispetto al principio generale di applicare i pesi dopo la fase di filtraggio e prima della combinazione, ma è una scelta ritenuta accettabile poiché lo stesso comportamento è adottato da Elasticsearch in scenari analoghi.
  ]
)

Per garantire un round-trip unico, come richiesto dal requisito #rcm-link("Roundtrip unico per le ricerche"), le diverse sequenze di query vengono combinate tramite clausole WITH, costruendo la query complessiva in modo incrementale: ogni livello successivo può fare riferimento alle proprie sotto-query come se fossero dati già disponibili. È importante che le singole porzioni definite tramite WITH non materializzino porzioni di tabella di dimensione non limitata, ma vengano sempre delimitate a un numero finito e contenuto di record tramite clausole LIMIT.


=== Caratteristiche del backend
Il backend organizza le impostazioni generali di ricerca tramite oggetti di configurazione strutturati, costruiti a monte e iniettati nei livelli che compongono la ricerca. Questa struttura, coerentemente con il requisito #rcm-link("Alta configurabilità del sistema"), permette di effettuare l'override dei pesi per una singola richiesta di ricerca; in assenza di override, vengono applicati i pesi di default definiti nel modello dati.

Le configurazioni contenenti i pesi sono oggetti di dominio, agnostici rispetto alla tecnologia sottostante, e associano a ciascuna entità i seguenti valori:
- la lista dei pesi da applicare ai vari campi dati durante il rescoring;
- i pesi da applicare nella fusione tra ricerca semantica e full-text.

Le configurazioni che gestiscono aspetti più tecnici, e non separabili dalla tecnologia utilizzata, sono invece oggetti distinti e specifici per la ricerca full-text e per la ricerca semantica.

La configurazione per la ricerca semantica specifica le seguenti informazioni:
- il tipo di vettore a cui convertire il vettore di embedding durante la fase di oversampling;
- la distanza da utilizzare in fase di oversampling;
- il numero di record da sommare al numero di risultati richiesti, in fase di oversampling;
- il threshold, espresso come semplice valore in virgola mobile;
- la dimensione dei vettori di embedding;
- il tipo reale del vettore così come memorizzato nel database;
- il tipo di distanza da applicare durante il rescoring.

L'oggetto che gestisce concretamente il threshold in funzione del tipo di distanza utilizzato viene assemblato solo quando necessario, poiché deriva dalla combinazione del threshold, espresso come semplice valore, con il tipo di distanza applicato in quel contesto.

La configurazione per la ricerca full-text contiene invece le seguenti informazioni:
- la funzione di ranking da utilizzare, ts_rank oppure ts_rank_cd;
- l'elenco delle tsquery da utilizzare nelle funzioni di ranking, necessario per gestire la composizione di una funzione di ranking più avanzata;
- un fattore opzionale per la normalizzazione dei punteggi che, come indicato dalla stessa documentazione di Postgres, ha un'utilità relativamente limitata;
- la clausola da utilizzare per il filtro full-text, che può essere una tsquery oppure una overlap query.

Per la ricerca ibrida, un ulteriore oggetto di configurazione definisce:
- l'oversampling applicato ai risultati precedentemente alla fusione, descritto nella sezione dedicata alla ricerca ibrida;
- la costante k che regola il comportamento della fusione RRF, il cui valore standard è 60, pur lasciando la possibilità di modificarlo.

Le diverse sotto-ricerche che compongono una ricerca, descritte nella pipeline di esecuzione, vengono costruite come un unico blocco di query, eseguito una sola volta, coerentemente con il requisito #rcm-link("Roundtrip unico per le ricerche").

Il backend deve inoltre essere asincrono, per supportare l'accesso concorrente di più utenti senza che l'elaborazione di una richiesta blocchi le altre.

Anche la fase di ingestion adotta un principio di riduzione del numero di chiamate, applicato in modo trasversale ai diversi servizi coinvolti: i testi vengono organizzati e inviati a blocchi verso il modello di embedding remoto, così da pagare un costo di attesa complessivo inferiore rispetto all'esecuzione di numerose chiamate singole. Lo stesso principio si applica alle eventuali funzionalità di elaborazione a batch offerte dagli strumenti di language detection, e alle scritture verso il database, effettuate a blocchi anziché tramite una serie di chiamate singole.

== Principi del sistema di test
In questa sezione vengono descritti i principi guida e le caratteristiche del sistema di test.

=== Definizione modello dati 
Il modello dati del sistema di test è composto da due parti: una riadattata dal modello dati del sistema principale, e una dedicata alla gestione della ground truth e del logging, trattata in @caratteristiche-db-test.

Per quanto riguarda la parte riadattata, il sistema di test adotta una versione semplificata del modello dati del sistema principale: la definizione delle entità è la medesima, ma vengono meno i dettagli legati alla configurabilità, quali le configurazioni di ricerca e i vincoli relazionali. Anche la struttura delle ricerche è la stessa di quella descritta per il sistema principale, rimangono solo le parte ritenute utili per la finalità di allineamento all'ambiente di test.

Questa scelta è il risultato di un riutilizzo di comodità del codice esistente: i due progetti restano comunque indipendenti a livello di codice, e l'unico punto di contatto tra i due sistemi è l'interfaccia API del sistema principale, utilizzata dal sistema di test come da qualunque altro utente.

=== Metriche e il loro significato
Le metriche di valutazione trattate in questa sezione non sono state definite autonomamente, ma fornite durante un colloqui con il tutor aziendale, secondo la seguente definizione e significato.

Le metriche valutate sono le seguenti:
#list(
  [
    *Retrieval latency*: indica il tempo trascorso tra l'invio di una richiesta di ricerca e la ricezione della relativa risposta.
  ],
  [
    *Retrieval answer rate*: indica la frequenza con cui la ground truth attesa per una query è stata restituita tra i risultati, indipendentemente dalla posizione occupata.
  ],
  [
    *Retrieval mean reciprocal rank*: indica la media dei reciproci della posizione in cui la ground truth compare tra i risultati restituiti.
  ],
  [
    *Retrieval hitrate\@1*: indica la frequenza con cui la ground truth viene restituita come primo risultato.
  ],
  [
    *Retrieval hitrate\@5*: indica la frequenza con cui la ground truth viene restituita tra i primi cinque risultati.
  ],
  [
    *Retrieval hitrate\@10*: indica la frequenza con cui la ground truth viene restituita tra i primi dieci risultati.
  ],
  [
    *Retrieval wins*: indica il numero di volte in cui una ricerca ha prodotto almeno un risultato.
  ],
  [
    *Retrieval not found*: indica il numero di volte in cui una ricerca non ha prodotto alcun risultato.
  ],
)

La differenza tra retrieval answer rate e retrieval wins, per quanto sottile, è particolarmente significativa: un answer rate basso a fronte di un numero elevato di wins indica che il sistema restituisce con frequenza risultati che, pur presenti, non sono rilevanti rispetto alla query.

=== Caratteristiche del backend
Il backend simula un insieme di utenti paralleli tramite Locust, secondo quanto richiesto dal requisito #rcm-link("Specifiche sistema di test"). Le richieste non vengono eseguite direttamente dagli utenti simulati, ma tramite una singola porta inbound (run_one), che preleva una query da una coda, la esegue e ne registra il risultato.

Il backend non calcola direttamente le metriche di valutazione, ma si limita a registrare i risultati grezzi delle ricerche eseguite.

=== Caratteristiche del database <caratteristiche-db-test>
Il sistema di test adotta due meccanismi di persistenza distinti, ciascuno scelto in base alla natura dell'accesso richiesto.

Il registro delle query da eseguire, comprensivo della relativa ground truth, è mantenuto in un file jsonl: una soluzione ritenuta sufficiente data la natura strettamente sequenziale della sua lettura.

I risultati delle ricerche eseguite vengono invece registrati in un database Postgres, necessario per gestire in modo affidabile le scritture concorrenti provenienti dai diversi utenti simulati. Lo stesso database viene inoltre utilizzato per automatizzare il calcolo delle metriche, esposte sotto forma di viste, e può essere monitorato tramite Grafana.