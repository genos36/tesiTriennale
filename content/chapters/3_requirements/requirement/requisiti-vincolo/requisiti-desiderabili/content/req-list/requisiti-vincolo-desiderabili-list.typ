#import "../deps/utils.typ" as utils

// ============================================================================
// ⚠️ ATTENZIONE: FILE GENERATO AUTOMATICAMENTE ⚠️
// ============================================================================
// Questo file è stato creato dallo script di automazione (manager.py).
// NON MODIFICARE MANUALMENTE QUESTO FILE!
// 
// Qualsiasi modifica apportata qui verrà inesorabilmente cancellata 
// alla prossima esecuzione dello script.
//
// 🛠️ COME FARE MODIFICHE:
// - Per aggiungere, rimuovere o riordinare i file: modifica il file 'config.yml'.
// - Per modificare il contenuto di una singola voce: apri il file .typ corrispondente.
// - Per cambiare questa intestazione: modifica 'config/index_header.typ'.
//
// ============================================================================


#let table-cells=(:)

#import "RCD01_uso_kubernetes.typ": data as item_0, req-name as req-0


#table-cells.insert(
  req-0
  ,
  item_0
  )



#import "RCD02_non_ordine_dei_dati_in_ingestion.typ": data as item_1, req-name as req-1


#table-cells.insert(
  req-1
  ,
  item_1
  )



#import "RCD03_benchmark_avanzati.typ": data as item_2, req-name as req-2


#table-cells.insert(
  req-2
  ,
  item_2
  )





// ============================================================================
// 📦 ESPORTAZIONE DATI (API DEL MODULO)
// ============================================================================
// L'array 'all_data' contiene tutti i dizionari esportati dai singoli file.
// 
// Esempio di utilizzo nel tuo main.typ:
// #import "percorso/a/_index.typ": all_data
// 
// 
// 
// --- Fine del file generato ---