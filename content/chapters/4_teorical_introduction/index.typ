#import "/plugin/mod.typ": gl, glpl
#import "/metadata/mod.typ": data

#import "/content/chapters/3_requirements/use-case/content/deps/utils/code-set-up.typ": uc-link, uc-link-extended

#pagebreak(to: "odd")

= Introduzione Teorica<cap:introduzione-teorica>
#text(style: "italic", [
  In questo capitolo approfondisco le basi teoriche rilevanti per la realizzazione del progetto, le tecnologie rilevanti per il progetto e relativi ruoli nella risoluzione dei problemi affrontati, quali strumenti sono stati adottati e altri strumenti adottati durante lo sviluppo.
])
#v(1em)

== Contesto e problema

Il progetto ha una finalità esplorativa, mira solo a valutare l'adeguatezza di Postgres come sistema di information retrieval.

L'adeguatezza è valutata secondo due criteri: i tempi di risposta e la qualità del retrieval, misurata tramite metriche di hit rate a diversi livelli di granularità. La definizione completa delle metriche è riportata nel caso d'uso #uc-link-extended("Visualizza metriche di performance",separator: "-").

L'azienda dispone già di un sistema di information retrieval basato su Elasticsearch, tuttavia questo sistema ha delle limitazioni legate alla sua natura non relazionale e orientata ai documenti. Il sistema basato su Postgres mirerà a replicarne le funzionalità in modo fedele eccetto per alcune deviazioni, indicate nella @limiti-elasticsearch, che rispecchiano quanto realmente voluto dall'azienda ma che non era possibile realizzare in un sistema basato su Elasticsearch 

Per giustificare alcune scelte e capire meglio l'utilità di alcune funzionalità , in particolare della ricerca linked, è utile ricordare che il sistema di information retrieval si colloca dentro un sistema RAG, per ulteriori informazioni si veda @cap:descrizione-stage


=== Limiti di elastic <limiti-elasticsearch>
Il limite principale di elastic è la non natività dei join, non nascendo come database relazionale il supporto ai join non è nativo e richiede work-around.

Un altro limite dell sistema basato su Elasticsearch è l'impossibilità di eseguire la ricerca per similarità su sottoinsiemi di campi di testo divisi in chunk, questo non è un limite esclusivo di Elasticsearch ma anche dell'applicativo aziendale che lo usa. Tale funzionalità però è implementata per la ricerca full-text.

Per questo motivo il sistema di ricerca realizzato durante il tirocinio non rispecchierà elasticsearch sotto questo aspetto, invece si allineerà con il comportamento desiderato dall'impresa.



l'adeguatezza viene valutata in base alle metriche di performance relative alla velocità, alla qualità dei risultati io sviluppo il sistema di test perché una funzionalità potrebbe renderlo incompatibile con la forma delle query del sistema precedente, 

per quanto riguarda il consumo di risorse l'azienda dispone già di tool di observability che permettono di osservare cose come il peso del db, per me sarebbe più un integrarle nella dashboard

Nel contesto reale questo sistema si integra in un sistema RAG, questo è utile a capire la finalità della ricerca linked
L'azienda ha un sistema rag, il sistema che viene usato per la parte generativa è ok e non richiede valutazioni, solo il sistema di retrieval è sottoposto a valutazione, tuttavia il senso della ricerca linked emerge bene se tale dettaglio è fornito, altrimenti per il lettore ha poco senso a mio parere personale (forse non è il punto della tesi giusto per dare tale info, più adatto alla descrizione del tirocinio)

Attualmente il sistema utilizza una base di dati non relazionale elasticsearch, che seppur offra una ricerca full text di alto livello non è pensata per i join e l'applicativo attuale non supporta bene l'utilizzo di vettori di embedding multipli per i campi dati testuali(è più un problema dell'applicativo software, ma non si possono avere embedding di 2 campi, ad esempio se un allegato avesse un campo dati summary e un campo dati content , entrambi divisi in chunk di testo, questi sarebbero ricercabili separatamente solo tramite full text, non tramite ricerca semantica, ma ome ho detto è più un limite dell'applicativo aziendale corrente che un limite di elastic) 

Il sistema cerca di rispecchiare il comportamento di elasticsearch per onesta nel confronto, tranne per la ricerca su sotto insiemi di campi dati ricercabili (prima non era possibile cercare solo su content dell'allegato, solo su summary oppure solo su un terzo campo e varie combinazioni di questi), questa differenza di progettazione è accettata anzi necessaria perché il vecchio applicativo non la realizzava per un limite tecnico accettato

Il problema dell'information retrieval in questo contesto assume 2 sfumature: ricerca su singola entità e ricerca linked.

La ricerca su singola entità passa in rassegna la collezione dati relativa solo a quell'entità e cerca il testo più simile

La ricerca linked per ogni entità del sistema esegue la ricerca di similarità sulla singola entità poi dai risultati ottenuti va a fare dei join sulle altre entità del sistema sulla base di regole configurate alla creazione del sistema, successivamente viene applicata una fusione dei risultati ottenuti dalle varie entità.


vengno date info sul modelllo dati nella descrizione delloo stage e nei requisiti di vincolo, non mi ero reso conto che conviene dare un breve recap del modello dati




== Basi teoriche

=== Information retrieval e ricerca full-text
=== Ricerca semantica e vector embedding
=== Ricerca ibrida

== Architettura del progetto

=== Sistema principale
=== Sistema di test
=== Relazione tra i sistemi

== Criteri di scelta delle tecnologie 
Come menzionato nella @tab:requisiti-vincolo la gran parte dello stack tecnologico è già stato deciso dall'azienda

Si è scelto di limitare il più possibile l'aggiunta di ulteriori librerie che potrebbero nascondere aspetti rilevanti per il progetto, in particolare non vengono usate librerie per la costruzione delle query o ORM, in quanto possono andare a nascondere parte della complessità di integrazione tra postgres e il sistema principale e vi è il rischio seppur remoto di non riuscire a ottimizzare le ricerche costruite con tool di terze parti.

Il progetto ha una finalità esplorativa perciò non sono state adottate rigorosamente pratiche di contrrollo di qualità del codice


== Tecnologie del sistema di ricerca principale

=== backend
=== database
=== deployment

== Tecnologie del sistema di test
=== database
=== deployment
== Librerie e strumenti di supporto
== Strumenti di sviluppo
