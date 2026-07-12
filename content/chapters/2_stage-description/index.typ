#import "/plugin/mod.typ": gl, glpl
#import "/metadata/mod.typ": data
#import "/template/components/risc-list.typ": risc-list

= Descrizione stage<cap:descrizione-stage>
#text(style: "italic", [
  In questo capitolo approfondisco l'organizzazione dello stage, il rapporto con l'azienda e svolgo l'analisi dei rischi.
])
#v(1em)

== Competenze da apprendere

Il tirocinio è strutturato per favorire lo sviluppo di un ventaglio di competenze trasversali, che spaziano dalla progettazione architetturale di alto livello fino all'implementazione tecnica.

Dal punto di vista metodologico, lo stage mira a consolidare le capacità di analisi dei requisiti,
astrazione dei problemi complessi e progettazione di soluzioni algoritmiche generali e scalabili,
promuovendo inoltre la collaborazione attiva con i tutor e gli stakeholder aziendali.

Sotto il profilo tecnico, il percorso formativo permetterà di acquisire e approfondire le seguenti tematiche:
- Sistemi AI e NLP: Comprensione dei fondamenti del Natural Language Processing e integrazione di modelli linguistici e framework associati.
- Database Avanzati: Padronanza nell'utilizzo di PostgreSQL non solo come database relazionale, ma come motore di Information Retrieval vettoriale tramite l'estensione pgvector.
- Progettazione della Ricerca Ibrida: Studio e valutazione delle tecnologie di indicizzazione. Per garantire un confronto equo e rigoroso con Elasticsearch, oltre alla ricerca full-text nativa di PostgreSQL, verrà esplorata l'integrazione di ParadeDB, una soluzione basata su Postgres che promette capacità di ricerca lessicale altrettanto evolute.
- Testing Comparativo: Acquisizione di metodologie per la conduzione di benchmark, definendo metriche di valutazione per misurare le performance e l'efficienza dei sistemi sviluppati.
== Vincoli
Il progetto è soggetto a specifici vincoli architetturali volti a garantire la coerenza con gli obiettivi della ricerca. Il vincolo primario è l'adozione esclusiva dell'estensione pgvector su ecosistema PostgreSQL per la gestione e l'interrogazione dei vettori di embedding.


== Pianificazione


Lo stage si articola in 320 ore distribuite su otto settimane da 40 ore.

La pianificazione, derivata dal piano di lavoro, è la seguente:
+ Prima Settimana - Studio e analisi iniziale del nuovo e del vecchio stack tecnologico e setup (40 ore): studio delle tecnologie, setup dell'ambiente di lavoro locale e prove generiche;

+ Seconda Settimana - Analisi comparativa dettagliata di elastic search e Postgres con tentativo di modellazione di un sottoinsieme limitato del probleme;
+ Terza Settimana - Studio del dominio, definizione dei requisiti e dei casi d'uso e definizione dello schema relazionale
+ Quarta settimana - Studio del dominio, definizione dei requisiti e dei casi d'uso e definizione dello schema relazionale e ottimizzazione tramite indici
+ Quinta settimana - Strutturazione del modulo di ingestion
+ Sesta settimana - Strutturazione del modulo API e integrazione dei framework di observability
+ Settima settimana - Testing e ottimizzazioni
+ Ottava settimana - Testing e ottimizzazioni





== Analisi dei rischi

I rischi identificati per questo progetto sono classificati con un codice progressivo della forma *RN*, dove *N* è un numero intero incrementale che parte da 01, e decorati con una probabilità di occorrenza, un impatto e una strategia di mitigazione.

Ogni rischio è stato analizzato tenendo conto della complessità di comprendere i casi d'uso del sistema di paragone Elastic, delle sue scelte implementative dovute allo stack tecnologico e dalla comprensione degli interessi sperimentativi dell'impresa.


#risc-list(
  risc-prefix: "R",
  (
          (
              name: "Incompletezza o ambiguità dei requisiti",
              description: [
                I requisiti descritti nel piano di lavoro possono risultare incompleti o ambigui, portando a implementazioni non coerenti con le aspettative aziendali.
              ],
              mitigation: [
                I requisiti vengono analizzati e chiariti prima delle attività di codifica. Viene data priorità ad attività di studio teorico dello stack tecnologico e alla realizzazione di prototipi a diversi livelli di complessità. Sono previsti incontri iterativi con il tutor per definire chiaramente i confini del progetto e le interfacce di comunicazione.
              ],
              probability: "Medio-Alta",
              consequences: ["Medio"],
            ),
            (
              name: "Sovradimensionamento del progetto rispetto alle tempistiche",
              description: [
                Le attività previste potrebbero rivelarsi eccessive rispetto al monte ore disponibile e alle tempistiche di apprendimento, con il rischio di non completare tutti gli obiettivi prefissati.
              ],
              mitigation: [
                Le attività sono suddivise per priorità (requisiti Obbligatori, Desiderabili, Opzionali). In caso di ritardi o imprevisti strutturali, solo le attività a priorità inferiore e non vincolanti per il core del progetto subiranno ridimensionamenti.
              ],
              probability: "Media",
              consequences: ["Alto"],
            ),
            (
              name: "Difficoltà nel coordinamento interno",
              description: [
                La comunicazione con il tutor aziendale o con gli stakeholder potrebbe risultare discontinua, rallentando il processo decisionale tecnico e causando incomprensioni.
              ],
              mitigation: [
                Vengono pianificati incontri periodici di allineamento, accompagnati da aggiornamenti asincroni frequenti sullo stato di avanzamento. Eventuali blocchi tecnici (blocker) vengono segnalati tempestivamente senza attendere la riunione successiva.
              ],
              probability: "Media",
              consequences: ["Alto"],
            ),
            (
              name: "Curva di apprendimento delle tecnologie",
              description: [
                L'assimilazione delle tecnologie necessarie (es. pgvector, framework NLP) potrebbe richiedere un tempo di studio superiore alle stime iniziali.
              ],
              mitigation: [
                Le prime settimane dello stage includono ore dedicate esplicitamente allo studio della documentazione ufficiale, alla schematizzazione delle architetture e alla realizzazione di proof-of-concept (PoC) isolati.
              ],
              probability: "Bassa",
              consequences: ["Medio"],
            ),
            (
              name: "Incompatibilità o difficoltà di integrazione con il sistema legacy",
              description: [
                Il modulo realizzato dovrà essere testato in un ambiente paragonabile a quello di produzione; potrebbero emergere attriti o incompatibilità nell'interfacciamento con il sistema esistente.
              ],
              mitigation: [
                Confronto continuo con il team di sviluppo per comprendere a fondo i contratti delle interfacce. Adozione del design pattern "Adapter" fin dalle prime fasi di progettazione per disaccoppiare la logica del nuovo sistema da quella preesistente.
              ],
              probability: "Media",
              consequences: ["Medio"],
            ),
            (
                name: "Saturazione delle risorse durante i benchmark",
                description: [
                  L'esecuzione dei test comparativi su volumi di dati enterprise (fino a 500.000 record) potrebbe causare la saturazione delle risorse hardware dell'ambiente di test, falsando le metriche o causando crash di sistema.
                ],
                mitigation: [
                  I test verranno eseguiti in modo incrementale su dataset di dimensioni crescenti.

                  Verrà implementato un monitoraggio attivo delle risorse tramite il framework di observability per individuare eventuali memory leak o configurazioni sub-ottimali degli indici vettoriali prima dei test massivi.
                ],
                probability: "Media",
                consequences: ["Alto"],
              ),
              (
                  name: "Rappresentatività dei dati di test e accesso limitato alla produzione",
                  description: [
                    L'utilizzo di dati generati appositamente per le fasi di test locali, reso necessario dai vincoli di privacy aziendale, potrebbe non riflettere a pieno la reale complessità e varianza del dominio. Questa discrepanza rischia di alterare la valutazione dell'accuratezza degli embedding e di non far emergere casistiche limite verosimili, portando a possibili divergenze di performance tra l'ambiente di sviluppo e le aspettative finali.
                  ],
                  mitigation: [
                    La validazione seguirà un approccio a due fasi: l'architettura dovrà innanzitutto superare i benchmark di riferimento in ambiente locale utilizzando dei dati di test.

                    A valle di questo consolidamento, le misurazioni definitive verranno eseguite sui dati reali operando esclusivamente all'interno dei server proprietari aziendali, nel pieno rispetto delle direttive di sicurezza.
                  ],
                  probability: "Alta",
                  consequences: ["Medio"],
                ),
  ),
)
