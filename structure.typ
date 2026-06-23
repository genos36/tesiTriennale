#import "/template/mod.typ": appendixmatter, frontmatter, mainmatter
// #import "template/mod.typ": thesis-setup


#include "preface/firstpage.typ"
#include "preface/copyright.typ"



#frontmatter()[
  #include "preface/dedication.typ"
  #include "preface/acknowledgements.typ"
  #include "preface/summary.typ"
  #include "preface/table-of-contents.typ"

]

#mainmatter()[
  #include "content/chapters/index.typ"
]

#appendixmatter(reset: false)[
  #include "content/appendix/glossary/glossary.typ"
  #include "content/appendix/bibliography/bibliography.typ"
]
