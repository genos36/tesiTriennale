= Note di progettazione


== Adattamento del modello dati al DB
Assumendo che il modello dati sia composto dalle entità :
- ticket
- conv item
- attachment

e con le seguenti relazioni:
- conv item -1,N-> ticket
- attachment -0,N-> ticket
- attachment -0,N-> conv item
ma comunque attachment deve essere riconducibile o a ticket o a conv item


Dove ogni entità si divide in :
- info, lista dei campi dati complessivi e del loro tipo
- filterable: lista di campi dati da usare come filtro
- testo cercabile con una ricerca di similarità: lista dei campi dati utilizzabili per la ricerca semantica o full text, questi campi possono essere tutti chunkabili


si traduce ogni entità in 2 tabelle
- tabella principale, contiene i metadati dell'entità, con l'eccezione dei campi dati cercabili con similarità
- tabella dei chunk, una tabella di supporto con le seguenti caratteristiche : 
  - chiave primaria data dalla tripla (id_entità, nome_campo, chunk_counter)
  - chiave esterna verso l'entità principale
  - chiave esterna verso un registro che associa ad ogni entità i nomi dei relativi campi ricercabili per similarità
  - testo del chunk
  - lingua del testo
  - embedding del chunk
  - i campi dati filterable, questa scelta di de-normalizzazione è dovuta alla necessità di poter ottimizzare query con clausole where, permette anche l'applicazione di indici b-tree, che permetterebbero al planner di postgres di analizzare  la selettività di una clausola where ed eventualmente posticipare le ricerche esatte e semantiche



La tabella dei chunk verrà anche partizionata in base ai nomi dei campi, questo permette di assegnare ad ogni partizione un suo indice vettoriale personale, sia implicitamente con la creazione di un indice sulla tabella, che viene poi eseguito come creazione dell'indice su tutte le partizioni, sia esplicitamente su una singola partizione.

questo è necessario per permettere di effettuare ricerche sui singoli campi in modo efficiente, senza partition pruning una clausola where campo = X avrebbe invalidato l'utilizzo di un indice e costretto il DB alla ricerca esatta.

Il "costo" di questa ottimizzazione è che se si effettua una ricerca su più campi e si vogliono N risultati, è necessario effettuare la query su tutte le partizioni interessate e recuperare un totale di N \* numero di campi su cui cercare per poi combinare i risultati:
  - Si usa il re-scoring se i vettori di embedding sono compatibili
  - si usa RRF se i vettori di embedding non sono compatibili
comunque è buona norma usare le iterative scan quando si effettuano ricerche con clausole where insieme a ricerche vettoriali, questi emettono di continuare a recuperare risultati fino alla soglia desiderata senza rinunciare all'ottimizzazione dell'indexing



La ricerca full text non subisce la stessa penalizzazione, anzi beneficia del partizionamento, questo perché usa indici esatti ed è quindi possibile ottimizzare gli accessi alle partizioni, lo stesso vale per indici come B-tree


Vengono create anche delle tabelle generali di supporto per rendere la configurazione disponibile direttamente 
  - elenco entità
  - ruolo dei fields con chiave primaria entità-campo, si assume che un campo non possa vere più di un ruolo, in caso contrario la chiave primaria diventa entità-campo-ruolo  

Inoltre la ricerca ibrida può essere implementata anche lato Database sfruttando CTE

== Progettazione ad alto livello

per testare pg vector e le sue performance si possono implementare alcune funzionalità tramite python

bisogna testare le seguenti funzionalità:
- ingestion
- ricerca
  - ricerca semantica
  - ricerca full-text
  - ricerca ibrida

- visualizzazione delle metriche
- sperimentare con l'indexing


Per l'ingestion e la ricerca si adatta bene l'uso di una architettura logica di tipo esagonale

Per l'esecuzione di query di test si può passare attraverso le porte esposte dall'architettura esagonale

Per le metriche prestazionali come il recall si può usare l'architettura esagonale che realizza ricerca e ingestion

Tuttavia per visualizzare le metriche di testing relative alle performance del database e al suo consumo di risorse l'architettura logica di tipo esagonale è per definizione inapplicabile o difficilmente applicabile

è necessario sviluppare il sistema su 2 moduli distinti
- Modulo core, risolve il problema della retrieval e dell'ingestion, realizza un'architettura esagonale incentrata su quel problema
- Modulo di bench marking, realizzabile come esagonale se si considera il database sql come parte integrate del dominio (se ricordo bene il criterio per cui un'architettura è esagonale è che comunica con "l'esterno" tramite unità di dominio)



probabilmente un terzo modulo che avvi i test automatici e utilizzando i 2 moduli sopra descritti e mostri i risultati, sarebbe un frontend molto semplice o una cli che fa chiamate api ed eventualmente può avviare un script che simula l'invio di dati in ingestion o in retrieval

Al fine di eseguire le query di test e i test di ingestion conviene includere la possibilità che glie embedding siano inviabili lato client



== Modulo core


Questo modulo deve contenere le classi che rappresentano l'organizzazione dei dati, conviene progettarlo senza dipendenze dalle tecnologie, 

Tale oggetto/struttura dati deve esprimere le caratteristiche di ogni entità, ruoli dei campi dati (ovvero  quali devono essere utilizzabili per i filtraggio, quali per ricerche semantiche e full text, e ibrida) e relativi vincoli.

devono poi essere messe insieme in un'altra classe che sarà quella usata all'interno del sistema per passare le informazioni relative ai dati

questa non sarà impostabile direttamente tramite interfacce o simili, sarà un file di configurazione a cui si accede tramite una porta, questo permette comunque di non hard codare la configurazione ma mi evita la gestione dell'interazione dell'utente con questo aspetto.

Rimane comunque discretamente flessibile perché è modificabile 

si possono configurare le porte e gli adapter inbound di ingestione per accettare un input coerente con la configurazione

lo stesso database può essere generato / configurato in modo da essere coerente con la configurazione

i dettagli di come il database ottimizza la sua struttura per rendere le letture più efficienti non sono conosciute alla configurazione, il db usa la configurazione per decidere la propria struttura 


inoltre servono delle classi che rappresentino le singole entità da trattare in fase di ingestion


per quanto riguarda le classi da usare per ritornare i dati dopo una ricerca conviene modellarli più verso un concetto di risultato di una ricerca

bisogna anche modellare il concetto di query che deve essere passata al sistema 







== Modulo Benchmark-Frontend

Servono delle classi che rappresentano le query di test, queste contengono anche i risultati attesi e non serve ricalcolare gli embedding, perciò un layer di permanenza potrebbe essere un semplice file json, ma servono delle interfacce per l'aggiunta, 



