#import "/metadata/mod.typ": data
#import "utils/utils.typ": make-counter

#let frontmatter(body, reset: true) = {
  set page(
    header: none,
    footer: align(center, make-counter("i")),
  )
  if reset { counter(page).update(1) }
  body
}
