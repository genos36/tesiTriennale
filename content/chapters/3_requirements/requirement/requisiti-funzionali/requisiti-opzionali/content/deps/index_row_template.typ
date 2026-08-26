#import "{{FILE_PATH}}": data as item_{{INDEX}}, req-name as req-{{INDEX}}

#{
item_{{INDEX}}.fonti=utils.format-array(item_{{INDEX}}.fonti,transf:utils.uc-link)


}
#table-cells.insert(
  req-{{INDEX}}
  ,
  item_{{INDEX}}
  )



////#table-cells.push( item_{{INDEX}})