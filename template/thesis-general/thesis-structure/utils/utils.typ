

#let make-counter(format) = {
  // Se non c'è formato, non stampiamo nulla
  if format == none { return none }

  context {
    let current-page = counter(page).get().first()
    let total-pages = counter(page).final().first()

    // Se il formato è una stringa e contiene "di" o "/",
    // passiamo entrambi i numeri a Typst (corrente e totale).
    if type(format) == str and (format.contains("di") or format.contains("/")) {
      numbering(format, current-page, total-pages)
    } // Altrimenti passiamo solo la pagina corrente (es. per "i", "A", o "Pagina 1")
    else {
      numbering(format, current-page)
    }
  }
}



#let get-current-title(outlined-only: true) = {
  let current-page = here().page()

  // Costruiamo il selettore in base al parametro!
  let target = if outlined-only {
    heading.where(level: 1, outlined: true)
  } else {
    heading.where(level: 1)
  }

  let all-headings = query(selector(target))
  let active-headings = all-headings.filter(h => h.location().page() <= current-page)

  if active-headings.len() > 0 {
    return active-headings.last()
  }

  return none
}
#let print-current-header() = context {
  let current-chapter = get-current-title()

  if current-chapter != none {
    // Estraiamo il numero risolvendo il contatore in quella posizione
    let chapter-number = if current-chapter.numbering != none {
      numbering(
        current-chapter.numbering,
        ..counter(heading).at(current-chapter.location()),
      )
    }

    // Stampiamo a schermo il risultato (es: "1 Introduzione")
    [
      #if chapter-number != none [#chapter-number ]
      #current-chapter.body
    ]
  }
}
