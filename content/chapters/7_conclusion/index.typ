#import "/metadata/mod.typ": data
#pagebreak(to: "odd")

= Conclusioni<cap:conclusioni>
#text(style: "italic", [
  In questo capitolo traggo le conclusioni sul progetto.
])
#v(1em)




== Consuntivo finale
Una volta terminato il progetto ho redatto il consuntivo orario finale nella @fig:tabella-calcolo-ore che suddivide in maniera approssimata le ore dedicate alle varie fasi.
#v(1em)
#set table(
  align: (center + horizon, center + horizon),
)

#let ore-attivita=(
  (
    descrizione:"Onboarding del progetto e studio delle tecnologie",
    ore:48
    ),
  (
    descrizione:"Progettazione della struttura del db e prototipazioni",
    ore:64
    ),
  (
    descrizione:"Progettazione e codifica della schema configuration",
    ore:20
    ),
  (
    descrizione:"Progettazione e codifica della ricerca semantica",
    ore:24
    ),
  (
    descrizione:"Progettazione e codifica ricerca full-text",
    ore:40
    ),
  (
    descrizione:"Progettazione e codifica ricerca ibrida",
    ore:8
    ),
  (
    descrizione:"Progettazione e codifica ricerca linked",
    ore:12
    ),
  (
    descrizione:"Progettazione e codifica del sistema di ingestion",
    ore:32
    ),
  (
    descrizione:"Progettazione e codifica del sistema di test e observability",
    ore:68
    ),
)


#figure(
  caption: [Consuntivo orario finale.],
  table(
    columns: 2,
    table.header([*Fase*], [*Ore*]),
    ..(ore-attivita.map(it=>{(it.descrizione,str(it.ore))}).flatten()),

    [*Totale*], str(ore-attivita.map((it)=>it.ore).sum()),
  ),
)<fig:tabella-calcolo-ore>
#v(1em)

== Requisiti soddisfatti
Tutti i requisiti descritti nella @tracciamento-requisiti sono stati implementati come descritto nel riepilogo della @tab:requisiti-soddisfatti
  #import "/content/chapters/3_requirements/requirement/requisiti-funzionali/index.typ":obb-len as f-obb,des-len as f-des,opz-len as f-opz
  #import "/content/chapters/3_requirements/requirement/requisiti-vincolo/index.typ":obb-len as c-obb,des-len as c-des,opz-len as c-opz
  #import "/content/chapters/3_requirements/requirement/requisiti-qualita/index.typ":obb-len as q-obb,des-len as q-des,opz-len as q-opz

#v(1em)
#figure(
  table(
    columns: (auto, 1fr, 1fr, auto, auto),
    table.header([*Tipo*], [*Obbligatori*], [*Desiderabili*], [*Opzionali*], [*Somma*]),
    [Funzionali],
    [48/#str(f-obb)],
    [0/#str(f-des)],
    [0/#str(f-opz)],
    [48/#str(f-obb+f-des+f-opz)],
//
    [Qualità],
    [1/#str(q-obb)],
    [0/#str(q-des)],
    [0/#str(q-opz)],
    [1/#str(q-obb+q-des+q-opz)],
//
    [Vincolo],
    [13/#str(c-obb)],
    [2/#str(c-des)],
    [0/#str(c-opz)],
    [15/#str(c-obb+c-des+c-opz)],
//
    [*Totale*],
    [62/#str(f-obb+c-obb+q-obb)],
    [2/#str(f-des+c-des+q-des)],
    [0/#str(f-opz+c-opz+q-opz)],
    [64/#str(f-des+c-des+q-des+f-obb+c-obb+q-obb+f-opz+c-opz+q-opz)],
//
    align: (center + horizon),
  ),
  caption: "Riepilogo dei requisiti soddisfatti.",
)<tab:requisiti-soddisfatti>
== Rischi occorsi e mitigati
I rischi documentati nella @analisi-rischi emersi durante lo stage sono riportati in @fig:rischi-occorsi.\
#v(1em)
#figure(
  caption: [Rischi occorsi con la loro mitigazione.],
  table(
    columns: 2,
    table.header([*Descrizione*], [*Mitigazione*]),
    [*R1*: Incompletezza o ambiguità dei requisiti], [Il rischio è stato incontrato durante lo studio iniziale, la mitigazione è stata il confronto con il tutor per colmare le lacune dei requisiti.],
    [*R07*: Rappresentatività dei dati di test e accesso limitato alla produzione],[
            Il rischio è stato incontrato durante la preparazione dei dati di test, non avendo accesso a dati veri di produzione si è optato per usare dati fittizzi generati a partire da dataset in lingua italiana e inglese.
    ],
    [*R08*: Difficoltà nella valutazione oggettiva dei risultati di retrieval],[
            Il rischio è stato incontrato durante la progettazione del sistema di test, mitigato tramite confronto con il tutor.
    ],
    [*R10*:Bias tecnologico e deriva dei requisiti],[
            Il rischio è stato incontrato nelle fasi iniziali dell'analisi delle funzionalità da realizzare, mitigato dando priorità alle caratteristiche del problema.
    ]
  ),
)<fig:rischi-occorsi>
#v(1em)

== Valutazione complessiva sulle tecnologie

Dei vari punti che questo progetto si prefiggeva di chiarire segue un resoconto ed un'analisi
- Adeguatezza di pgvector alla ricerca semantica: *Confermato*, le query non sono particolarmente complesse, i tempi di risposta sono sufficientemente bassi di media tra i 200-300 millisecondi;
- Fusione di full-text e semantica lato db: *Confermata*, trattando le query sql di semantica e full text come subquery è facile implementare l'rrf;
- linking lato db: *Confermato*, è possibile eseguire senza problemi i join tra le varie entità, essendo join su chiave primaria il look up avviene tramite indice;
- ricerca full-text: *Non confermata*, ElasticSearch senza troppe sorprese è estremamente più veloce di postgres per la ricerca full-text, per quanto l'accuratezza tramite i workaround sia diventata sufficiente. ElasticSearch rimane comunque molto più veloce di postgres. Il tempo medio di una ricerca full-text non ottimizzata per lingua va dai 5 ai 10 secondi, circa 3 secondi per le ricerche ottimizzate per lingua. Tale risultato è coerente con quanto visto nella @analisi-elasticsearch


L'accuratezza generale viene considerata buona per tutti i vari tipi di ricerca, il retrieval rate è stato sempre del 100%, ma questo è dovuto al dataset di test, essendo generato automaticamente. In uno scenario realistico è probabile che sarà più bassa, 90%.

All'accuratezza corrispondono inoltre diversi fattori esterni al sistema o elementi da gestire tramite configurazione:
- modello di embedding utilizzato,
- configurazioni di lingua,
- tipologia di vettori e distanza
- qualità della query, testi poco precisi implicano risposte poco valide (questo aspetto è in genere gestito dalla parte generativa della RAG, query rewriting)
- composizione del corpus documentale.






== Valutazione personale
Dal punto di vista personale ho trovato questo progetto molto stimolante.
L'argomento mi è risultato molto interessante, seppur alcune parti come a costruzione automatica delle query siano state particolarmente ostiche.

Per quanto non essere riuscito a raggiungere un risultato soddisfacente con la ricerca full-text sia stata una delusione, non è stata una sorpresa in quanto era un limite tecnologico noto fin dalle prime fasi di studio.

Per il resto mi ritengo soddisfatto.
