#import "/metadata/mod.typ": data
#import "/plugin/mod.typ": glossary-print
#import "terms.typ": glossary-terms
#heading(numbering: none, data.glossary) <glossary>
/* I termini sono ordinati in ordine alfabetico su `key`.
 * Tutti i termini che iniziano con la lettera maiuscola saranno mostrati per primi (B > a), per questo consiglio di mettere tutte le key in minuscolo.
 * Se vuoi modificare il modo in cui vengono ordinati i termini vedi https://github.com/typst-community/glossarium/issues/107#issuecomment-2692722556
 */
#[
  // #show figure: it => {
  //   v(-1em)
  //   it
  //   v(-1em)
  // }


  #glossary-print(
    glossary-terms,
    deduplicate-back-references: true,
  )

]
