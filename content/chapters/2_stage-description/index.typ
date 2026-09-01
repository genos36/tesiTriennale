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
promuovendo inoltre la collaborazione con i tutor.

Sotto il profilo tecnico, il percorso formativo permetterà di acquisire e approfondire le seguenti tematiche:
- Database avanzati: Padronanza nell'utilizzo di Postgres non solo come database relazionale, ma come motore di Information Retrieval vettoriale tramite l'estensione pgvector.
- Progettazione della ricerca ibrida: Studio e valutazione delle tecnologie di indicizzazione. Per garantire un confronto equo e rigoroso con Elasticsearch, oltre alla ricerca full-text nativa di Postgres, verrà esplorata l'integrazione di ParadeDB, una soluzione basata su Postgres che promette capacità di ricerca lessicale altrettanto evolute.
- Testing delle performance: Acquisizione di metodologie per la conduzione di benchmark, definendo metriche di valutazione per misurare le performance e l'efficienza dei sistemi sviluppati.
== Vincoli
Il progetto è soggetto a specifici vincoli architetturali volti a garantire la coerenza con gli obiettivi della ricerca. 

I vincoli principali sono i seguenti:
- Utilizzo di pgvector per la ricerca vettoriale, obiettivo principale del progetto;
- Utilizzo della ricerca full-text nativa di Postgres, per semplicità di licensing.

Estensioni più evolute come ParadeDB, pur essendo state valutate in quanto si propongono come sostituto diretto della componente full-text di Elasticsearch su Postgres, sono state escluse dall'implementazione finale per rispettare il vincolo di licensing; il loro studio è stato comunque utile per orientare l'implementazione delle funzionalità di ricerca full-text nativa.

== Pianificazione <pianificazione-settimane>


Lo stage si articola in 320 ore distribuite su otto settimane da 40 ore.

La pianificazione, derivata dal piano di lavoro, è la seguente:

+ Prima Settimana - Studio e analisi iniziale del nuovo e del vecchio stack tecnologico e setup: studio delle tecnologie, setup dell'ambiente di lavoro locale e prove generiche;

+ Seconda Settimana - Analisi comparativa dettagliata di elastic search e Postgres con tentativo di modellazione di un sottoinsieme limitato del problema;

+ Terza Settimana - Studio del dominio, definizione dei requisiti e dei casi d'uso e definizione dello schema relazionale;

+ Quarta settimana - Studio del dominio, definizione dei requisiti e dei casi d'uso e definizione dello schema relazionale e ottimizzazione tramite indici;

+ Quinta settimana - Progettazione di alto livello del sistema e inizio della codifica del modulo di ingestion;
+ Sesta settimana - Completamento della codifica del modulo di ingestion e dei moduli di ricerca, completa delle relative interfacce; 
+ Settima settimana - Progettazione e implementazione del sistema di test partendo da dei dati locali fittizi; 
+ Ottava settimana - Benchmarking, realizzazione della dashboard e deployment.





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
              consequences: [Medio],
              r-label:"r-incompletezza"
            ),
            (
              name: "Sovradimensionamento del progetto rispetto alle tempistiche",
              description: [
                Le attività previste potrebbero rivelarsi eccessive rispetto al monte ore disponibile e alle tempistiche di apprendimento, con il rischio di non completare tutti gli obiettivi prefissati.
              ],
              mitigation: [
                Le attività sono suddivise per priorità (requisiti obbligatori, desiderabili, opzionali). In caso di ritardi o imprevisti strutturali, solo le attività a priorità inferiore e non vincolanti per lo scopo principale del progetto subiranno ridimensionamenti.
              ],
              probability: "Media",
              consequences: [Alto],
              r-label:"r-sovradimensionamento"
            ),
            (
              name: "Difficoltà nel coordinamento interno",
              description: [
                La comunicazione con il tutor aziendale o con gli stakeholder potrebbe risultare discontinua, rallentando il processo decisionale tecnico e causando incomprensioni.
              ],
              mitigation: [
                Vengono pianificati incontri periodici di allineamento, accompagnati da aggiornamenti asincroni frequenti sullo stato di avanzamento. Eventuali blocchi tecnici vengono segnalati tempestivamente senza attendere la riunione successiva.
              ],
              probability: "Media",
              consequences: [Alto],
              r-label:"r-coordinamento"
            ),
            (
              name: "Curva di apprendimento delle tecnologie",
              description: [
                L'assimilazione delle tecnologie necessarie (es. pgvector, fts Postgres) potrebbe richiedere un tempo di studio superiore alle stime iniziali.
              ],
              mitigation: [
                Le prime settimane dello stage includono ore dedicate esplicitamente allo studio della documentazione ufficiale, alla schematizzazione delle architetture e alla realizzazione di proof of concept isolati.
              ],
              probability: "Bassa",
              consequences: [Medio],
              r-label:"r-apprendimento"
            ),
            (
              name: "Incompatibilità o difficoltà di integrazione con il sistema legacy",
              description: [
                Il modulo realizzato dovrà essere testato in un ambiente paragonabile a quello di produzione; potrebbero emergere attriti o incompatibilità nell'interfacciamento con il sistema esistente.
              ],
              mitigation: [
                Confronto continuo con il team di sviluppo per comprendere a fondo le funzionalità da implementare. Adozione del design pattern "Adapter" fin dalle prime fasi di progettazione per disaccoppiare la forma dei dati accettata dal sistema con la forma dei dati che deve essere accettata dall'esterno.
              ],
              probability: "Media",
              consequences: [Medio],
              r-label:"r-integrazione"
            ),
            (
                name: "Saturazione delle risorse durante i benchmark",
                description: [
                  L'esecuzione dei test comparativi su volumi di dati enterprise (fino a 500.000 record) potrebbe causare la saturazione delle risorse hardware dell'ambiente di test, falsando le metriche o causando crash di sistema.
                ],
                mitigation: [
                  I test verranno eseguiti in modo incrementale su dataset di dimensioni crescenti.

                  Verrà implementato un monitoraggio attivo delle risorse tramite il framework di observability per individuare eventuali memory leak o configurazioni sub-ottimali degli indici vettoriali prima dei test massivi.

                  Inoltre è previsto l deployment del sistema di information retrieval su server remoto.
                ],
                probability: "Media",
                consequences: [Alto],
                r-label:"r-saturazione"
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
                  consequences: [Medio],
                  r-label:"r-rappresentatività",
                ),
                (
                    name: "Difficoltà nella valutazione oggettiva dei risultati di Retrieval",
                    description: [
                      L'assenza di metriche standardizzate o un'errata interpretazione dei risultati potrebbe portare a conclusioni soggettive, rendendo impossibile valutare se il nuovo sistema eguaglia o supera la soluzione precedente.
                    ],
                    mitigation: [
                      Le metriche di valutazione quantitativa verranno definite esplicitamente nella fase di analisi dei requisiti.

                      Queste corrispondono alle metriche attualmente usate per la valutazione del sistema attuale

                      È inoltre previsto un caso d'uso specifico per la produzione di una dashboard di monitoraggio, con criteri di accettazione e soglie minime di qualità chiaramente prestabiliti.
                    ],
                    probability: "Media",
                    consequences: [Alto],
                    r-label:"r-metriche"
                  ),
                  (
                    name: "Sbilanciamento metodologico nel confronto",
                    description: [
                      Essendo Postgres nato come RDBMS ed Elasticsearch come motore di ricerca con analizzatori linguistici avanzati, testare scenari non calibrati rischia di favorire asimmetricamente una delle due tecnologie, invalidando l'equità scientifica del benchmark.
                    ],
                    mitigation: [
                      Il set di query e il benchmark verranno definiti e "congelati" a priori, in stretta parità di funzionalità con l'attuale utilizzo in produzione, evitando scenari costruiti ad hoc per avvantaggiare una specifica piattaforma, cercheranno solo di rappresentare lo scenario reale.
                    ],
                    probability: "Alta",
                    consequences: [Alto],
                    r-label:"r-sbilanciamento"
                  ),
                  (
                    name: "Bias tecnologico e deriva dei requisiti",
                    description: [
                      Esiste il rischio di adattare inconsciamente l'implementazione per favorire le peculiarità di Postgres, introducendo logiche non necessarie o deviazioni dai requisiti originali solo per giustificare l'adozione della nuova tecnologia.
                     
                    ],
                    mitigation: [
                      Adozione  dell'architettura esagonale. Isolando la logica di dominio dall'infrastruttura di persistenza, si garantisce che i dettagli implementativi di Postgres non inquinino il comportamento atteso del sistema.
                    ],
                    probability: "Media",
                    consequences: [Alto],
                    r-label:"r-bias-requisiti"
                  ),
                  (
                    name: "Dispersione del perimetro di test su tecnologie alternative",
                    description: [
                      L'evoluzione rapida dell'information retrieval solleva l'interrogativo su alternative tecnologiche, come OpenSearch.

                      La loro valutazione va fuori dagli interessi dell'impresa per questo specifico tirocinio e rischia di aggiungere attività di studio non utili alla realizzazione del progetto.
                    ],
                    mitigation: [
                      I confini del tirocinio sono rigidamente circoscritti al confronto diretto tra la soluzione in uso, basata su Elasticsearch, e le tecnologie che l'impresa vuole valutare, Postgres + pgvector.

                      Eventuali tecnologie alternative verranno affrontate esclusivamente a livello teorico.
                    ],
                    probability: "Bassa",
                    consequences: [Medio],
                  ),
                  (
                    name: "Sovrapposizione tra le performance di Retrieval e Generation",
                    description: [
                      L'architettura RAG si compone di due fasi: la fase di retrieval che si occupa del recupero di informazioni e la generazione della risposta.
                      Nel sistema attuale solo la parte di retrieval e ingestion di documenti è collegata strettamente a ElasticSearch, le altre parti del sistema sono gestite in Python puro.
                    ],
                    mitigation: [
                      Vengono posti dei rigidi confini sul sistema da implementare.
                      L'implementazione, l'analisi e il testing si concentreranno unicamente sulla componente di Retriever e sul relativo modulo di ingestion.
                      La valutazione ignorerà la qualità dell'output generativo dell'LLM, misurando esclusivamente la pertinenza dei documenti e la velocità di recupero.
                    ],
                    probability: "Bassa",
                    consequences: [Alto],
                    r-label:"r-sovrapposizione"
                  )
  ),
)
