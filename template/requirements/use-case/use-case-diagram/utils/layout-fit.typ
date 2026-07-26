// ==========================================
// FIT-TO-WIDTH: adatta un contenuto alla larghezza disponibile
// ==========================================
// Stessa logica di `width: 100%` per le immagini: il contenuto viene
// misurato e poi scalato uniformemente per riempire esattamente la
// larghezza richiesta (relativa al contenitore, es. 100%, 80%, ...,
// oppure assoluta, es. 15cm). Non fa saltare pagina: se serve anche un
// limite verticale (utile quando il contenitore ha un'altezza massima,
// es. dentro una colonna o prima di un'interruzione di pagina) si può
// passare max-height, che riduce ulteriormente la scala (mai aumentarla)
// per rispettare anche quel limite.
#let fit-to-width(body, width: 100%, max-height: none) = {
  layout(container-size => {
    context {
      let natural = measure(body)

      let target-width = if type(width) == ratio {
        container-size.width * width
      } else {
        width
      }

      let w-scale = target-width / natural.width

      let final-scale = if max-height == none {
        w-scale
      } else {
        let target-height = if type(max-height) == ratio {
          container-size.height * max-height
        } else {
          max-height
        }
        calc.min(w-scale, target-height / natural.height)
      }

      scale(final-scale * 100%, reflow: true, body)
    }
  })
}
