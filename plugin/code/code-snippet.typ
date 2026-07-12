// plugin/code.typ

#import "@preview/codly:1.3.0": codly, codly-init
#import "@preview/codly-languages:0.1.10": codly-languages


#let code-snippet(caption: none, source, block-set: true) = {
  show raw: set text(size: 0.85em)
  set raw(block: block-set)
  figure(
    kind: raw,
    caption: caption,

    // Permettiamo al blocco di codice di spezzarsi su più pagine,
    // ma essendo dentro una figure nativa Typst gestirà meglio la didascalia

    block(breakable: true, width: 100%, source),
  )
}
