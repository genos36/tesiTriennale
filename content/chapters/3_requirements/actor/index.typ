#import "/plugin/mod.typ": gl, glpl


== Analisi degli utenti <cap:actor-analisys>

Al fine di modellare correttamente le interazioni e definire i confini del sistema oggetto del tirocinio, è necessario individuare gli attori coinvolti.

In accordo con le metodologie dell'ingegneria del software, gli attori comprendono sia gli utenti umani sia i sistemi software esterni che interagiscono direttamente con l'architettura.


Gli attori sono classificati in due categorie:

    - Attori primari: entità che avviano i casi d'uso e richiedono un servizio al sistema.

    - Attori secondari: servizi o sistemi esterni invocati dal sistema per completare una specifica elaborazione.

// === Divisione in sotto sistemi del progetto
// Prima di procedere oltre con l'analisi
// Il progetto tratta 2 aspetti molto importanti ma separati concettualmente, la loro gestione contemporanea tramite un unico sistema sarebbe ambigua, perciò ho scelto di dividere il progetto in questi due sistemi:
// - *sistema di ricerca*, o sistema di information retrieval, realizza le funzionalità di ingestion e information retrieval;
// - *Sistema di test*, realizza le funzionalità di test delle performance.


=== Attori primari

- #block()[ *Companion*

        Con il termine *Companion* si identifica l'applicativo aziendale di intelligenza artificiale di livello superiore. Questo attore software è il client principale: è il software applicativo reale che utilizza il modulo di information retrieval. Companion interagisce con il sistema di ricerca tramite chiamate #gl("api").
        Companion interagisce con il sistema di ricerca per due scopi fondamentali: delegare l'ingestion dei dati documentali e interrogare la base di conoscenza per ottenere le informazioni necessarie alla generazione delle risposte.
]

- #block(breakable: false)[
     *Supervisore*

     Rappresenta l'utente tecnico qualificato.
     Il suo ruolo è quello di interfacciarsi con il sistema di test a scopo di analisi, validazione e benchmarking.
     Il Supervisore avvia i test prestazionali, monitora l'infrastruttura e raccoglie le metriche necessarie per valutare e comparare le prestazioni del nuovo database unificato rispetto alla soluzione attualmente usata in produzione.

]


=== Attori secondari
- #block()[
*Modello di embedding*

Si tratta di un attore software esterno che fornisce il servizio di calcolo degli embedding.
Il sistema di ricerca oggetto dello stage invoca questo attore delegandogli il compito computazionale di trasformare i #gl("chunk-testo",display:"chunk di testo") grezzo in vettori numerici, che verranno poi usati per popolare l'indice vettoriale e per l'esecuzione della ricerca semantica.

]
- #block()[
*Modello di reranking*

Si tratta di un attore software esterno che realizza la funzione di #gl("reranking",display:"reranking") dei risultati della ricerca semantica e della ricerca full-text.
]
