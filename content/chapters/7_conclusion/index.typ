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

== Raggiungimento degli obiettivi

== Requisiti soddisfatti
Tutti i requisiti descritti nella @ sonostati implementati come descritto nel riepilogo della @tab:requisiti-soddisfatti
  // #import "/content/chapters/3_requirements/requirement/requisiti-funzionali/index.typ":obb as f-obb,des as f-des,opz as f-opz 
  // #import "/content/chapters/3_requirements/requirement/requisiti-vincolo/index.typ":obb as c-obb,des as c-des,opz as c-opz 
  // #import "/content/chapters/3_requirements/requirement/requisiti-qualita/index.typ":obb as q-obb,des as q-des,opz as q-opz 

#[

#v(1em)
#figure(
  table(
    columns: (auto, 1fr, 1fr, auto, auto),
    table.header([*Tipo*], [*Mandatory*], [*Desirable*], [*Optional*], [*Somma*]),
    [Functional],
    [],
    [],
    [],
    [],
// 
    [Qualitative],
    [],
    [],
    [],
    [],
// 
    [Constraint],
    [],
    [],
    [],
    [],
// 
    [*Totale*],
    [],
    [],
    [],
    [],
// 
    align: (center + horizon),
  ),
  caption: "Riepilogo dei requisiti soddisfatti.",
)<tab:requisiti-soddisfatti>
== Rischi occorsi e mitigati
I rischi emersi durante lo stage sono riportati in @fig:rischi-occorsi.\
#v(1em)
#figure(
  caption: [Rischi occorsi con la loro mitigazione.],
  table(
    columns: 2,
    table.header([*Descrizione*], [*Mitigazione*]),
    [*R1* -- Descrizione del rischio], [Soluzione],
  ),
)<fig:rischi-occorsi>
#v(1em)

== Valutazione complessiva sulle tecnologie

Dei vari punti che questo progetto si prefiggeva di chiarire segue un resoconto ed un'analisi 
- Adeguatezza di pgvector alla ricerca semantica: *Confermato*, le query non sono particolarmente complesse, i tempi di risposta sono sufficientemente bassi di media tra i 200-300 millisecondi
- Fusione di full-text e semantica lato db, confermata, trattando le query sql di semantica e full text come subquery è facilmente implementabile l'rrf
- linking lato db, confermato, è possibile eseguire senza problemi i join tra le varie entità, essendo join su chiave primaria il look up avviene tramite indice
- ricerca full-text: non confermata, elastic search senza troppe sorprese è estremamente più veloce di postgres per la ricerca full-text, per quanto l'accuratezza tramite i workaround sia diventata sufficiente lucene rimane comunque molto più veloce di postgres. i meccanismi di ottimizzazione di elastic permettono un ordinamento esatto con scoring accelerato e possibilità di escludere partizioni non rilevanti




== Valutazione personale
