#import "template/mod.typ": thesis-setup
#import "metadata/mod.typ": data
#import "/flags.typ": debug
#import "/plugin/mod.typ": glossary-init
#import "/content/appendix/glossary/terms.typ": glossary-terms

#show: glossary-init.with(terms: glossary-terms)
#show: thesis-setup.with(debug: true)


#include "structure.typ"
