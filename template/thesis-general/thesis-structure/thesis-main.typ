#import "utils/utils.typ": make-counter, print-current-header
#let mainmatter(body, reset: true) = {
  set page(
    header: align(left, print-current-header()),
    footer: make-counter("1 / 1"),
  )
  if reset { counter(page).update(1) }
  body
}
