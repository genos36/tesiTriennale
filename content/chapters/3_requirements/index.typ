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
#align(center)[*R(F/Q/C)(M/D/O)*]
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

In @tab:requisiti-funzionali, tab:requisiti-qualitativi e tab:requisiti-vincolo sono riassunti i requisiti e il loro tracciamento con gli use case delineati in fase di analisi.

#include "requirement/index.typ"



  #v(2em)
  Di seguito, nella @tab:riepilogo-requisiti ho inserito il riepilogo dei requisiti, suddivisi per tipologia e necessità.
  #v(1em)
  #show figure: set block(breakable: false)

  #import "/content/chapters/3_requirements/requirement/requisiti-funzionali/index.typ":obb as f-obb,des as f-des,opz as f-opz 
  #import "/content/chapters/3_requirements/requirement/requisiti-vincolo/index.typ":obb as m-obb,des as m-des,opz as m-opz 

  #let functional-count=(
    f-obb.len(),
    f-des.len(),
    f-opz.len(),
  )
  #let mandatory-count=(
    m-obb.len(),
    m-des.len(),
    m-opz.len(),
  )
  #figure(
    table(
      columns: (auto, 1fr, 1fr, auto, auto),
      table.header([*Tipo*], [*Mandatory*], [*Desirable*], [*Optional*], [*Somma*]),
      [Functional],
      ..functional-count.map(it=>str(it)),
      [#functional-count.sum()],
      [Mandatory],
      ..mandatory-count.map(it=>str(it)),
      [#mandatory-count.sum()],

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


