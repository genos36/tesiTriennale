#import "/plugin/mod.typ": gl, glpl
#import "/metadata/mod.typ": data

#pagebreak(to: "odd")

= Analisi dei requisiti<cap:analisi-requisiti>

#text(style: "italic", [
  In questo capitolo effettuo l'analisi degli utenti, sviluppo le user stories e compongo la lista dei requisiti dividendoli per tipologia e necessità.
])

#include "actor/index.typ"
#include "use-case/index.typ"







== Tracciamento dei requisiti
Ad ogni requisito è associato un codice costruito in base alle sue caratteristiche:
#v(1em)
#align(center)[*(F/Q/C)(M/D/O)R*]
#v(1em)
#set list(marker: none)
- F (_Functional_): definisce una funzione di un sistema o dei suoi componenti;
- Q (_Qualitative_): rappresentano come il sistema deve essere per soddisfare i requisiti dello stakeholder;
- C (_Constraint_): rappresentano dei vincoli o dei limiti che il sistema deve rispettare;
#v(0.5em)
- M (_Mandatory_): irrinunciabili per qualcuno degli stakeholder;
- D (_Desirable_): non strettamente necessari ma a valore aggiunto riconoscibile;
- O (_Optional_): relativamente utili oppure contrattabili anche in fasi avanzate del progetto;
#v(0.3em)
- R (_Requirement_): requisito
#v(1em)
In @tab:requisiti-funzionali, @tab:requisiti-qualitativi e @tab:requisiti-vincolo sono riassunti i requisiti e il loro tracciamento con gli use case delineati in fase di analisi.
#[
  #show figure: set block(breakable: true)
  #set table(
    align: (center + horizon, left + horizon, center + horizon),
    columns: (auto, 5fr, 1.5fr),
  )
  #v(1em)
  #figure(
    table(
      table.header(
        [*Codice*],
        [*Descrizione*],
        [*Fonti*],
      ),
      // ..getFR().flatten()
    ),
    caption: "Tracciamento dei requisiti funzionali.",
  )
  <tab:requisiti-funzionali>

  #v(2em)
  #figure(
    table(
      align: (center + horizon, left + horizon, center + horizon),
      table.header(
        [*Codice*],
        [*Descrizione*],
        [*Fonti*],
      ),
      // ..getQR().flatten()
    ),
    caption: "Tracciamento dei requisiti di qualità.",
  )
  <tab:requisiti-qualitativi>

  #v(2em)
  #figure(
    table(
      align: (center + horizon, left + horizon, center + horizon),
      table.header(
        [*Codice*],
        [*Descrizione*],
        [*Fonti*],
      ),
      // ..getCR().flatten()
    ),
    caption: "Tracciamento dei requisiti di vincolo.",
  )
  <tab:requisiti-vincolo>

  #v(2em)
  Di seguito, nella @tab:riepilogo-requisiti ho inserito il riepilogo dei requisiti, suddivisi per tipologia e necessità.
  #v(1em)
  #show figure: set block(breakable: false)
  #figure(
    table(
      columns: (auto, 1fr, 1fr, auto, auto),
      table.header([*Tipo*], [*Mandatory*], [*Desirable*], [*Optional*], [*Somma*]),
      [Functional],
      // [#getFR(getLen: true).at(0)],
      // [#getFR(getLen: true).at(1)],
      // [#getFR(getLen: true).at(2)],
      // [#getFR(getLen: true).sum()],

      // [Qualitative],
      // [#getQR(getLen: true).at(0)],
      // [#getQR(getLen: true).at(1)],
      // [#getQR(getLen: true).at(2)],
      // [#getQR(getLen: true).sum()],

      // [Constraint],
      // [#getCR(getLen: true).at(0)],
      // [#getCR(getLen: true).at(1)],
      // [#getCR(getLen: true).at(2)],
      // [#getCR(getLen: true).sum()],

      [*Totale*],
      // [*#{ getFR(getLen: true).at(0) + getQR(getLen: true).at(0) + getCR(getLen: true).at(0) }*],
      // [*#{ getFR(getLen: true).at(1) + getQR(getLen: true).at(1) + getCR(getLen: true).at(1) }*],
      // [*#{ getFR(getLen: true).at(2) + getQR(getLen: true).at(2) + getCR(getLen: true).at(2) }*],
      // [*#{ getFR(getLen: true).sum() + getQR(getLen: true).sum() + getCR(getLen: true).sum() }*],

      align: (center + horizon),
    ),
    caption: "Riepilogo dei requisiti.",
  )<tab:riepilogo-requisiti>
]
