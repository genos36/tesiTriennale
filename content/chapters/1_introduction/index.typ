#import "/plugin/mod.typ": gl, glpl
#import "/template/mod.typ": img
#import "/metadata/mod.typ": data

#let myTutor = data.myTutor
= Introduzione <cap:introduzione>
#text(style: "italic", [
  In questo capitolo descrivo l'azienda, introduco il progetto, e spiego le motivazioni che mi hanno portato a sceglierlo.
])
#v(1em)

== L'azienda
#data.myCompany è un'azienda parte del Gruppo Zucchetti, vanta un'esperienza ultratrentennale nello sviluppo di soluzioni software destinate sia ad aziende private che a istituzioni pubbliche. L'azienda si posiziona come partner tecnologico specializzato nella progettazione di piattaforme per la gestione e l'automazione dei processi aziendali e dei servizi di assistenza e supporto.
#img(
  "logo-azienda.svg",
  caption: [Logo #text(data.myCompany)],
  alt: "",
)<fig:logo>

== Il progetto

== Scelta del progetto
