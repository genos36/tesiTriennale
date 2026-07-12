== Analisi degli Utenti <cap:actor-analisys>

Al fine di modellare correttamente le interazioni e definire i confini del sistema oggetto del tirocinio, è necessario individuare gli attori coinvolti.

In accordo con le metodologie di ingegneria del software, gli attori comprendono sia gli utenti umani sia i sistemi software esterni che interagiscono direttamente con l'architettura.


Gli attori sono classificati in due categorie:

    - Attori Primari: entità che avviano i casi d'uso e richiedono un servizio al sistema.

    - Attori Secondari: servizi o sistemi esterni invocati dal sistema per completare una specifica elaborazione.


=== Attori Primari

==== Companion
Con il termine *Companion* si identifica l'applicativo aziendale di Intelligenza Artificiale di livello superiore. Questo attore software funge da client principale: è il sistema reale all'interno del quale il modulo sviluppato durante lo stage verrebbe integrato (a scopo esplorativo).

Il Companion interagisce con il sistema per due scopi fondamentali: delegare l'ingestione dei dati documentali e interrogare la base di conoscenza tramite la pipeline RAG per ottenere il contesto necessario alla generazione delle risposte.


==== Supervisore
Rappresenta l'utente tecnico qualificato.
Il suo ruolo è quello di interfacciarsi con il sistema a scopo di analisi, validazione e benchmarking.
Il Supervisore avvia i test prestazionali, monitora l'infrastruttura e raccoglie le metriche necessarie per valutare e comparare le prestazioni del nuovo database unificato rispetto alla soluzione correntemente usata in produzione.



=== Attori Secondari
==== Modello di Embedding
Si tratta di un attore software esterno che fornisce il servizio di vettorizzazione.
Il sistema oggetto dello stage invoca questo attore delegandogli il compito computazionale di trasformare i chunk di testo grezzo in vettori numerici, questi vettori verranno poi usati per popolare l'indice vettoriale e per l'esecuzione della ricerca semantica.
