// code-handler.typ
// Libreria per generare codici di nomenclatura (es. UC01.2_) a partire da
// una struttura ad albero. Nessuna dipendenza implicita: ogni funzione
// riceve mappa e impostazioni come parametri espliciti.

#import "/template/mod.typ": slugify

// --- Impostazioni di default -------------------------------------------
// Restano come default "di libreria", ma vengono sempre unite (+) a quelle
// passate dal chiamante, così il chiamante può sovrascrivere solo ciò che
// gli serve.
#let default-format-settings = (
  padding: 2,
  separator: ".",
  prefix: "UC",
  title-separator: "_",
)

// --- Costruzione mappa ---------------------------------------------------
// Trasforma una struttura ad albero (liste di stringhe / dizionari {nome: figli})
// in una mappa piatta: slug -> path (array di interi che indica la posizione
// nell'albero, es. (1, 2) = secondo figlio del primo capitolo).
#let build-map-from-configuration(items, parent-path: ()) = {
  let map = (:)
  if items == none { return map }
  for (i, item) in items.enumerate() {
    let count = i + 1
    let current-path = parent-path + (count,)
    let name = ""
    let children = none
    if type(item) == str {
      name = item
    } else if type(item) == dictionary {
      for (k, v) in item { name = k; children = v }
    }
    let key = lower(name).replace("_", "-").replace(" ", "-")
    map.insert(key, current-path)
    if children != none {
      map += build-map-from-configuration(children, parent-path: current-path)
    }
  }
  return map
}

// --- Formattazione di un path in stringa ---------------------------------
// Prende un array di interi, es. (1, 2), e lo trasforma in "UC01.2_"
// secondo format-settings. Non muta l'array in input.
#let format-code(code-array, format-settings: (:)) = {
  if code-array.len() == 0 { return "XX" }
  let settings = default-format-settings + format-settings

  let first = code-array.first()
  let rest = code-array.slice(1)

  let stringa = settings.prefix
  let zeri = calc.max(0, settings.padding - str(first).len())
  stringa += "0" * zeri + str(first) + "."

  for n in rest {
    stringa += str(n) + settings.separator
  }

  stringa = stringa.slice(0, -1) + settings.title-separator
  stringa
}

// --- API pubblica: nome leggibile -> codice ------------------------------
// mappa e format-settings sono ora parametri espliciti, non variabili globali.
#let get-code-from-configuration(nome-etichetta, mappa: (:), format-settings: (:)) = {
  let key = slugify(nome-etichetta)
  if key not in mappa {
    return "XX"
  }
  format-code(mappa.at(key), format-settings: format-settings).slice(0, -1)
}

// --- API pubblica: nome leggibile -> profondità nell'albero --------------
#let get-depth-from-configuration(nome-etichetta, mappa: (:)) = {
  let key = slugify(nome-etichetta)
  if key in mappa {
    mappa.at(key).len()
  } else {
    0
  }
}
