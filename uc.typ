= casi d'uso
N è riferito ai chunk
aggiungere ricerca semantica singola, ibrida singola


aggiungere ricerche su singole collection
== UC1 Ingestion
#list(
  [
  Contesto: 
  - Deve essere possibile caricare documenti nel database,
  - i documenti sono ticket, conversation item e attachments
  - i documenti vengono caricati nel seguente ordine: tutti i ticket #sym.arrow tutti i conversation item #sym.arrow tutti gli attachments
  - i documenti arrivano già con i campi testuali parsati e divisi in chunk.
  - i documenti possono ma non devono avere la lingua nota a priori
    - (se la lingua del documento non è nota a priori viene eseguita la language detection per ogni chunk indipendentemente)
  - i documenti vengono caricati periodicamente, perciò si assume il caricamento di liste di documenti con l'analisi di un documento alla volta #footnote()[
    Il caricamento periodico serve a concentrare in un momento di poca attività (la notte) un carico di lavoro molto pesante 
  ]
  - Il caricamento delle unità avviene a blocchi
  ],
  [
    Attore principale : Companion #footnote()[Non sono sicuro che l'attore sia il companion o se sia più corretto definirlo scheduler o qualcosa di simile]
  ],
  [
    Attore secondario : Modello di embedding
  ],
  [
    precondizioni:
    - il sistema è attivo
  ],
  [
    post condizioni:
    - le informazioni sono state caricate nel sistema e indicizzate sia con indice vettoriale che indice testuale.
  ],
  [
    Scenario principale: 
      + l'attore principale carica la lista dei ticket
        + l'attore carica un ticket (il ticket deve contenere i metadati del ticket e per ogni campo testuale la relativa lista di chunk)
          + lingua già inserita viene passata in automatico ai chunk
          + lingua non inserita, viene usato un modello di language detection
      + Il sistema salva i ticket tramite scritture bulk e non scritture singole.
          - viene usato il modello di embedding per calcolare gli embedding 
      + l'attore principale carica la lista dei conversation item
        + l'attore carica un conversation item(il ticket deve contenere i metadati del conversation item, l'identificativo del ticket e per ogni campo testuale la relativa lista di chunk)
          + lingua già inserita viene passata in automatico ai chunk
          + lingua non inserita, viene usato un modello di language detection
          - viene usato il modello di embedding per calcolare gli embedding
      + l'attore principale carica la lista degli allegati
        + l'attore carica un allegato (il ticket deve contenere i metadati dell'allegato e un riferimento al ticket o al conversation item di riferimento, e la relativa lista di chunk)
          + lingua già inserita viene passata in automatico ai chunk
          + lingua non inserita, viene usato un modello di language detection
          - viene usato il modello di embedding per calcolare gli embedding


  ],
  [
    Trigger: companion vuole caricare dati
  ]
)

== UC2 Ricerca linked ibrida

#list(
  [
  Contesto: 
    - La linked search consiste nel cercare contenuti rilevanti rispetto ad un query scritta dal companion
    - La linked search cerca su tutti i ticket, su tutti i conversation item e su tutti gli allegati. 
    - La linked search ritorna N risultati, (da chiarire se N è riferito ai chunk oppure ai ticket)
    - Il contenuto del risultato è definito dal contenuto della query (come per il select di sql)
    - Possono esserci diversi criteri per la ricerca sui ticket sui conversation item, sugli allegati (sui ticket sono rilevanti phrase query, match dove ci sono tutte le parole cercate oppure almeno una delle parole, sugli allegati invece potremmo imporre una ricerca solo per frasi, in quanto grazie alla loro dimensione possono avere molti più match)
    - Deve essere possibile specificare filtri.(da chiarire se filtri generici oppure filtri specifici per ticket,conv item, attachments)
  ],
  [
    Attore principale : Companion 
  ],
  [
    Attore secondario : Modello di embedding
  ],
  [
    precondizioni:
    - il sistema è attivo

  ],
  [
    post condizioni:
    - companion ha ricevuto N risultati rilevanti secondo linked search basata su hybrid search
  ],
  [
    Scenario principale: 
      + Companion invia una query contente N e i parametri della query
        - estensione per gestire query non valide

      + Il modello di embedding calcola il vettore relativo alla parte testuale della query
      + il sistema esegue la linked search ibrida basandosi sulla query e sul vettore di embedding appena calcolato
      + Companion visualizza la lista dei risultati
        + companion visualizza un risultato.

  ],
  [
    Trigger: companion vuole fare una ricerca
  ]
)


== UC3,UC4, UC5 Configurazione delle query di test
Al fine di testare correttamente il sistema vi è l'opzione di configurare delle query da eseguire durante i test


=== UC3 Aggiunta query di test
#list(
  [
  Contesto: 
    - serve poter aggiungere query di test
  ],
  [
    Attore principale : Supervisore
  ],
  [
    Attore secondario : Nessuno
  ],
  [
    precondizioni:
    - il sistema è attivo

  ],
  [
    post condizioni:
    - la query è stata aggiunta alla lista delle query di test.
    - viene salvato anche il vettore di embedding relativo alla domanda in linguaggio naturale.
  ],
  [
    Scenario principale: 
    + Il supervisore inserisce la lista dei valori di ritorno
      + inserisce un valore di ritorno
    + Il supervisore inserisce la lista dei filtri (assumiamo che tutti i filtri qui specificati vengano considerati come condizione AND, chiarire se servono query complesse contenti anche clausole or comprese loro composizioni varie)
      + Il supervisore inserisce una condizione che fa da filtro
    + Il supervisore inserisce la domanda in linguaggio naturale (chiarire come viene elaborata la domanda, se è possibile che venga chunkata oppure se è garantito a monte che rientri nella size window del modello)
  ],
  [
    Trigger: il supervisore vuole aggiungere una query
  ]
)


(Per evitare troppe chiamate api, salviamo il vettore di embedding da usare per la query e lo passiamo direttamente senza dover fare una chiamata api per ogni query di test)







== UC4 Rimozione query di test
#list(
  [
  Contesto: 
    - serve poter rimuovere una query di test
  ],
  [
    Attore principale : Supervisore
  ],
  [
    Attore secondario : Nessuno
  ],
  [
    precondizioni:
    - il sistema è attivo
    - esiste almeno una query di test

  ],
  [
    post condizioni:
    - la query è stata rimossa dalla lista delle query di test.
  ],
  [
    Scenario principale: 
    + Il supervisore seleziona la query da eliminare
  ],
  [
    Trigger: il supervisore vuole eliminare una query
  ]
)


== UC5 modifica Query di test
#list(
  [
  Contesto: 
    - serve poter modificare una query di test
  ],
  [
    Attore principale : Supervisore
  ],
  [
    Attore secondario : Nessuno
  ],
  [
    precondizioni:
    - il sistema è attivo

  ],
  [
    post condizioni:
    - la query è presente con i valori aggiornati nella lista delle query di test.
    - il vettore di embedding è coerente con la nuova domanda in linguaggio naturale
  ],
  [
    Scenario principale: 
    + Il supervisore può modificare la lista dei valori di ritorno
      + può inserire un valore di ritorno
      + può rimuovere un valore di ritorno
    + Il supervisore può modificare la lista dei filtri (assumiamo che tutti i filtri qui specificati vengano considerati come condizione AND, chiarire se servono query complesse contenti anche clausole or comprese loro composizioni varie)
      + Il supervisore può inserire una condizione che fa da filtro
      + Il supervisore elimina una condizione che fa da filtro
    + Il supervisore può modificare la domanda in linguaggio naturale (chiarire come viene elaborata la domanda, se è possibile che venga chunkata oppure se è garantito a monte che rientri nella size window del modello)
  ],
  [
    Trigger: il supervisore vuole modificare una query
  ]
)



== UC6 Configura parametri di test

#list(
  [
  Contesto: 
    - serve poter configurare i parametri per i test sotto sforzo
    - chiarire se questo caso d'uso serva oppure va bene che i parametri non siano modificabile tramite un'interfaccia applicativa
  ],
  [
    Attore principale : Supervisore
  ],
  [
    Attore secondario : Nessuno
  ],
  [
    precondizioni:
    - il sistema è attivo
  ],
  [
    post condizioni:
    - I parametri di configurazione dei test sono salvati.
  ],
  [
    Scenario principale: 
    // + Il supervisore inserisce il volume della base di dati su cui svolgere il test
    + Il supervisore inserisce il numero degli utenti paralleli da simulare
    + Il supervisore inserisce il cooldown che ogni utente simulato deve aspettare per eseguire una query
  ],
  [
    Trigger: il supervisore vuole configurare i parametri dei test
  ]
)



== UC7 Visualizza performance
#list(
  [
  Contesto: 
    - serve poter vedere le performance del sistema
  ],
  [
    Attore principale : Supervisore
  ],
  [
    Attore secondario : Nessuno
  ],
  [
    precondizioni:
    - il sistema è attivo
  ],
  [
    post condizioni:
    - il supervisore ha visualizzato le performance del sistema
  ],
  [
    Scenario principale: 
    serve definire esattamente quali sono le metriche rilevanti (quali sono le metriche relative alla qualità della retrieval:recall e simili, e anche quelle relative a performance pure)
    \[inserire elenco  metriche\]
    
  ],
  [
    Trigger: il supervisore vuole configurare i parametri dei test
  ]
)

= Casi d'uso che non so se servano

== UC8 Configura tabelle di test
#list(
  [
  Contesto: 
    - capire se serve poter configurare le tabelle tramite l'applicativo
  ],
  [
    Attore principale : Supervisore
  ],
  [
    Attore secondario : Nessuno
  ],
  [
    precondizioni:
    - il sistema è attivo
  ],
  [
    post condizioni:
    - il supervisore ha configurato la tabella
  ],
  [
    Scenario principale: 

      Se  è necessario configurare la tabella capire come configurarla, o meglio cosa è rilevante ai fini della configurazione
  ],
  [
    Trigger: il supervisore vuole configurare la tabella
  ]
)


== UC9 Aggiungi indice
#list(
  [
  Contesto: 
    - serve poter configurare gli indici in modo da testare diverse ottimizzazioni
  ],
  [
    Attore principale : Supervisore
  ],
  [
    Attore secondario : Nessuno
  ],
  [
    precondizioni:
    - il sistema è attivo
  ],
  [
    post condizioni:
    - il supervisore ha impostato un nuovo indice
  ],
  [
    Scenario principale: 
    serve definire cosa configurare, nome indice, target dell'indice, tipo di indice, clausole where.
  ],
  [
    Trigger: il supervisore vuole aggiungere un indice.
  ]
)
== UC10 Rimuovi indice

#list(
  [
  Contesto: 
    - serve poter configurare gli indici in modo da testare diverse ottimizzazioni
  ],
  [
    Attore principale : Supervisore
  ],
  [
    Attore secondario : Nessuno
  ],
  [
    precondizioni:
    - il sistema è attivo
  ],
  [
    post condizioni:
    - il supervisore ha rimosso un indice
  ],
  [
    Scenario principale: 
    + il supervisore seleziona l'indice da rimuovere
    + il sistema elimina l'indice
  ],
  [
    Trigger: il supervisore vuole aggiungere un indice.
  ]
)