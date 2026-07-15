== Casi d'uso <cap:user-stories>
In questa sezione vengono definiti i casi d'uso del sistema. Ogni caso d'uso è univocamente identificato da una sigla progressiva (es. *UC-X*) ed è corredato da una scheda descrittiva analitica. Gli attori menzionati fanno diretto riferimento alle definizioni riportate nella sezione @cap:actor-analisys.

=== Struttura della scheda descrittiva
Ciascun caso d'uso è documentato attraverso le informazioni elencate nella tabella seguente. Al fine di mantenere la documentazione concisa, i campi non rilevanti o non applicabili a uno specifico scenario verranno omessi.

#table(
  columns: (0.28fr, 0.72fr),
  inset: 8pt,
  fill: (_, row) => if row == 0 { luma(230) } else { white },
  table.header(
    [*Campo*], [*Descrizione*],
  ),
  [Grafico UML],
  [Rappresentazione visiva dello scenario tramite diagramma UML dei casi d'uso.],
  [Attore principale],
  [Entità esterna che avvia l'interazione con il sistema per raggiungere un obiettivo specifico.],
  [Attore secondario],
  [Sistema o servizio esterno invocato dal sistema per completare una determinata funzionalità.],
  [Scenario principale],
  [La sequenza nominale di operazioni necessaria per portare a compimento il caso d'uso senza interruzioni.],
  [Precondizioni],
  [Stato del sistema o requisiti che devono essere necessariamente soddisfatti prima dell'avvio del caso d'uso.],
  [Postcondizioni],
  [Stato del sistema o modifiche persistenti che si verificano al termine della corretta esecuzione dello scenario principale.],
  [Scenario alternativo],
  [Flussi di esecuzione secondari che deviano dallo scenario base, tipicamente per gestire anomalie, errori o percorsi non standard.],
  [Inclusioni],
  [Relazioneverso un altro caso d'uso, il cui comportamento è obbligatoriamente e incondizionatamente incorporato nello scenario corrente.],
  [Estensioni],
  [Relazione che introduce un comportamento opzionale o alternativo, attivato unicamente al verificarsi di specifiche condizioni.],
  [Specializzazioni],
  [Varianti strutturali del caso d'uso generale. I casi d'uso specializzati sono tra loro mutualmente esclusivi ed ereditano i comportamenti dello scenario base.],
  [Trigger],
  [L'evento, l'azione o la condizione scatenante che innesca l'esecuzione del caso d'uso.],
)
=== Lista dei Casi d'Uso
#include "content/UC01-data-ingestion.typ"
