= Note sul contesto del progetto
La configurabilità delle query e dell'ambiente è un punto importante, 

= Riunione del 2026/07/10

== Argomento Principale
Chiarimento della struttura del DB.

=== Relazione allegati-ticket allegati-conv_item
Formalmente corretto risolvere il legame is-a tra attachment, ticket-attachment e conv_item-attachment con accorpamento delle figlie nel padre 

Tuttavia verranno risolte come relazione per supporto a future evoluzioni del sistema che potrebbero richiedere una relazione molti a molti invece che uno a molti, oppure l'aggiunta di campi esclusivi per una sottoclasse


#image("er_non_strutturato.png")

=== Gestione dei cambi testuali da emddare

Tutti campi testuali potrebbero necessitare di chunking, assumiamo che il sistema riceva già i chunk col testo già diviso e si debba limitare a calcolare gli embedding sui chunk, 


gli allegati non possono essere associati a più entità, 
deve essere possibile eliminare gli allegati
deve essere possibile aggiungere allegati
non possono essere modificati


Per la gestione del chunking esistono 3 opzioni principali:
#enum(
[Concatenazione dei campi testuali per la generazione di un unico embedding, viene risolto con un'unica tabella aggiuntiva in cui viene salvato.

- punti da chiarire, chi aggrega e divide i testi: parser e chunker esterni oppure l'aggregazione e il chunking sono interni
- pro, peso e complessità contenuti, una sola serie di chunk indipendentemente da quanti campi di embedding ci sono.
- contro, non permette di ricercare solo alcuni campi specifici, rende più complessa la ricerca ibrida(forse) 
- Indicizzazione, è sufficiente un singolo indice testuale e un singolo indice vettoriale per l'intera tabella.


],
[
  *embedding separato dei campi* con aggiunta di *una sola tabella per i chunk*.

  la tabella sarebbe costruita ne seguente modo:

  #table(
    columns: ((1fr,)*3),
    
    [PK],[ticket_chunk_id],[VARCHAR(32)],
    [],[chunk_page],[INT],
    [FK],[field_name],[VARCHAR(32)],
    [FK],[ticket_id],[VARCHAR(32)],
    [],[chunck_text],[TEXT],
    [],[chunk_embedding],[vector(n)],
    table.cell(colspan: 3,[UNIQUE(chunk_page, field_name, ticket_id)])
  )
  
  - pro: ogni campo è ricercabile separatamente in modalità ibrida,
  - contro: maggiore occupazione della memoria (probable ma non sono sicuro), i vettori di embedding scalano linearmente con con il numero di campi da ricercare separatamente.

  Per motivi di variabilità sul chunking ho preferito usare una pk separata, se si cambia algoritmo / criterio di chunking (modelli di embedding con con context window più limitata) possono essere meno significativi

  - indicizzazione, se si vuole fare comunque una ricerca su tutti i campi sono comunque applicabili i normali indici testuali e vettoriali.
  - se invece si vuole fare ricerche solo su specifici campi la documentazione ufficiale di pg_vector consiglia caldamente il partitioning (fattibile in quanto abbiamo già incluso field_name su un vincolo di unique)

Alcune ulteriori note sul partitioning, questa funzionalità base di postgres permette di gestire le singole partition in modo molto personalizzabile.

In particolare ogni partition ha il suo indice che è indipendente da quello delle altre tabelle, questo permette un fine tuning sia in termini di risorse da allocare per la ricerca, sia in termini di ottimizzazione dell'indice, volendo si può applicare una misura di distanza specifica solo su una singola partizione oppure di eseguire un casting a un formato  più leggero (vector #sym.arrow halfvec #sym.arrow bit), questi non precludono la ricerca globale sulla tabella a patto che la query sia coerente con l'indice generale, tuttavia la penalizzano in quanto devono essere richieste N righe per ogni partizione, il fa scalare le risorse necessarie linearmente rispetto al numero di partizioni, oltre a richiedere di eseguire query che potrebbero non contribuire al risultato finale.

Gli indici testuali invece beneficiano di un ridotto peso, infatti il costo di mantenimento viene diviso equamente su tutti gli indici, ed essendo un indice esatto non subisce penalizzazioni da  parte del partitioning

se invece escludiamo completamente la ricerca globale sulla tabella, possiamo decidere di assegnare ad ogni partizione un vettore di embedding di dimensione diversa, postgres permette di non specificare la dimensione del vettore alla creazione della tabella, tuttavia ritornerà un errore run time ogni qualvolta si cercherà di castare esplicitamente o implicitamente un vettore a una dimensione diversa, tuttavia col partitioning è sufficiente aggiungere un check all'inserimento per garantire la consistenza dei vettori in una singola partizione.

<metodo-2>
],
[
embedding separato dei campi con una tabella separata per ogni tabella.

causa esplosione delle tabelle, permetterebbe maggiore flessibilità di indicizzazione e gestione degli embedding ma tale flessibilità può essere ottenuta con meno conseguenze negative anche tramite il #link(label("metodo-2"),"metodo precedente" )
]


)


=== Gestione della configurabilità
Parlando con pippo e franco, mi è stato spiegato un po più nel dettaglio come funziona la configurabilità di un indice di elastic con la presenza dei seguenti parametri in fase di costruzione degli indici.


#terms(
  terms.item([Queryable],[
    Tutti i campi da rendere disponibili per la ricerca testuale.
    ranking combinato di query su frase esatta, match di tutte le parole ma sparse, match di una o più parole ma non di tutte.
    ]),
  terms.item([Filterable],[
    campi su cui è possibile filtrare utilizzandoli nelle clausole where
  ]),
  terms.item([Info],[
    Campi informativi che non richiedono di essere ottimizzati per nessuna query
  ]),
  terms.item([codes],[
    Ricerca di codici specifici, in questi casi si va a cercare campi specifici ome codici, si vogliono corrispondenze esatte o corrispondenze starts with
  ]),
  terms.item([text with codes],[
    Codici specifici contenuti all'interno di testo
  ]),
  terms.item([
    attachments
  ],[
    Chiave esterna da usare per riferirsi agli attachments
  ]),
  terms.item([Dates],[
    quali campi impostare come data.
  ]),
  terms.item([Language detections],[ 
    Campo su cui fare la language detection per uno specifico ticket
    ]),
  terms.item([id_primary ],[cosa usare come primary key dell'indice elastic]),
  terms.item([lingua],[
    campo in cui salvare la lingua del documento analizzato
  ]),
  terms.item([content columns],[
    colonne che serviranno all'ai generativa per costruire la risposta
  ]),
  terms.item([validation columns],[
    colonne da usare per confrontare la pertinenza del contesto della domanda al contesto del content
  ]),
)

Devo implementare questa configurabilità ? 

Che in realtà è più una questione di implementarla in modo automatico piuttosto che manuale.

== Analisi pratica

In questa sezione esamino in modo più pratico come verrà implementato il tutto




