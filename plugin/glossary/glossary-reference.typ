#import "/plugin/packages.typ": glossarium-lib
#import "glossary-style.typ": glossary-style

/// Wrapper per richiamare i termini al singolare
#let gl(
  key,
  suffix: none,
  long: false,
  display: none,
  link: true,
  update: true,
  capitalize: false,
) = glossary-style(
  glossarium-lib.gls(
    key,
    suffix: suffix,
    long: long,
    display: display,
    link: link,
    update: update,
    capitalize: capitalize,
  ),
)

/// Wrapper per richiamare i termini al plurale
#let glpl(
  key,
  long: false,
  link: true,
  update: true,
  capitalize: false,
) = glossary-style(
  glossarium-lib.glspl(
    key,
    capitalize: capitalize,
    link: link,
    long: long,
    update: update,
  ),
)
