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
    ore:40
    ),
  (
    descrizione:"Primi prototipi per comprendere le tecnologie",
    ore:20
    ),
  (
    descrizione:"Progettazione della struttura del db",
    ore:40
    ),
  (
    descrizione:"Progettazione della schema configuration",
    ore:24
    ),
  (
    descrizione:"Progettazione della ricerca semantica",
    ore:16
    ),
  (
    descrizione:"Progettazione ricerca full-text",
    ore:32
    ),
  (
    descrizione:"Progettazione ricerca ibrida",
    ore:8
    ),
  (
    descrizione:"Progettazione ricerca linked",
    ore:12
    ),
  (
    descrizione:"",
    ore:20
    ),
  (
    descrizione:"",
    ore:20
    ),
)


#figure(
  caption: [Consuntivo orario finale.],
  table(
    columns: 2,
    table.header([*Fase*], [*Ore*]),
    ..(ore-attivita.map(it=>{(it.descrizione,str(it.ore))}).flatten()),

    [*Totale*], [320],
  ),
)<fig:tabella-calcolo-ore>
#v(1em)

== Raggiungimento degli obiettivi

== Requisiti soddisfatti
Arrivato alla fine del progetto ho implementato...
#v(1em)
// #figure(
//   table(
//     columns: (auto, 1fr, 1fr, auto, auto),
//     table.header([*Tipo*], [*Mandatory*], [*Desirable*], [*Optional*], [*Somma*]),
//     [Functional],
//     [0/#getFR(getLen: true).at(0)],
//     [0/#getFR(getLen: true).at(1)],
//     [0/#getFR(getLen: true).at(2)],
//     [0/#getFR(getLen: true).sum()],

//     [Qualitative],
//     [0/#getQR(getLen: true).at(0)],
//     [0/#getQR(getLen: true).at(1)],
//     [0/#getQR(getLen: true).at(2)],
//     [0/#getQR(getLen: true).sum()],

//     [Constraint],
//     [0/#getCR(getLen: true).at(0)],
//     [0/#getCR(getLen: true).at(1)],
//     [0/#getCR(getLen: true).at(2)],
//     [0/#getCR(getLen: true).sum()],

//     [*Totale*],
//     [*0/#{ getFR(getLen: true).at(0) + getQR(getLen: true).at(0) + getCR(getLen: true).at(0) }*],
//     [*0/#{ getFR(getLen: true).at(1) + getQR(getLen: true).at(1) + getCR(getLen: true).at(1) }*],
//     [*0/#{ getFR(getLen: true).at(2) + getQR(getLen: true).at(2) + getCR(getLen: true).at(2) }*],
//     [*0/#{ getFR(getLen: true).sum() + getQR(getLen: true).sum() + getCR(getLen: true).sum() }*],

//     align: (center + horizon),
//   ),
//   caption: "Riepilogo dei requisiti soddisfatti.",
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
