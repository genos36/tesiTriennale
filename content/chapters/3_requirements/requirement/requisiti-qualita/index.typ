#import "/template/requirements/requirement/requirement-table.typ":req-table
#import "requisiti-obbligatori/content/req-list/requisiti-qualita-obbligatori-list.typ": table-cells as obb
#import "requisiti-desiderabili/content/req-list/requisiti-qualita-desiderabili-list.typ": table-cells as des
#import "requisiti-opzionali/content/req-list/requisiti-qualita-opzionali-list.typ":table-cells as opz



#let qual-req=obb+des+opz

#figure(caption:"Requisiti di qualità")[
#req-table(qual-req, columns: (auto,2fr,1fr))
]<tab:requisiti-qualità>