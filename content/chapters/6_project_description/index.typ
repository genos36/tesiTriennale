#import "/plugin/mod.typ": gl, glpl
#import "/metadata/mod.typ": data
#import "/plugin/mod.typ" : code-snippet
#pagebreak(to: "odd")

#heading("Implementazione", depth: 1)<cap:lavoro-svolto>

#text(style: "italic", [
  In questo capitolo approfondisco le fasi di sviluppo del progetto, descrivendo le scelte implementative concrete e le problematiche affrontate nella realizzazione del sistema di information retrieval e del sistema di test.

])
#v(1em)

L'implementazione viene divisa in sistema principale e sistema di test. 
== Sistema principale

=== Architettura del codice
La progettazione e la codifica seguono i principi dell'architettura esagonale. Il codice è quindi organizzato nelle seguenti categorie:
- inbound adapter,
- outbound adapter,
- inbound port,
- outbound port,
- service,
- classi di dominio.

La composition root è gestita tramite FastAPI.

Ciascuna categoria è ulteriormente suddivisa per funzionalità: ingestion e le diverse tipologie di ricerca dispongono ciascuna dei propri adapter, service e port dedicati.

Fanno eccezione delle classi di dominio condivise che sono trattate nella @classi-dominio-condivise a loro dedicata

==== Classi di dominio condivise<classi-dominio-condivise>
Le classi di dominio condivise rappresentano il modello dati descritto nella @main-system-definizione-modello-dati, e costituiscono la fonte di verità del sistema. Vengono costruite e validate una sola volta nella composition root, e da lì iniettate nelle componenti del sistema che necessitano di conoscere il modello dati.

*EntityName* e *FieldName* sono due semplici wrapper attorno a una stringa, adottati per rendere il codice più leggibile e per impedire, a livello di firma, di confondere un identificativo di entità con uno di campo o con una stringa qualunque.

*FieldReference* rappresenta un riferimento a un campo specifico di un'entità specifica, tramite la coppia nome dell'entità e nome del campo.

*FieldDefinition* descrive un campo dati di un'entità: nome, tipo e obbligatorietà, coerentemente con quanto già descritto nel modello dati. *FieldRole* e *FieldType* sono due enumerazioni che rappresentano rispettivamente i due ruoli supportati (searchable, filterable) e i tipi di dato supportati per un campo.

*Entity* rappresenta una singola entità dello schema, aggregando l'insieme dei suoi campi, i campi identificativi e la configurazione di ricerca (ruoli e pesi per campo). In fase di costruzione, Entity verifica la biimplicazione tra ruolo searchable e tipo di campo chunkato, già descritta come principio di progetto: un campo è marcato searchable se e solo se il suo tipo è testo suddiviso in chunk.

#code-snippet(caption: "Entity - dataclass e vincolo searchable/chunked_text",
raw(
  lang:"python",
`
@dataclass(frozen=True, slots=True)
class Entity:
    entity_name: EntityName
    identifier: frozenset[FieldName]
    field_definitions: Mapping[FieldName, FieldDefinition]
    entity_search_configuration: EntitySearchConfiguration

    def __post_init__(self) -> None:
        `.text+sym.dots.v+`
        for field_name, role in self.entity_search_configuration.roles.items():
            if role == FieldRole.SEARCHABLE and definition.field_type != FieldType.CHUNKED_TEXT:
                raise UnsupportedFieldTypeForSearchableRoleError(
                    f"Il campo {field_name!r} di tipo {definition.field_type!r} è marcato "
                    f"SEARCHABLE, ma solo {FieldType.CHUNKED_TEXT!r} è supportato per questo ruolo."
                )
            if definition.field_type == FieldType.CHUNKED_TEXT and role != FieldRole.SEARCHABLE :
                raise NonSearchableChunkTextError(
                    f"Il campo {field_name!r} di tipo {definition.field_type!r} non è marcato "
                    f"SEARCHABLE, ma {FieldType.CHUNKED_TEXT!r} deve essere searchable."
                )
                `.text+sym.dots.v
))

*MergeWeights* rappresenta i pesi utilizzati per la fusione tra ricerca semantica e full-text, con l'unico vincolo che non possano essere negativi.

===== Vincoli sullo schema
Il punto di estensione esplicito descritto nel modello dati, pensato per accomodare vincoli non necessariamente relazionali, è realizzato tramite il pattern Visitor. *SchemaConstraint* è l'interfaccia astratta comune a ogni tipo di vincolo; *RelationalSchemaConstraint* è l'unica implementazione concreta attualmente presente, e rappresenta l'equivalente concettuale di una chiave esterna tra due entità.

#code-snippet(caption: "SchemaConstraint e RelationalSchemaConstraint",
raw(
  lang:"python",
  `
class SchemaConstraint(ABC):
    @abstractmethod
    def accept(self, visitor: "SchemaConstraintVisitor") -> None:
        ...
class SchemaConstraintVisitor(ABC):
    @abstractmethod
    def visit_relational_constraint(self, constraint: "RelationalSchemaConstraint") -> None: ...
  `.text
)
)

Ogni tipo di vincolo espone un metodo accept, che delega a un'implementazione di *SchemaConstraintVisitor* l'operazione specifica per quel tipo. L'introduzione di un nuovo tipo di vincolo richiede quindi un nuovo metodo visit dedicato sull'interfaccia del visitor: da quel momento, qualunque visitor che non lo implementi non può più essere istanziato, e l'errore emerge già in fase di costruzione, non alla prima volta in cui il visitor incontra quel tipo di vincolo a runtime.

===== Ricerca linked e struttura a grafo
*GraphEdge* rappresenta un arco del grafo di navigazione tra entità utilizzato dalla ricerca linked, collegando due FieldReference in entità diverse; un arco non può collegare un'entità a se stessa, per evitare cicli non gestiti nell'attraversamento.

*LinkedSearchConfiguration* rappresenta l'intero grafo di navigazione, come mappa di adiacenza tra entità e archi uscenti, insieme ai pesi utilizzati nella fusione dei risultati tra entità diverse. In fase di costruzione viene verificata l'aciclicità del grafo; una volta garantita, per ciascuna entità vengono precalcolati tutti i cammini possibili verso la propria radice, rappresentati come sequenze ordinate di GraphEdge (*TraversalPath*).

#code-snippet(
  caption: "LinkedSearchConfiguration e TraversalPath",
raw(
  lang:"python",
  `

@dataclass(frozen=True, slots=True)
class LinkedSearchConfiguration:
    adjacency: Mapping[EntityName, Sequence[GraphEdge]]
    field_weights: LinkedFieldWeights
    _paths_to_root_cache: Mapping[EntityName, tuple[TraversalPath, ...]] = MappingProxyType({})  
    
class TraversalPath:
    hops: tuple[GraphEdge, ...]
    @property
    def origin_entity(self) -> EntityName:
        ⋮
    @property
    def root_entity(self) -> EntityName:
        ⋮
    @property
    def intermediate_entities(self) -> tuple[EntityName, ...]:
        ⋮
    @property
    def entities_in_order(self) -> tuple[EntityName, ...]:
        ⋮`.text
)

)

È importante notare che LinkedSearchConfiguration si limita a esporre, per ciascuna entità, l'insieme di tutti i cammini possibili verso la radice: non seleziona autonomamente un unico cammino. La regola del primo cammino valido, descritta nella @analisi-ricerca-linked, viene applicata a valle, dal query builder che genera la query SQL della ricerca linked, sulla base dei cammini restituiti da questa classe. Questa separazione è coerente con il principio di disaccoppiamento già discusso a proposito dei vincoli di integrità: il dominio si limita a descrivere le possibilità strutturali, mentre la logica di scelta concreta, che dipende dai dati effettivamente presenti, è responsabilità di un livello successivo.

===== Radice dell'aggregato
*SchemaConfiguration* è la radice dell'aggregato: raccoglie l'insieme delle entità, dei vincoli di schema e la configurazione di ricerca linked in un'unica struttura immutabile. Le entità sono rappresentate come mappa da nome a Entity, anziché come semplice sequenza, per garantire per costruzione l'assenza di duplicati e un accesso diretto in fase di risoluzione dei riferimenti.

#code-snippet(caption: "SchemaConfiguration - dataclass",
raw(
  lang:"python",
  `

@dataclass(frozen=True, slots=True)
class SchemaConfiguration:
    entities: Mapping[EntityName, Entity]
    schema_constraints: Sequence[SchemaConstraint]
    linked_search_configuration: LinkedSearchConfiguration
   `.text
)


)

SchemaConfiguration valida, in fase di costruzione, esclusivamente la coerenza strutturale locale (presenza di almeno un'entità, coerenza tra chiave e valore nella mappa delle entità). 
La validazione dell'integrità referenziale più profonda: l'esistenza e la compatibilità di tipo dei campi citati nei vincoli, l'esistenza delle entità citate nella configurazione di ricerca linked richiede invece una visione d'insieme dell'intero schema, non disponibile al singolo oggetto preso in isolamento, ed è per questo demandata a *SchemaConfigurationBuilder*.

Il builder accumula incrementalmente entità e vincoli, per poi eseguire, al momento della costruzione finale, l'intera catena di validazioni referenziali: la verifica dei vincoli di schema tramite il visitor descritto in precedenza, la coerenza della configurazione di ricerca linked rispetto alle entità effettivamente presenti, e la corrispondenza reciproca tra campi searchable e pesi configurati per la ricerca linked. Solo un'istanza di SchemaConfiguration prodotta da questo builder può quindi considerarsi garantita come valida nella sua interezza.

#code-snippet(caption: "SchemaConfigurationBuilder - firma di build()",
raw(
  lang:"python",
  `
class SchemaConfigurationBuilder:

    def build(self) -> SchemaConfiguration:
  `.text+sym.dots.v
)
)
=== Sistema di persistenza
Il diagramma in @diagramma-er rappresenta lo schema entità-relazione concreto adottato in questo progetto, coerente con il modello dati del service desk HDA descritto nel capitolo precedente. Trattandosi di un sistema configurabile, entità e campi possono essere personalizzati a seconda del contesto applicativo; lo schema qui presentato è quindi una delle possibili istanze concrete del modello dati, non un vincolo strutturale del sistema.

Inoltre si precisa che l'inizializzazione del db non avviene tramite codice sql scritto a mano, ma tramite script che leggono schema configuration e altre configurazioni come quella di pgvector. Questo è per comodità nella modifica dei parametri per ulteriori test futuri.
Non è stata dedicata particolare cura a questo script in quanto reputato oltre lo scopo del tirocinio, vi è molto margine di miglioramento.

#figure(caption:"Diagramma er del database")[
#image("/images/puml/schema_er_progetto.svg")
]<diagramma-er>

Alcuni aspetti rilevanti dello schema non sono rappresentabili graficamente in un diagramma entità-relazione, e vengono quindi descritti di seguito: il partizionamento delle tabelle e gli indici definiti su di esse.


Coerentemente con quanto descritto nella @analisi-ricerca-semantica in cui viene analizzata la ricerca semantica, la tabella dei chunk di ciascuna entità è partizionata per lista sul campo di provenienza del testo (field_name): ogni campo searchable dell'entità corrisponde a una partizione distinta.

Su ciascuna tabella dei chunk sono definite quattro famiglie di indici:
+ Gli indici GIN "classici" sulle colonne tsv_simple e tsv_lang, servono a velocizzare il filtering delle query full-text implementate da Postgres. Per tsv_lang l'indice è ulteriormente suddiviso in un indice parziale per lingua, filtrato sul valore di chunk_language;

+ due indici GIN con opclass array_ops sull'espressione tsvector_to_array(...) delle colonne tsv_simple e tsv_lang, utilizzati dal filtro di corrispondenza minima descritto in @overlap-text-query, che si appoggia all'operatore di overlap tra array (&&) anziché a @@. Anche questi indici sono suddivisi per lingua sulla colonna tsv_lang, visto che il look up è sempre filtrato per lingua;

+ un indice HNSW sulla colonna embedding, utilizzato dalla ricerca semantica. L'indice non è necessariamente costruito sui valori a piena precisione della colonna: la configurazione applicativa può specificare un tipo di vettore e una distanza "candidati", eventualmente più leggeri (ad esempio una quantizzazione binaria con distanza di Hamming), utilizzati per generare rapidamente l'insieme di candidati su cui viene poi eseguito l'oversampling e il rescoring finale sui valori reali. Nella configurazione concreta di questo progetto, l'indice è costruito su una quantizzazione binaria dell'embedding, con distanza di Hamming. \ Tutti gli indici elencati sono creati sulla tabella partizionata madre: Postgres li propaga automaticamente a ciascuna partizione.

+ Un indice univoco su un'espressione costante, sulla tabella delle sessioni di ingestion, filtrato sulle sole righe con stato aperta o chiusa: questo garantisce, a livello di database e non solo applicativo, che possa esistere al più una sessione attiva alla volta, coerentemente con il principio già descritto nella sezione @gestione-staging-area.

=== Ingestion
La funzionalità di ingestion consiste in 3/4 porte inbound, ognuna per una funzione specifica
- avvio della sessione di ingestion
- chiusura della sessione di ingestion 
- visione dello status della sessione di ingestion (in corso o terminata)+
- elaborazione di uno stream di batch

avvio e chiusura scrivono sulla tabella dell'ingestion status id per fungere da fonte di verità esterna, qualsiasi worker fastapi che prova ad aèrire o chiudere una sessione vede lo stesso db e le stesse informazioni.

la chiusura fa anche partire il processo di promozione da staging a reale

non vi sono contraddizioni tra l'uso del batching e il fatto che la porta accetta uno stream, il sistema va ad ottimizzare operazioni come calcolo di embedding, rilevazione della lingua e scrittura sul db solo su un batch.

lo stream permette semplicemente di gestire un flusso continuo di dati, oppure di ottimizzare trasmissioni effettuando l'invio di una lista di batch lato inbound adapter che poi il sistema traduce in uno stream. è giusto che la porta sia più flessibile dell'adapter. originariamente si voleva supportare l'inseriemnto in modalità stream tramite fastapi ma per poter inviare un errore per l'elaborazione dei vari record era necessaria una streaming response, tuttavia fast api non supporta ancora stream in input e output perciò lo stream di input è stato sostituito da una lista solo nell'adapter.

Lo scheduling viene fatto in base alle relational constraint definite nello schema configuration, dando priorità priam alla tabella dei metadati e poi si passa alla tabella dei chunk.

la promozione avviene come stabilito precedentemente, con una query che prende i dati validi e li passa sulla tabella reale senza far passare da python


#code-snippet(
  caption: "Staging promotion - Selezione elementi validi",
  raw(
    lang:"sql",
    `
    WITH staging_window AS (
    SELECT staging_id FROM {source_table}
    WHERE {where_clause}
    ORDER BY staging_id
    LIMIT {self._batch_size}
),`.text
)
)
Serve a selezionare un numero pari a self.\_batch_size di elementi che possono essere inseriti nella tabella reale e rimossi dalla tabella di staging.

Il sistema backend si occupa solo di costruire  un'opportuna where clause per verificare ch dopo la promozione rimangano rispettati i vincoli di entità referenziale.
ad esempio non vi è alcuna where clause per i ticket ma per i conversation item viene richiesto che il ticket id esista nella tabella reale.


#code-snippet(
  caption: "Staging promotion - gestione dei duplicati",
  raw(
    lang:"sql",
    `
batch AS (
    SELECT DISTINCT ON ({conflict_columns}) s.staging_id
    FROM {source_table} s
    JOIN staging_window w ON s.staging_id = w.staging_id
    ORDER BY {conflict_columns}, s.staging_id DESC
),`.text
)
)
La staging window viene espansa con tutti i possibili diuplicati degli elemnti presenti, vengono ordinati in ordine decresente, questo abbianto con l'autoincrement dello staging id e il distinct on  implica che vengono selezionati solo le versioni dei dati più recenti.

Questa soluzione si riconosce che non sia delle migliori, tuttavia funziona e per un progetto esplorativo è sufficiente. Lo staging per quanto utile non è centrale al problema

Viene riconosciuto debito tecnico da sanare in evoluzioni successive

#code-snippet(
  caption: "Staging promotion - Estrazione dei valori",
  raw(
    lang:"sql",
    `
    promoted AS (
    DELETE FROM {source_table}
    WHERE staging_id IN (SELECT staging_id FROM staging_window)
    RETURNING staging_id, {column_list}
),
`.text
)
)
Rimuove e salva momentaneamente il valore degli elementi candidati alla promozione 

#code-snippet(
  caption: "Staging promotion - Inserimento nella tabella reale",
  raw(
    lang:"sql",
    `
inserted AS (
    INSERT INTO {target_table} ({column_list})
    SELECT {column_list} FROM promoted
    WHERE staging_id IN (SELECT staging_id FROM batch)
    ON CONFLICT ({conflict_columns}) {conflict_action}
    RETURNING 1
)
),
`.text
)
)
Carica i dati nella tabella reale e specifica come gestire i conflitti con la tabella reale, non coi duplicati, l'azione specifica viene definita dal backend, 
in genere upsert


#code-snippet(caption: "Ritorno degli elementi inseriti",
  raw(
    lang:"sql",
    `
SELECT count(*) FROM staging_window`.text
  ),
)
Viene restituito il numero di inserimenti non il numero di record eliminati
la query di promozione viene rieseguita finchè non ritorna 0

Spostandoci invece sul lato backend

Si è deciso di usare dei usare un'astrazione detta field value invece di un insieme di tipi primitivi, la motivazione principale è l'evitare troppi tipi primitivi all'interno del dominio

vi sono poi delle union tipe dedicate ai dati in ingresso al db e ai dati destinati alla scrittura sul db, il service si occupa di prendere iu vari batch dello stream e per ognuno fare prima una validazione che controlla la coerenza con i dati che si vuole caricare con lo schema configuration, scarta i record non validi e passa un batch di record validi al un processor che si occupa dell'arricchimento con embedding e informazioni di lingua, sempre secondo la logica che se sono note a priori vengono usate quelle altrimeni si fa language detection, si scarta se ci sono errori.

i record rimanenti sono scritti su db tramite comnado copy


per gestire la notifca degli errori vi è uuna classe rejected record che contiene l'id dell'elemento e il motivo del fallimento,poi viene ritornato sempre sottoforma di un iteratore, poi fast api lo rimanda all'utente come streaming response
inoltre lo stato di scrittura di uno strema viene tracciato per garantire che alla chiusura tutti gli stream abbiano terminato la scrittura

il caso d'uso di visione dello stato di attività dell'ingestion serve solo al sistema di test per capire se durante una ricerca è in corso un processo di ingestion

=== Ricerca
Ogni tipo di ricerca ha un endpoint dedicato realizzato tramite un adapter fast api.

le classi di dominio sono diverse per ricerca linked e su singola entità, il filtro è complesso, ha una struttura annidata e richiede l'uso di un visitor per essere usato nei diversi contesti

per evitare duplicazione di codice eccessiva all'interno del dominio si è deciso di adottare l'uso dei generic e dei type alias.

i generic permettono il riutilizzo di codice senza creare relazioni di subtyping, mentre i type alias vengono usati da tutte le classi esterne alla catena di generic per facilitare modifiche future, un esempio concreto di questa cosa è avvenuto durante la realizzazione della ricerca linked in quanto presenta 2 serie di filtri.

per questo motivo verranno analizzate solo le parti generiche un esmpio di type alias e solo la parte di ricerca linked che differisce dalla versione generica

Ritengo doveroso anche aprire una parentesi sul filtering, viene adottato un approccio annidato, viene creata l'interfaccia filter condition con le implementazioni concrete: 
- atomic expression
- and condition
- or condition
-not condition

#code-snippet(
  caption:"Ricerca - Query semplice",
  raw(
  lang:"python",
    `
class FilterCondition(ABC, Generic[R]):
    @abstractmethod
    def accept(self, visitor: FilterVisitor[R, T]) -> T: ...

@dataclass(frozen=True, slots=True)
class AtomicExpression(FilterCondition[R], Generic[R]):
    field: R
    operator: Operator
    value: FieldValue
    def accept(self, visitor: FilterVisitor[R, T]) -> T:
        return visitor.visit_atomic_expression(self)

@dataclass(frozen=True, slots=True)
class AndCondition(FilterCondition[R], Generic[R]):
    terms: tuple[FilterCondition[R], ...]
    def accept(self, visitor: FilterVisitor[R, T]) -> T:
        return visitor.visit_and(self)

@dataclass(frozen=True, slots=True)
class OrCondition(FilterCondition[R], Generic[R]):
    terms: tuple[FilterCondition[R], ...]
    def accept(self, visitor: FilterVisitor[R, T]) -> T:
        return visitor.visit_or(self)

@dataclass(frozen=True, slots=True)
class NotCondition(FilterCondition[R], Generic[R]):
    term: FilterCondition[R]
    def accept(self, visitor: FilterVisitor[R, T]) -> T:
        return visitor.visit_not(self)
    `.text
  )
)
Tale classe non ha lo scopo di applicare direttamente il filtro ad un valore ma solo lo scopo di costruire il filtro.
Perciò viene applicato il pattern visitor, viene usato concretamente per validare il filtro all'interno dei service di dominio e per costruire le clausole where all'interno degli adpater sql 

questo viene usato concretamente nel postjoin filter e per il filtro su singola entità
#code-snippet(
  caption:"Ricerca - Query semplice",
  raw(
  lang:"python",
    `
SingleEntityFilter = FilterCondition[FieldName]

LinkedPostJoinFilter = FilterCondition[FieldReference]
    `.text
  )
)

questo permette un discreto riuso di codice senza introdurre vincoli di subtyping che sarebbero stati errati, motivo per qui non è stata creata un'interfaccia da far impleemntare a  FilterCondition[FieldReference] e FilterCondition[FieldName]
 



#code-snippet(
  caption:"Ricerca - Query semplice",
  raw(
  lang:"python",
    `
@dataclass(frozen=True, slots=True)
class Query(Generic[R]):
    return_fields: frozenset[R]
    filter: FilterCondition[R] | None = None


SingleEntityQuery = Query[FieldName]


class LinkedQuery:
    return_fields: frozenset[FieldReference]
    filter: LinkedFilter = LinkedFilter({})
    `.text
  )
)

in questa classe si può vedere il primo disallineamento, questo è dovuto alla necessità di avere un linked filter che abbina un filtro ad ogni entità

la query può arrivare con dei campi a valore nullo , come i pesi o il numero di risutlati desiderati,il service durante la validazione va completare questi campi se mancano, il service non fa language detection, ogni tipo di ricerca ha un suo command  dedicato per parlare con la porta outbound 

vi sono in tutto 6 porte inbound 6 service e 2 porte utbound per il repository, i service di semantica e ibrida hanno anche l'embedding provider


le classi di dominio sono condivise tra le varie ricerche quindi vanno descritte prima di queste


descrivere anceh l'sql fragement e l'approccio a query builder
    ==== Ricerca semantica
il service per la ricerca smenatica e la ricerca ibrida però calcolano l'embedding 
 
la query sulla singola partizione è così ...

la query di combinazione è così .........

poi viene fatto il join

l'sqlk fragemnt viene eseuito



    ==== Ricerca full-text
passi per la ricerca ottimizzata per lingua 



il query fragment appena descritto viene generato per ogni ogni configurazione di testo e si fa rescoring così .........

i workaround per la funzione di ranking funziona così


il workaround per la overlap funziona così .............

    ==== Ricerca ibrida

    l'rrf lato backend viene impleemntato così .....

    viene generato l'sql fragment per la ricerca semantica e per la ricerca full text, poi questi vengono inseriti nella combinazione rrf
    ==== Ricerca linked

  si compone dei seguenti passi, genera l'sql fragment per le ricerche corrispondenti su singola entità per geenrare il codice sql da eseguire

  genera uno scheletro in cui inserire gli sql fragment sfruttando i traversal path questi fanno i join

  po viene applicato il fitlro postjoin così ............

  poi vengono combinati così ..........

infine eseguiti in un'unica volta

=== Limitazioni imposte da elementi esterni
Nell'adapter dedicato al calcolo degli embedding tramite modello remoto è stato necessario rallentare artificialmente le prestazioni a causa di blocchi momentanei da parte del servizio remoto, un numero eccessivo di chiamate causa un periodo di blocco in cui viene sempre ritornato un errore 503.

Non viene propriamente aggiunto un collo di bottiglia, viene più che altro spostato parzialmente un collo di bottiglia esistente dall'esterno del sistema all'interno del sistema.

sono stati inseriti dei meccanismi di retry con attesa esponenziale e numero massimo di retry e anche un limite a quante richieste possono essere in corso contemporaneamente tramite l'uso di semafori e contatori.




== Sistema di test
    il sistema di test è molto più semplice 2 use case start test run one 


    locust simula tot client paralleli che eseguono ricerche 

    lo start test viene avviato una volta, i cliet simulati si limitano a far partire il run one, usa una schema configuration smeplificata con solo le entità, riustiliiza le classi query definite nel  sistema principale, viene aggiunta una classe per la gorud truth.

    tramite uina porta vengono recueprate le varie query e le relative gorund thruth, poi vengono eseguite tramite una porta, che ritorna il risutlato reale e lo statto dell'ingestion, infine tramite un'altra porta logga il tutto su un db

    poi il db si calocla le metriche e grafana si limita a leggere la vista delle metriche
=== Architettura del codice
=== Sistema di persistenza 
=== Start test
=== Visualizzazione dei risultati 
















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