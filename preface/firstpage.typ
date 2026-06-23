#let logo = "/images/unipd-logo.svg"

#import "/metadata/mod.typ": data
//#import "../config/variables.typ": myAY, myDegree, myDepartment, myFaculty, myMatricola, myName, myProf, myTitle, myUni
//#import "../config/constants.typ": ID, academicYear, supervisor, undergraduate

#set page(numbering: none)

#grid(
  columns: auto,
  rows: (1fr, auto, 20pt),
  // Intestazione
  [
    #align(center, text(18pt, weight: "semibold", data.myUni))
    #v(1em)
    #align(center, text(14pt, weight: "light", smallcaps(data.myDepartment)))
    #v(1em)
    #align(center, text(12pt, weight: "light", smallcaps(data.myFaculty)))
  ],
  // Corpo
  [
    // Logo
    #align(center, image(logo, width: 50%))
    #v(30pt)

    // Titolo
    #align(center, text(18pt, hyphenate: false, weight: "semibold", data.myTitle))
    #v(10pt)
    #align(center, text(12pt, weight: "light", style: "italic", data.myDegree))
    #v(40pt)

    // Relatore e laureando
    #columns()[
      #align(left, text(12pt, weight: 400, style: "italic", data.supervisor))
      #v(5pt)
      #align(left, text(11pt, data.myProf))
      #colbreak()
      #align(right, text(12pt, weight: 400, style: "italic", data.undergraduate))
      #v(5pt)
      #align(right, text(11pt, data.myName))
      #v(5pt)
      #align(right, text(11pt, [_ #data.ID _ ] + data.myMatricola))
      #v(30pt)
    ]
  ],
  // Piè di pagina
  [
    // Anno accademico
    #line(length: 100%)
    #align(center, text(8pt, weight: 400, smallcaps(data.academicYear + " " + data.myAY)))
  ],
)
