#import "/plugin/packages.typ": glossarium-lib
#import "/flags.typ": glossary-show-all

#let glossary-print = glossarium-lib.print-glossary.with(
  show-all: glossary-show-all,
)
