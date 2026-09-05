#import "/template/requirements/requirement/requirement-table.typ":req-table


#import "requisiti-obbligatori/content/req-list/requisiti-funzionali-obbligatori-list.typ": table-cells as obb
#import "requisiti-desiderabili/content/req-list/requisiti-funzionali-desiderabili-list.typ":table-cells as des
#import "requisiti-opzionali/content/req-list/requisiti-funzionali-opzionali-list.typ":table-cells as opz

#let func-req=obb+des+opz

#figure(caption:"Requisiti funzionali")[
#req-table(func-req)
]<tab:requisiti-funzionali>
// #figure(caption:"Requisiti funzionali obbligatori")[
// #req-table(obb)
// ]
// #figure(caption:"Requisiti funzionali desiderabili")[
// #req-table(des)

// ]
// #figure(caption:"Requisiti funzionali opzionali")[
// #req-table(opz)
// ]
// #obb


#let obb-len=obb.len()
#let des-len=des.len()
#let opz-len=opz.len()
