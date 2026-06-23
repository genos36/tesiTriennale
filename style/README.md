# 🎨 Modulo Style (Estetica e Componenti)

Questo modulo definisce l'aspetto visivo puro della tesi. Utilizza esclusivamente le funzioni native di Typst (`#set` e `#show`) senza affidarsi a pacchetti o librerie esterne.

## 🧠 Principi di Design Applicati

* **Separation of Concerns (SoC):** L'estetica è nettamente separata dai contenuti, dai metadati e dai plugin. A sua volta, la tipografia di base (font, paragrafi) è separata dalla logica dei componenti complessi (tabelle, figure, capitoli).
* **Data-Driven Styling:** Gli stili non contengono stringhe "hardcoded" (es. "Capitolo" o "it"). Leggono dinamicamente la lingua, le traduzioni e i metadati dal modulo `/metadata/`, adattandosi in automatico alle scelte anagrafiche.
* **Approccio Dichiarativo vs Imperativo:** È stata eliminata la logica condizionale complessa (come i blocchi `if/else` sui numeri dei capitoli). Il template sfrutta le proprietà native di Typst, come il `supplement`, per gestire fluidamente le transizioni (ad es. da Capitoli ad Appendici) riducendo il codice fragile.

## 🛠️ Funzioni Esposte

Tramite il file `mod.typ`, il modulo esporta e orchestra l'estetica attraverso queste funzioni:

* `apply-typography(body)`: Applica le regole base del documento. Imposta i margini della pagina, il font (New Computer Modern), la lingua (in base ai metadata) e definisce l'interlinea e la giustificazione tipica dello standard LaTeX.
* `apply-components(body)`: Definisce le regole di comportamento per gli elementi strutturali:
  * **Tabelle:** Applica il riempimento zebrato automatico per le righe.
  * **Figure:** Assicura una spaziatura verticale coerente. Applica la proprietà `breakable: true` **esclusivamente** alle tabelle (`where(kind: table)`), permettendo a queste ultime di fluire su più pagine e mantenendo invece indivisibili le immagini.
  * **Intestazioni (Headings):** Definisce lo stile, gli spazi e la numerazione automatica ("1.1") iniettando la dicitura corretta in base alla lingua (es. "Capitolo 1" o "Chapter 1").
* `apply-styles(body)`: L'orchestratore principale. Richiama in sequenza `apply-typography` e `apply-components`. È l'unica funzione che necessita di essere importata e applicata (`#show: apply-styles`) nel file di configurazione centrale della tesi.
