#import "/plugin/mod.typ": gl, glpl
#import "/metadata/mod.typ": data
#import "/plugin/mod.typ" : code-snippet
#pagebreak(to: "odd")

#heading("Implementazione", depth: 1)<cap:lavoro-svolto>

#text(style: "italic", [
  In questo capitolo approfondisco le fasi di sviluppo del progetto, descrivendo le scelte implementative concrete e le problematiche affrontate nella realizzazione del sistema di information retrieval e del sistema di test.
])
#v(1em)

L'implementazione viene divisa in sistema principale, sistema di test e limitazioni imposte da elementi esterni, comuni a entrambi.

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

Ciascuna categoria è ulteriormente suddivisa per funzionalità: ingestion e le diverse tipologie di ricerca dispongono ciascuna dei propri adapter, service e port dedicati. Fanno eccezione le classi di dominio condivise, trattate nella @classi-dominio-condivise a loro dedicata.

==== Classi di dominio condivise<classi-dominio-condivise>
Le classi di dominio condivise rappresentano il modello dati descritto nella @main-system-definizione-modello-dati, e costituiscono la fonte di verità del sistema. Vengono costruite e validate una sola volta nella composition root, e da lì iniettate nelle componenti del sistema che necessitano di conoscere il modello dati.

*EntityName* e *FieldName* sono due semplici wrapper attorno a una stringa, adottati per rendere il codice più leggibile e per impedire, a livello di firma, di confondere un identificativo di entità con uno di campo o con una stringa qualunque.

*FieldReference* rappresenta un riferimento a un campo specifico di un'entità specifica, tramite la coppia nome dell'entità e nome del campo.

*FieldDefinition* descrive un campo dati di un'entità: nome, tipo e obbligatorietà, coerentemente con quanto già descritto nel modello dati. *FieldRole* e *FieldType* sono due enumerazioni che rappresentano rispettivamente i due ruoli supportati (searchable, filterable) e i tipi di dato supportati per un campo.

*Entity* rappresenta una singola entità dello schema, aggregando l'insieme dei suoi campi, i campi identificativi e la configurazione di ricerca (ruoli e pesi per campo). In fase di costruzione, Entity verifica la biimplicazione tra ruolo searchable e tipo di campo suddiviso in chunk, già descritta come principio di progetto: un campo è marcato searchable se e solo se il suo tipo è testo suddiviso in chunk.

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
*SchemaConfiguration* è la radice dell'aggregato: raccoglie l'insieme delle entità, dei vincoli di schema e la configurazione di ricerca linked in un'unica struttura immutabile. Le entità sono rappresentate come mappa da EntityName a Entity, anziché come semplice sequenza, per garantire per costruzione l'assenza di duplicati e un accesso diretto in fase di risoluzione dei riferimenti.

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

SchemaConfiguration valida, in fase di costruzione, esclusivamente la coerenza strutturale locale (presenza di almeno un'entità, coerenza tra chiave e valore nella mappa delle entità). La validazione dell'integrità referenziale più profonda — l'esistenza e la compatibilità di tipo dei campi citati nei vincoli, l'esistenza delle entità citate nella configurazione di ricerca linked — richiede invece una visione d'insieme dell'intero schema, non disponibile al singolo oggetto preso in isolamento, ed è per questo demandata a *SchemaConfigurationBuilder*.

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

Inoltre si precisa che l'inizializzazione del database non avviene tramite codice SQL scritto a mano, ma tramite script che leggono la schema configuration e altre configurazioni, come quella di pgvector. Questo è per comodità nella modifica dei parametri per ulteriori test futuri. Non è stata dedicata particolare cura a questo script, in quanto reputato esterno allo scopo del tirocinio ma una semplice comodità per il testing: vi è ampio margine di miglioramento.

#figure(caption:"Diagramma ER del core del database")[
#image("/src/PB/DocumentazioneEsterna/Specifica_Tecnica/content/05-diagrammi-classi/uml/png/frontend/schema_er_progetto.svg")
]
#figure(caption:"Diagramma ER delle tabelle di supporto allo staging")[
#image("/src/PB/DocumentazioneEsterna/Specifica_Tecnica/content/05-diagrammi-classi/uml/png/frontend/staging_area.svg")
]
#figure(caption:"Diagramma ER delle tabelle di supporto al tracking")[
#image("/src/PB/DocumentazioneEsterna/Specifica_Tecnica/content/05-diagrammi-classi/uml/png/frontend/tracking.svg")
]<diagramma-er>

Alcuni aspetti rilevanti dello schema non sono rappresentabili graficamente in un diagramma entità-relazione, e vengono quindi descritti di seguito: il partizionamento delle tabelle e gli indici definiti su di esse.

Coerentemente con quanto descritto nella @analisi-ricerca-semantica in cui viene analizzata la ricerca semantica, la tabella dei chunk di ciascuna entità è partizionata per lista sul campo di provenienza del testo (field_name): ogni campo searchable dell'entità corrisponde a una partizione distinta.

Su ciascuna tabella dei chunk sono definite quattro famiglie di indici:
+ Gli indici GIN "classici" sulle colonne tsv_simple e tsv_lang, che servono a velocizzare il filtering delle query full-text implementate da Postgres. Per tsv_lang l'indice è ulteriormente suddiviso in un indice parziale per lingua, filtrato sul valore di chunk_language;

+ Gli indici GIN con opclass array_ops sull'espressione tsvector_to_array(...) delle colonne tsv_simple e tsv_lang, utilizzati dal filtro di corrispondenza minima descritto in @overlap-text-query, che si appoggia all'operatore di overlap tra array anziché a sugli operatori di match della ricerca full-text. Anche questi indici sono suddivisi per lingua sulla colonna tsv_lang, visto che il look up è sempre filtrato per lingua;

+ un indice HNSW sulla colonna embedding, utilizzato dalla ricerca semantica. L'indice non è necessariamente costruito sui valori a piena precisione della colonna: la configurazione applicativa può specificare un tipo di vettore e una distanza "candidati", eventualmente più leggeri (ad esempio una quantizzazione binaria con distanza di Hamming), utilizzati per generare rapidamente l'insieme di candidati su cui viene poi eseguito l'oversampling e il rescoring finale sui valori reali. Nella configurazione concreta di questo progetto, l'indice è costruito su una quantizzazione binaria dell'embedding, con distanza di Hamming. \ Tutti gli indici elencati sono creati sulla tabella partizionata madre: Postgres li propaga automaticamente a ciascuna partizione.

+ Un indice univoco su un'espressione costante, sulla tabella delle sessioni di ingestion, filtrato sulle sole righe con stato aperto o chiuso: questo garantisce, a livello di database e non solo applicativo, che possa esistere al più una sessione attiva alla volta, coerentemente con il principio già descritto nella sezione @gestione-staging-area.

=== Ingestion
La funzionalità di ingestion espone quattro porte inbound, ciascuna dedicata a una funzione specifica:
+ avvio della sessione di ingestion,
+ chiusura della sessione di ingestion,
+ lettura dello stato della sessione di ingestion (in corso o terminata),
+ elaborazione di uno stream di batch di dati grezzi.

L'avvio e la chiusura scrivono sulla tabella delle sessioni di ingestion, che funge da fonte di verità esterna al processo: qualsiasi worker FastAPI, nel tentativo di aprire o chiudere una sessione, osserva lo stesso database e le stesse informazioni, indipendentemente da quale istanza dell'applicazione lo serva. La chiusura, in particolare, avvia anche il processo di promozione da staging a tabelle reali, descritto più avanti in questa sezione.

==== Elaborazione dei batch e uso dello stream
Non vi è contraddizione tra l'uso del batching interno e il fatto che la porta di elaborazione accetti uno stream: il sistema ottimizza operazioni come il calcolo degli embedding, il rilevamento della lingua e la scrittura sul database per i singoli batch di record, ma la porta stessa espone un iteratore asincrono di batch in ingresso, così da poter gestire un flusso di dati potenzialmente continuo.


==== Validazione, arricchimento e scrittura
Per rappresentare i valori dei campi si è scelto di adottare un'astrazione dedicata, *FieldValue*, invece di un insieme eterogeneo di tipi primitivi: l'obiettivo principale è evitare la proliferazione di tipi primitivi diversi all'interno del dominio. A partire da questa astrazione sono definite union type dedicate, rispettivamente per i dati in ingresso e per i dati destinati alla scrittura sul database.

Per ciascun batch dello stream in ingresso, il service esegue in sequenza:

+ *validazione* — verifica la coerenza dei dati ricevuti con la schema configuration e scarta i record non conformi. È in questa fase che avviene anche il casting dei tipi non deducibili nell'adapter inbound: il tipo di un dato viene normalmente dedotto dal suo formato, ma per i valori data/ora la conversione da stringa a datetime può essere ambigua (un campo di tipo testo il cui valore ha una forma di data, se convertito, genererebbe errori più avanti). Il service applica quindi questa trasformazione solo dove necessario, guidato dalla schema configuration;
+ *arricchimento* — un processor riceve alla costruzione le porte outbound per la language detection e per il calcolo degli embedding; aggrega le liste di testi da passare a ciascuna porta e costruisce i refined entity batch. Se lingua è già nota a priori viene usata quella, altrimenti si ricorre a language detection; i record per cui l'arricchimento fallisce vengono scartati;
+ *scrittura* — i record rimanenti vengono scritti sulle tabelle di staging tramite comando COPY, tramite una porta outbound write repository dedicata.

Per notificare gli scarti a ciascuno di questi passaggi viene usata una classe *RejectedRecord*, che contiene l'identificativo del record e il motivo del fallimento. Il metodo che orchestra l'intera pipeline accetta in input un AsyncIterator di batch grezzi e restituisce in output un AsyncIterator di RejectedRecord, che l'adapter FastAPI inoltra al chiamante come streaming response.
#code-snippet(caption:"Firma porta di ingestion dei dati", 
raw(lang:"python",
`
class IngestBatchStreamUseCase(ABC):
    @abstractmethod
    async def ingest_batch_stream(
        self, command: IngestBatchStreamCommand
    ) -> AsyncIterator[RejectedRecord]:...
`.text 

))
Lo stato di scrittura di ciascuno stream viene inoltre tracciato tramite una porta outbound dedicata, in modo da garantire che, al momento della chiusura della sessione, tutti gli stream in corso abbiano effettivamente terminato la scrittura prima di avviare la promozione.

Il caso d'uso di lettura dello stato di attività della sessione di ingestion serve esclusivamente al sistema di test, per determinare se durante l'esecuzione di una query sia in corso un processo di ingestion (si veda @sec:sistema-di-test).

==== Promozione da staging a tabelle reali
Lo scheduling della promozione è calcolato in base ai vincoli relazionali definiti nella schema configuration, dando priorità prima alle tabelle dei metadati e poi a quelle dei chunk, in modo da rispettare le dipendenze referenziali. La promozione avviene interamente lato database, tramite una query che seleziona i dati validi e li trasferisce sulla tabella reale senza farli transitare da Python.

#code-snippet(
  caption: "Staging promotion - selezione degli elementi candidati",
  raw(
    lang:"sql",
    `WITH staging_window AS (
    SELECT staging_id FROM {source_table}
    WHERE {where_clause}
    ORDER BY staging_id
    LIMIT {self._batch_size}
),`.text
  )
)

Questo primo CTE seleziona fino a self.\_batch_size elementi candidati alla promozione, cioè rimovibili dalla tabella di staging e inseribili nella tabella reale. Il sistema si occupa solo di costruire un'opportuna where_clause, che verifica che, dopo la promozione, restino rispettati i vincoli di integrità referenziale: ad esempio, per l'entità radice (i ticket) non è necessaria alcuna clausola aggiuntiva, mentre per un'entità figlia (i conversation item) viene richiesto che il ticket a cui fanno riferimento esista già nella tabella reale.

#code-snippet(
  caption: "Staging promotion - gestione dei duplicati",
  raw(
    lang:"sql",
    `batch AS (
    SELECT DISTINCT ON ({conflict_columns}) s.staging_id
    FROM {source_table} s
    JOIN staging_window w ON s.staging_id = w.staging_id
    ORDER BY {conflict_columns}, s.staging_id DESC
),`.text
  )
)

La staging window viene qui espansa a tutti i possibili duplicati degli elementi selezionati e ordinata in ordine decrescente di staging_id. Questo, combinato con l'autoincremento dello staging_id e con DISTINCT ON, garantisce che venga selezionata solo la versione più recente di ciascun dato, anche in presenza di più caricamenti duplicati dello stesso record.

Questa soluzione non è riconosciuta come ottimale, ma è funzionalmente corretta e, per un progetto di natura esplorativa, sufficiente: lo staging, per quanto utile alla robustezza del caricamento, non è centrale al problema di ricerca affrontato dal tirocinio. Viene qui esplicitamente riconosciuto come debito tecnico, da sanare in eventuali evoluzioni successive del sistema.

#code-snippet(
  caption: "Staging promotion - estrazione dei valori",
  raw(
    lang:"sql",
    `promoted AS (
    DELETE FROM {source_table}
    WHERE staging_id IN (SELECT staging_id FROM staging_window)
    RETURNING staging_id, {column_list}
),`.text
  )
)

Questo CTE rimuove dalla tabella di staging gli elementi candidati e ne salva temporaneamente il valore, tramite la clausola RETURNING, per il passo successivo.

#code-snippet(
  caption: "Staging promotion - inserimento nella tabella reale",
  raw(
    lang:"sql",
    `inserted AS (
    INSERT INTO {target_table} ({column_list})
    SELECT {column_list} FROM promoted
    WHERE staging_id IN (SELECT staging_id FROM batch)
    ON CONFLICT ({conflict_columns}) {conflict_action}
    RETURNING 1
)`.text
  )
)

Questo passo carica sulla tabella reale solo gli elementi già filtrati dal CTE batch (cioè una versione per ciascuna chiave), specificando come gestire eventuali conflitti con righe già presenti nella tabella reale — da non confondere con la deduplicazione dei duplicati interni allo staging, gestita al passo precedente. L'azione concreta in caso di conflitto (tipicamente un upsert) è definita dal backend, non hard-coded nella query.

#code-snippet(caption: "Staging promotion - conteggio degli elementi processati",
  raw(
    lang:"sql",
    `SELECT count(*) FROM staging_window`.text
  ),
)

La query restituisce infine il numero di elementi processati nella finestra, non il numero di record effettivamente inseriti: la promozione viene rieseguita finché la query non restituisce 0, cioè finché non rimangono più elementi promuovibili nella tabella di staging.

=== Ricerca
Ogni tipologia di ricerca è esposta tramite un endpoint dedicato, realizzato con un adapter FastAPI specifico.

Le classi di dominio impiegate differiscono tra ricerca su singola entità e ricerca linked: quest'ultima richiede un filtro con struttura annidata più complessa, che abbina un filtro a ciascuna entità coinvolta nell'attraversamento. Per evitare una duplicazione eccessiva di codice tra le due varianti, senza però introdurre relazioni di subtyping scorrette, si è adottato l'uso di *Generic* e *type alias*: i Generic permettono il riuso della logica di dominio comune, mentre i type alias vengono usati da tutte le classi esterne alla catena di generici per facilitare eventuali modifiche future. Questa scelta si è rivelata utile concretamente durante la realizzazione della ricerca linked, che ha richiesto di distinguere due serie di filtri distinte a partire dalla stessa gerarchia generica.

Per questo motivo, nel seguito vengono descritte solo le parti generiche condivise, un esempio di come vengono specializzate tramite type alias, e solo ciò che diverge dalla versione generica.

==== Filtering
Il filtro adotta una struttura ad albero: viene definita un'interfaccia comune, *FilterCondition*, con quattro implementazioni concrete — atomic expression, and condition, or condition, not condition.

#code-snippet(
  caption:"Ricerca - interfaccia FilterCondition e implementazioni concrete",
  raw(
  lang:"python",
    `class FilterCondition(ABC, Generic[R]):
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

Questa gerarchia ha il solo scopo di rappresentare e comporre il filtro, non di applicarlo direttamente a un valore. Per applicarlo si usa quindi, anche qui, il pattern Visitor: concretamente, un'implementazione di *FilterVisitor* viene usata per validare il filtro all'interno dei service di dominio, e un'altra per costruire le clausole WHERE all'interno degli adapter SQL — sia per il filtro su singola entità, sia per il post-join filter della ricerca linked.

#code-snippet(
  caption:"Ricerca - type alias per filtro su singola entità e post-join",
  raw(
  lang:"python",
    `SingleEntityFilter = FilterCondition[FieldName]

LinkedPostJoinFilter = FilterCondition[FieldReference]
    `.text
  )
)

L'uso di Generic e type alias, anziché di un'interfaccia comune implementata separatamente da `FilterCondition[FieldName]` e `FilterCondition[FieldReference]`, permette un discreto riuso di codice senza introdurre vincoli di subtyping che sarebbero stati concettualmente scorretti: le due specializzazioni non sono l'una sottotipo dell'altra, condividono solo la struttura.

==== Query e specializzazioni
#code-snippet(
  caption:"Ricerca - Query e specializzazioni",
  raw(
  lang:"python",
    `@dataclass(frozen=True, slots=True)
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

// TODO: inserire qui le classi rappresentative dei risultati (QueryResult, SimilaritySearchResult, ...)

In LinkedQuery si osserva il primo punto di disallineamento tra la gerarchia generica e la sua specializzazione linked: è dovuto alla necessità, propria della sola ricerca linked, di abbinare un filtro distinto a ciascuna entità coinvolta, tramite `LinkedFilter`, anziché un unico filtro sull'intera query.

La query, così come ricevuta dall'adapter inbound, può contenere campi con valore nullo, ad esempio i pesi di fusione o il numero di risultati desiderati (top_k). È compito del service, in fase di validazione, completare questi campi quando assenti, attingendo ai valori di default configurati; il service non esegue invece language detection, che rimane responsabilità del solo processor di ingestion. Ogni tipologia di ricerca dispone infine di un proprio command dedicato, usato per comunicare con la rispettiva porta outbound.

// TODO(chiarire): il conteggio "6 porte inbound, 6 service, 2 porte outbound per il repository"
// non torna ancora con le 4 sottosezioni sotto (semantica, full-text, ibrida, linked).
// Verificare se manca una quinta/sesta porta (es. ricerca generica su singola entità separata
// dai 4 tipi, o linked scissa in due fasi) prima di scrivere il testo definitivo qui sotto.
Vi sono in tutto sei porte inbound, sei service e due porte outbound dedicate al repository; i service di ricerca semantica e ibrida dispongono inoltre di una porta outbound aggiuntiva verso l'embedding provider. Le classi di dominio appena descritte sono condivise da tutte le tipologie di ricerca, ed è per questo che vengono descritte una sola volta, prima di entrare nel dettaglio delle singole tipologie.

==== Ricerca semantica
La ricerca semantica opera in due fasi, coerentemente con quanto descritto nella @analisi-ricerca-semantica: viene eseguita una query per ciascuna partizione della tabella dei chunk coinvolta (una per ciascun campo searchable interessato dalla ricerca), i cui risultati vengono poi combinati.

// TODO: inserire qui la query sulla singola partizione (CTE "candidates": generazione dei
// candidati con cast leggero/oversampling + rescoring a piena precisione), seguita dalla query
// di combinazione (CTE "ranked": UNION ALL tra le partizioni + ORDER BY sul punteggio pesato)
// e infine il JOIN finale con la tabella principale.

Le partizioni eseguono internamente il proprio rescoring e materializzano un punteggio già moltiplicato per il peso assegnato al campo corrispondente; la query esterna si limita quindi a un'unione (UNION ALL) seguita da un ORDER BY sul punteggio combinato, senza dover ripetere la logica di ranking.

Per rendere il sistema facilmente riconfigurabile, la descrizione della configurazione di pgvector (tipo di distanza, tipo di vettore, soglia utente, fattore di oversampling, ...) è iniettata tramite dependency injection di un oggetto dedicato, PgVectorEngineConfig, costruito da una factory che gestisce automaticamente le variabili d'ambiente.


A supporto di questa configurazione, alcune classi ausiliarie coniugano il comportamento nativo di pgvector con le metriche di similarità attese dal dominio, eseguendo le trasformazioni inverse rispetto alle ottimizzazioni applicate in fase di ricerca (ad esempio la conversione tra spazio di distanza raw, usato internamente da pgvector, e spazio di similarità normalizzato, esposto verso l'esterno).

==== Ricerca full-text
La ricerca full-text adotta un approccio strutturalmente simile alla semantica: partition query per campo searchable, poi combinazione.
Non è un vincolo tecnico, ma una scelta di riuso del codice della ricerca semantica: in questo caso la suddivisione per partizione non è strettamente necessaria, ma nemmeno errata.
Semplifica la ricerca su sottoinsiemi di campi e l'applicazione dei pesi.

La ranking function nativa di Postgres per la ricerca full-text non offre, a differenza ad esempio di Elasticsearch, un meccanismo di boosting progressivo: non è possibile, con un'unica chiamata, dare un punteggio alto a un match di frase esatta, uno intermedio a un match su tutte le parole ma non in ordine, e uno basso a un match parziale. Per simulare questo comportamento si sommano più ranking function calcolate sulla stessa query: una phrase query e una allwords query, che restituiscono lo stesso punteggio in caso di match di frase, mentre la phrase query restituisce 0 se l'ordine delle parole non è rispettato.

Una seconda limitazione nativa è l'impossibilità di filtrare per un criterio di corrispondenza minima (match di almeno una certa percentuale di parole): anche questo viene reimplementato tramite operazioni sugli array. I lessemi della query vengono estratti direttamente all'interno di Postgres — anziché con uno strumento esterno — per evitare un rischio di stemming incoerente tra la fase di estrazione e quella di confronto.

#code-snippet(
  caption: "Ricerca full-text - estrazione dei lessemi e calcolo della soglia di corrispondenza",
  raw(
    lang:"sql",
    `WITH query_lexemes AS (
  SELECT arr, cardinality(arr) AS n,
         LEAST(
           CASE
             WHEN cardinality(arr) > 9 THEN GREATEST(CEIL(cardinality(arr) * 0.5)::int, 1)
             WHEN cardinality(arr) > 4 THEN GREATEST(CEIL(cardinality(arr) * 0.6)::int, 1)
             WHEN cardinality(arr) > 2 THEN GREATEST(CEIL(cardinality(arr) * 0.9)::int, 1)
             ELSE cardinality(arr)
           END,
         15) AS k
  FROM (
    SELECT array_agg(lex ORDER BY lex) AS arr
    FROM unnest(tsvector_to_array(to_tsvector('italian', 'problema di accesso al portale utente'))) AS lex
  ) AS lexemes
),`.text
  )
)

Questo CTE estrae l'insieme ordinato dei lessemi della query (`arr`), la sua cardinalità (`n`) e il numero minimo di lessemi in comune richiesto per considerare un chunk rilevante (`k`), calcolato con una soglia percentuale decrescente al crescere del numero di parole nella query, e comunque limitato a un massimo di 15.

#code-snippet(
  caption: "Ricerca full-text - selezione dei candidati per corrispondenza e ranking combinato",
  raw(
    lang:"sql",
    `candidates AS MATERIALIZED (
  SELECT
    "ticket_id",
    "chunk_text" AS matched_text,
    "chunk_counter",
    (
        ts_rank_cd("tsv_lang", to_tsquery('italian', (plainto_tsquery('italian', 'problema di accesso al portale utente'))::text || ':*'))
      + ts_rank_cd("tsv_lang", to_tsquery('italian', (phraseto_tsquery('italian', 'problema di accesso al portale utente'))::text || ':*'))
      + ts_rank_cd("tsv_lang", to_tsquery('italian', replace(plainto_tsquery('italian', 'problema di accesso al portale utente')::text, ' & ', ' | ')))
    ) AS raw_score,
    cardinality(ARRAY(
      SELECT unnest(tsvector_to_array("tsv_lang"))
      INTERSECT
      SELECT unnest(arr) FROM query_lexemes
    )) AS matched_count,
    (SELECT k FROM query_lexemes) AS required_k
  FROM public.ticket_chunks
  WHERE "field_name" = 'description'
    AND tsvector_to_array("tsv_lang") && (SELECT arr[1 : GREATEST(n - k + 1, 1)] FROM query_lexemes)
    AND "chunk_language" = 'it'
)`.text
  )
)

Il punteggio (raw_score) è la somma delle tre ranking function citate sopra (plain, phrase, allwords in forma OR). Il conteggio dei lessemi in comune (matched_count), confrontato con la soglia required_k, realizza il filtro di corrispondenza minima descritto in @overlap-text-query; la condizione nella clausola WHERE sull'operatore di overlap (&&) applicato a una porzione dell'array dei lessemi della query è un filtro di pre-selezione più permissivo, pensato per sfruttare l'indice GIN con array_ops descritto nella sezione sul sistema di persistenza, prima del calcolo esatto di matched_count.

#code-snippet(caption: "Ricerca full-text - filtro finale sulla soglia di corrispondenza",
  raw(
    lang:"sql",
    `SELECT
  "ticket_id",
  'description' AS "field_name",
  matched_text,
  "chunk_counter",
  raw_score,
  1.0::float8 AS field_weight
FROM candidates
WHERE raw_score >= 0.0
  AND matched_count >= required_k;`.text
  )
)

Poiché il conteggio di corrispondenza minima non è una funzionalità nativa della full-text search di Postgres, non è utilizzabile direttamente nella ranking function, ma solo come filtro applicato a valle, con soglie e percentuali configurabili. Rimane comunque possibile, in configurazione, usare una semplice allwords query come filtro; tuttavia, su query lunghe e basi di dati ampie, una condizione di questo tipo da sola non riduce in modo significativo l'insieme di righe da valutare — da qui la necessità del meccanismo sopra descritto.

Il frammento di query appena descritto viene generato per ogni configurazione testuale rilevante ed eseguito ripetutamente: per la ricerca su lingua non nota, la ricerca viene eseguita tre volte — una sul vettore tsv_simple (agnostico rispetto alla lingua) e una per ciascuna lingua supportata sul vettore tsv_lang (ad esempio una volta con `chunk_language = 'it'` e una con `chunk_language = 'en'`) — scorrendo quindi la base di dati più volte; i risultati delle diverse esecuzioni vengono infine ricombinati con `UNION ALL`, con la stessa logica di combinazione descritta per la ricerca semantica.

Sono state esplorati tre ordinamenti per i lessemi delle frasi:
- ordine lessicografico,
- lunghezza dei lessemi,
- frequenza dei lessemi.

Per applicare il principio di cassetti è sufficiente un qualsiasi tipo di ordinamento, tuttavia le configurazioni testuali semplici non eliminano le stopword, ciò porta ad un alto numero di match su cui calcolare il punteggio causando un overhead molto alto per l'ordine lessicografico, l'ordinamento per lunghezza ha prodotto risultati migliori ma con una consistenza altalenante, tramite explain analyze siè vista una discreta riduzione del candidate pool per ticket ee conversation item, ma pressocchè nulla sugli attachemnts.

// TODO INSERIRE CLAUSOLA DI ORDINAMENTO 

La frequenza dei lessemi richiede un ulteriore overhead in memoria in quanto consiste in una vista materializzata che va creata esplicitamente, tuttavia ha portato  una consistente riduzione del pool di candidati che ha comportato una discreta riduzione dei tempi
// TOD INSERIRE VIEW E CLAUSOLA ORDINAMENTO


==== Ricerca ibrida
Le query costruite per la ricerca semantica e per la ricerca full-text non vengono eseguite immediatamente al momento della loro costruzione: vengono prima create come frammenti tramite classi helper dedicate, e solo in un secondo momento eseguite. Questo disaccoppiamento tra costruzione ed esecuzione è ciò che rende possibile realizzare la ricerca ibrida come reciprocal rank fusion (RRF): i due frammenti di query — semantica e full-text — vengono inseriti in un'unica query complessiva, che applica l'RRF lato database, materializzando ciascun frammento tramite CTE e calcolandone la posizione in classifica con RANK() OVER (...).

// TODO: inserire qui il codice SQL concreto della combinazione RRF (i due CTE materializzati
// per semantica e full-text, il calcolo del RANK() OVER, e la formula di combinazione finale
// tra i due rank).

==== Ricerca linked
La ricerca linked riusa i frammenti di query già descritti per la ricerca su singola entità (semantica, full-text o ibrida, a seconda della configurazione), generandone uno per ciascuna entità coinvolta nell'attraversamento. A partire dalla `LinkedSearchConfiguration` e dai `TraversalPath` precalcolati (@classi-dominio-condivise), viene generato uno scheletro di query in cui i frammenti per singola entità vengono inseriti e collegati tramite una serie di JOIN, uno per ciascun arco del cammino verso la radice.

// TODO: inserire qui il codice SQL dello scheletro di JOIN costruito a partire dai TraversalPath.

Una volta effettuati i join, viene applicato il post-join filter descritto nella sezione sul filtering (`LinkedPostJoinFilter`), che opera sui risultati già combinati tra le diverse entità.

// TODO: inserire qui il codice SQL del post-join filter.

I risultati delle diverse entità vengono infine combinati secondo la stessa logica di fusione già vista per semantica e full-text (unione e ordinamento su punteggio pesato), e l'intera catena: frammenti per singola entità, join, filtro post-join, combinazione.
L'esecuzione avviene in un'unica chiamata SQL: la ricerca linked, per quanto concettualmente più complessa, non richiede round-trip aggiuntivi verso il database rispetto alle altre tipologie di ricerca.

// TODO: inserire qui il codice SQL della combinazione finale, se distinto da quanto già mostrato.

== Sistema di test<sec:sistema-di-test>
Il sistema di test, indicato anche come retriever-trial, ha una struttura più semplice rispetto al sistema principale, e ne è cliente: espone due soli casi d'uso, l'avvio di una sessione di test (*start test*) e l'esecuzione di una singola query di test (*run one*).

Locust simula un numero configurabile di client paralleli che eseguono ricerche contro il sistema principale. Lo start test viene invocato una sola volta, all'avvio della sessione di Locust; ciascun client simulato si limita poi a invocare ripetutamente run one.

Il sistema di test riusa la schema configuration del sistema principale, ma in una forma semplificata contenente le sole entità necessarie ai fini del test, e riutilizza le classi di query già definite nel sistema principale, estese con una classe dedicata per rappresentare la ground truth di ciascuna query.

Ogni esecuzione di run one, tramite una porta dedicata, recupera una query di test e la relativa ground truth; tramite una seconda porta esegue la query contro il sistema principale, ottenendo sia il risultato reale sia lo stato corrente della sessione di ingestion (per poter distinguere, in fase di analisi, i risultati raccolti durante un'ingestion in corso da quelli raccolti a dati stabili); infine, tramite una terza porta, registra l'esito su un database dedicato. Da questo database, tramite una vista, vengono calcolate le metriche di interesse, che Grafana si limita a leggere e visualizzare.

=== Architettura del codice
Anche il sistema di test segue il principio dell'architettura esagonale, con la stessa suddivisione in adapter, port, service e classi di dominio già vista per il sistema principale.

// TODO: descrivere la struttura delle classi di query di test (query + ground truth) e come si
// relazionano con le classi Query/SingleEntityQuery/LinkedQuery del sistema principale.

// TODO: descrivere la struttura della classe di ground truth (cosa rappresenta, come viene
// confrontata con il risultato reale in fase di calcolo delle metriche).

// TODO: descrivere il meccanismo di logging: cosa viene scritto, con quale porta outbound,
// e la relazione con l'identificativo di run descritto in "Start test".

=== Sistema di persistenza
// TODO: descrivere il formato del file JSONL contenente le query di test, pensato per essere
// consumato sequenzialmente (una query e la relativa ground truth per riga), e il motivo di
// questa scelta rispetto ad es. caricarle tutte in memoria o tenerle su database.

// TODO: descrivere lo schema della tabella di log dei risultati di run one, e la vista che
// calcola le metriche aggregate a partire da essa (quali metriche, con quale logica di
// aggregazione, eventuale raggruppamento per run id).

=== Start test
Lo start test viene avviato da Locust all'inizio di ciascuna sessione di test.

// TODO: descrivere cosa fa concretamente start test oltre alla generazione dell'id di run:
// genera un identificativo univoco per la sessione di test (run id), usato per raggruppare tutti
// i risultati prodotti dai vari client simulati durante quella sessione all'interno della tabella
// di log, e per permettere a Grafana di isolare i dati di una singola run in fase di visualizzazione.

=== Visualizzazione dei risultati
// TODO: descrivere la dashboard Grafana: pannelli principali, metriche mostrate, e la variabile
// di dashboard che recupera gli id di sessione disponibili e seleziona automaticamente l'ultimo,
// così da non dover selezionare manualmente la run più recente a ogni apertura della dashboard.

== Limitazioni imposte da elementi esterni
Nell'adapter dedicato al calcolo degli embedding tramite modello remoto è stato necessario introdurre un rallentamento artificiale delle prestazioni, a causa di blocchi temporanei imposti dal servizio remoto: un numero eccessivo di chiamate in un breve intervallo causa un periodo di blocco durante il quale il servizio restituisce sistematicamente un errore 503.

Questo adapter è condiviso da più componenti del sistema principale — la fase di arricchimento dell'ingestion e i service di ricerca semantica e ibrida — motivo per cui la limitazione descritta in questa sezione, per quanto discussa qui in un unico punto, si ripercuote su tutte queste componenti.

Da un punto di vista architetturale, questo intervento non introduce un nuovo collo di bottiglia nel sistema, ma sposta parzialmente, dall'esterno verso l'interno del sistema, un collo di bottiglia già esistente e non altrimenti evitabile. Per gestirlo sono stati introdotti meccanismi di retry con attesa esponenziale e numero massimo di tentativi, oltre a un limite al numero di richieste concorrenti verso il servizio remoto, realizzato tramite semafori e contatori.