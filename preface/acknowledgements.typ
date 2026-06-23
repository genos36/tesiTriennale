#import "/metadata/mod.typ": data


#pagebreak(to: "odd")
#v(10em)
#text(24pt, weight: "semibold", data.acknlowledgements)
#v(3em)
#text(style: "italic")[
  Innanzitutto, vorrei esprimere la mia gratitudine al Prof. #data.myProf relatore della mia tesi, per l'aiuto e il continuo sostegno fornitomi durante la stesura del lavoro.\
  Desidero ringraziare con affetto i miei genitori e i miei parenti per il sostegno e per essermi stati vicini durante gli anni di studio.\
  Ho desiderio di ringraziare poi i miei amici per tutti i bellissimi anni passati insieme.\
  Ci tengo infine a ringraziare i colleghi di #data.myCompany e il tutor aziendale #data.myTutor per avermi dato l'opportunità di lavorare a questo progetto.
]
#v(2em)
#text(style: "italic", data.myLocation + ", " + data.myTime + h(1fr) + data.myName)
