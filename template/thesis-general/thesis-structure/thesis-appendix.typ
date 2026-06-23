#import "utils/utils.typ": make-counter, print-current-header
#let appendixmatter(body, reset: true) = {
  set page(
    numbering: "1",
    header: none,
    footer: make-counter("1 / 1"),
  )
  if reset { counter(page).update(1) }

  body
}
