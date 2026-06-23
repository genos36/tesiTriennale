# Modulo Plugin 

Questo modulo gestisce l'integrazione di tutte le librerie esterne di Typst (es. Codly, Glossarium) all'interno del template della tesi.

## Principi di Design Applicati

* **Uso di wrapper** Il resto della tesi non interagisce mai direttamente con i pacchetti `@preview/...`. Le librerie esterne sono "avvolte" in funzioni personalizzate. Questo garantisce che, in caso di cambio di sintassi o sostituzione di una libreria, le modifiche rimangano confinate unicamente in questa cartella, senza impattare i capitoli della tesi.
* **Single Source of Truth (SSOT):** Il file `packages.typ` agisce come gestore centralizzato delle dipendenze. Le versioni dei pacchetti sono definite solo lì, azzerando il rischio di disallineamenti e semplificando gli aggiornamenti.
* **Disaccoppiamento dei Dati:** I plugin cercano di non importare dati direttamente (es. il file contenente le parole del glossario). I dati vengono iniettati dall'esterno tramite parametri, rendendo i moduli puri e riutilizzabili.

## 🛠️ Funzioni Esposte

Tramite il file `mod.typ`, questo modulo espone le seguenti funzioni pronte all'uso:

### Codly (Blocchi di codice)
* `code-init(body)`: Inizializza il motore di Codly. Imposta i colori (zebra-fill), i linguaggi supportati e associa il font monospazio corretto. Da usare solo nel `setup.typ` principale.
* `code-snippet(caption: none, source)`: Crea un blocco di codice sicuro. Avvolge il listato in una `figure` nativa di tipo "raw", permettendo al codice di spezzarsi su più pagine ma tenendo correttamente agganciata la didascalia.

### Glossarium (Glossario)
* `glossary-init(terms: (), body)`: Inizializza il motore del glossario. Riceve in input la lista dei termini (`terms`) in modo disaccoppiato. Da usare solo nel `setup.typ`.
* `gl(key, suffix: none, long: false, ...)`: Inserisce nel testo un riferimento al singolare per il termine specificato da `key`. Applica automaticamente lo stile custom (corsivo colorato con "G" a pedice) e genera il link.
* `glpl(key, ...)`: Versione plurale di `gl()`. Inserisce il termine al plurale applicando il medesimo stile grafico.
* `glossary-print()`: Stampa la tabella/lista finale del glossario. Da chiamare nel punto esatto del documento in cui si vuole far apparire il glossario completo.
