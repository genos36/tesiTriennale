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

#import "RFO01_ricerca_linked_ibrida_con_modello_di_re_ranking.typ": data as item_0, req-name as req-0

#{
item_0.fonti=utils.format-array(item_0.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-0
  ,
  item_0
  )



////#table-cells.push( item_0)
#import "RFO02_ricerca_ibrida_con_modello_di_re_ranking.typ": data as item_1, req-name as req-1

#{
item_1.fonti=utils.format-array(item_1.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-1
  ,
  item_1
  )



////#table-cells.push( item_1)


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