#import "/metadata/mod.typ": data
#import "utils/utils.typ": make-counter

#let frontmatter(body, reset: true, clear-double-page: "odd") = {
  set page(
    header: none,
    footer: align(center, make-counter("i")),
  )
  if reset { counter(page).update(1) }

  body

  if clear-double-page != none and clear-double-page != false {
    pagebreak(to: clear-double-page)
  }
}
