#import "risc-table.typ": risc-table

#let pad-number(padding: int, num: int) = {
  let s = str(num)

  return "0" * (calc.max(padding - s.len(), 0)) + s
}

#let risc-list(
  risc-prefix: str,
  heading-level: 3,
  items,
) = {
items=items.map(it=>{
                if it.at("r-label",default: none)==none{
                        it.r-label=none
                        return it
                }
                else {
                        return it
                }
        })

let counter = 1
  for it in items {
    // [#heading(it.name, depth: heading-level)  #label(risc-prefix + pad-number(padding: 2, num: counter))]

      risc-table(
        code: risc-prefix + pad-number(padding: 2, num: counter),
        name: it.name,
        description: it.description,
        mitigation: it.mitigation,
        probability: it.probability,
        consequences: it.consequences,
        r-label:it.r-label
      )

    counter = counter + 1
  }
}
