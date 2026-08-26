#import "/template/requirements/requirement/requirement-table.typ":req-table


#import "requisiti-obbligatori/content/req-list/requisiti-vincolo-obbligatori-list.typ": table-cells as obb
#import "requisiti-desiderabili/content/req-list/requisiti-vincolo-desiderabili-list.typ":table-cells as des
#import "requisiti-opzionali/content/req-list/requisiti-vincolo-opzionali-list.typ":table-cells as opz

#let constr-req=obb+des+opz

#figure(caption:"Requisiti di vincolo")[
#req-table(constr-req, columns: (auto,2fr,1fr))
]<tab:requisiti-vincolo>