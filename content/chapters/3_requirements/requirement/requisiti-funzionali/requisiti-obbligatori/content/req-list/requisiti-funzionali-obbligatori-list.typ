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

#import "RFM01_ingestion_di_documenti.typ": data as item_0, req-name as req-0

#{
item_0.fonti=utils.format-array(item_0.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-0
  ,
  item_0
  )



////#table-cells.push( item_0)
#import "RFM02_avvia_ingestion.typ": data as item_1, req-name as req-1

#{
item_1.fonti=utils.format-array(item_1.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-1
  ,
  item_1
  )



////#table-cells.push( item_1)
#import "RFM03_ingestion_liste_entità.typ": data as item_2, req-name as req-2

#{
item_2.fonti=utils.format-array(item_2.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-2
  ,
  item_2
  )



////#table-cells.push( item_2)
#import "RFM04_ingestion_lista_entità.typ": data as item_3, req-name as req-3

#{
item_3.fonti=utils.format-array(item_3.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-3
  ,
  item_3
  )



////#table-cells.push( item_3)
#import "RFM05_caricamento_blocco_entità.typ": data as item_4, req-name as req-4

#{
item_4.fonti=utils.format-array(item_4.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-4
  ,
  item_4
  )



////#table-cells.push( item_4)
#import "RFM06_ingestione_lista_ticket.typ": data as item_5, req-name as req-5

#{
item_5.fonti=utils.format-array(item_5.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-5
  ,
  item_5
  )



////#table-cells.push( item_5)
#import "RFM07_ingestione_lista_conversation_item.typ": data as item_6, req-name as req-6

#{
item_6.fonti=utils.format-array(item_6.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-6
  ,
  item_6
  )



////#table-cells.push( item_6)
#import "RFM08_ingestione_lista_attachments.typ": data as item_7, req-name as req-7

#{
item_7.fonti=utils.format-array(item_7.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-7
  ,
  item_7
  )



////#table-cells.push( item_7)
#import "RFM09_termina_ingestion.typ": data as item_8, req-name as req-8

#{
item_8.fonti=utils.format-array(item_8.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-8
  ,
  item_8
  )



////#table-cells.push( item_8)
#import "RFM10_errore_termine_ingestion.typ": data as item_9, req-name as req-9

#{
item_9.fonti=utils.format-array(item_9.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-9
  ,
  item_9
  )



////#table-cells.push( item_9)
#import "RFM11_fallimento_ingestion.typ": data as item_10, req-name as req-10

#{
item_10.fonti=utils.format-array(item_10.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-10
  ,
  item_10
  )



////#table-cells.push( item_10)
#import "RFM12_ricerca_su_singola_entità.typ": data as item_11, req-name as req-11

#{
item_11.fonti=utils.format-array(item_11.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-11
  ,
  item_11
  )



////#table-cells.push( item_11)
#import "RFM13_inserimento_query_su_singola_entità.typ": data as item_12, req-name as req-12

#{
item_12.fonti=utils.format-array(item_12.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-12
  ,
  item_12
  )



////#table-cells.push( item_12)
#import "RFM14_ricezione_risultati_ricerca_singola_entità.typ": data as item_13, req-name as req-13

#{
item_13.fonti=utils.format-array(item_13.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-13
  ,
  item_13
  )



////#table-cells.push( item_13)
#import "RFM15_ricerca_full_text.typ": data as item_14, req-name as req-14

#{
item_14.fonti=utils.format-array(item_14.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-14
  ,
  item_14
  )



////#table-cells.push( item_14)
#import "RFM16_ricerca_semantica.typ": data as item_15, req-name as req-15

#{
item_15.fonti=utils.format-array(item_15.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-15
  ,
  item_15
  )



////#table-cells.push( item_15)
#import "RFM17_ricerca_ibrida.typ": data as item_16, req-name as req-16

#{
item_16.fonti=utils.format-array(item_16.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-16
  ,
  item_16
  )



////#table-cells.push( item_16)
#import "RFM18_aggiunta_pesi_di_fusione_ricerca_singola_entità.typ": data as item_17, req-name as req-17

#{
item_17.fonti=utils.format-array(item_17.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-17
  ,
  item_17
  )



////#table-cells.push( item_17)
#import "RFM19_ricerca_ibrida_con_rrf.typ": data as item_18, req-name as req-18

#{
item_18.fonti=utils.format-array(item_18.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-18
  ,
  item_18
  )



////#table-cells.push( item_18)
#import "RFM20_inserimento_query_su_singola_entità_non_valida.typ": data as item_19, req-name as req-19

#{
item_19.fonti=utils.format-array(item_19.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-19
  ,
  item_19
  )



////#table-cells.push( item_19)
#import "RFM21_errore_ricerca_su_singola_entità.typ": data as item_20, req-name as req-20

#{
item_20.fonti=utils.format-array(item_20.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-20
  ,
  item_20
  )



////#table-cells.push( item_20)
#import "RFM22_ricerca_linked.typ": data as item_21, req-name as req-21

#{
item_21.fonti=utils.format-array(item_21.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-21
  ,
  item_21
  )



////#table-cells.push( item_21)
#import "RFM23_inserimento_query_linked.typ": data as item_22, req-name as req-22

#{
item_22.fonti=utils.format-array(item_22.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-22
  ,
  item_22
  )



////#table-cells.push( item_22)
#import "RFM24_ricezione_risultati_ricerca_linked.typ": data as item_23, req-name as req-23

#{
item_23.fonti=utils.format-array(item_23.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-23
  ,
  item_23
  )



////#table-cells.push( item_23)
#import "RFM25_ricerca_linked_full_text.typ": data as item_24, req-name as req-24

#{
item_24.fonti=utils.format-array(item_24.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-24
  ,
  item_24
  )



////#table-cells.push( item_24)
#import "RFM26_ricerca_linked_semantica.typ": data as item_25, req-name as req-25

#{
item_25.fonti=utils.format-array(item_25.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-25
  ,
  item_25
  )



////#table-cells.push( item_25)
#import "RFM27_ricerca_linked_ibrida.typ": data as item_26, req-name as req-26

#{
item_26.fonti=utils.format-array(item_26.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-26
  ,
  item_26
  )



////#table-cells.push( item_26)
#import "RFM28_aggiunta_pesi_di_fusione_ricerca_linked.typ": data as item_27, req-name as req-27

#{
item_27.fonti=utils.format-array(item_27.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-27
  ,
  item_27
  )



////#table-cells.push( item_27)
#import "RFM29_ricerca_linked_ibrida_con_rrf.typ": data as item_28, req-name as req-28

#{
item_28.fonti=utils.format-array(item_28.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-28
  ,
  item_28
  )



////#table-cells.push( item_28)
#import "RFM30_inserimento_query_linked_non_valida.typ": data as item_29, req-name as req-29

#{
item_29.fonti=utils.format-array(item_29.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-29
  ,
  item_29
  )



////#table-cells.push( item_29)
#import "RFM31_errore_ricerca_linked.typ": data as item_30, req-name as req-30

#{
item_30.fonti=utils.format-array(item_30.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-30
  ,
  item_30
  )



////#table-cells.push( item_30)
#import "RFM32_avvia_test.typ": data as item_31, req-name as req-31

#{
item_31.fonti=utils.format-array(item_31.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-31
  ,
  item_31
  )



////#table-cells.push( item_31)
#import "RFM33_visualizza_dashboard_performance.typ": data as item_32, req-name as req-32

#{
item_32.fonti=utils.format-array(item_32.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-32
  ,
  item_32
  )



////#table-cells.push( item_32)
#import "RFM34_visualizza_id_run_test.typ": data as item_33, req-name as req-33

#{
item_33.fonti=utils.format-array(item_33.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-33
  ,
  item_33
  )



////#table-cells.push( item_33)
#import "RFM35_visualizza_metriche_di_performance.typ": data as item_34, req-name as req-34

#{
item_34.fonti=utils.format-array(item_34.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-34
  ,
  item_34
  )



////#table-cells.push( item_34)
#import "RFM36_visualizzazione_retrieval_latency.typ": data as item_35, req-name as req-35

#{
item_35.fonti=utils.format-array(item_35.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-35
  ,
  item_35
  )



////#table-cells.push( item_35)
#import "RFM37_visualizzazione_retrieval_latency_con_ingestion_attiva.typ": data as item_36, req-name as req-36

#{
item_36.fonti=utils.format-array(item_36.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-36
  ,
  item_36
  )



////#table-cells.push( item_36)
#import "RFM38_visualizzazione_retrieval_latency_con_ingestion_non_attiva.typ": data as item_37, req-name as req-37

#{
item_37.fonti=utils.format-array(item_37.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-37
  ,
  item_37
  )



////#table-cells.push( item_37)
#import "RFM39_visualizzazione_retrieval_answer_rate.typ": data as item_38, req-name as req-38

#{
item_38.fonti=utils.format-array(item_38.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-38
  ,
  item_38
  )



////#table-cells.push( item_38)
#import "RFM40_visualizzazione_retrieval_mrr.typ": data as item_39, req-name as req-39

#{
item_39.fonti=utils.format-array(item_39.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-39
  ,
  item_39
  )



////#table-cells.push( item_39)
#import "RFM41_visualizzazione_retrieval_hitrate@1.typ": data as item_40, req-name as req-40

#{
item_40.fonti=utils.format-array(item_40.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-40
  ,
  item_40
  )



////#table-cells.push( item_40)
#import "RFM42_visualizzazione_retrieval_hitrate@5.typ": data as item_41, req-name as req-41

#{
item_41.fonti=utils.format-array(item_41.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-41
  ,
  item_41
  )



////#table-cells.push( item_41)
#import "RFM43_visualizzazione_retrieval_hitrate@10.typ": data as item_42, req-name as req-42

#{
item_42.fonti=utils.format-array(item_42.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-42
  ,
  item_42
  )



////#table-cells.push( item_42)
#import "RFM44_visualizzazione_retrieval_wins.typ": data as item_43, req-name as req-43

#{
item_43.fonti=utils.format-array(item_43.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-43
  ,
  item_43
  )



////#table-cells.push( item_43)
#import "RFM45_visualizzazione_not_found.typ": data as item_44, req-name as req-44

#{
item_44.fonti=utils.format-array(item_44.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-44
  ,
  item_44
  )



////#table-cells.push( item_44)
#import "RFM46_visualizza_dashboard_performance_test_in_corso.typ": data as item_45, req-name as req-45

#{
item_45.fonti=utils.format-array(item_45.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-45
  ,
  item_45
  )



////#table-cells.push( item_45)
#import "RFM47_visualizza_dashboard_performance_test_terminato.typ": data as item_46, req-name as req-46

#{
item_46.fonti=utils.format-array(item_46.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-46
  ,
  item_46
  )



////#table-cells.push( item_46)
#import "RFM48_nessuna_run_di_test_trovata.typ": data as item_47, req-name as req-47

#{
item_47.fonti=utils.format-array(item_47.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-47
  ,
  item_47
  )



////#table-cells.push( item_47)


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