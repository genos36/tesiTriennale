#import "/template/mod.typ":slugify

#import "/template/general-macros/code-handler.typ": build-map-from-configuration

#let config = yaml("config/config.yaml")

#let req-format-settings = (
  padding: config.settings.formatting.padding,
  separator: config.settings.formatting.separator,
  prefix: config.settings.prefix,
  title-separator: config.settings.formatting.title_separator,
)

// Mappa costruita una sola volta a partire dalla struttura del config
#let req-mappa = build-map-from-configuration(config.structure)

#import "/template/general-macros/code-handler.typ":get-code-from-configuration,get-depth-from-configuration

#let get-req-code=get-code-from-configuration.with(mappa: req-mappa,format-settings: req-format-settings)

#let req-link(nome,extended:false,separator:none)={
  link(
    label(get-req-code(nome)),
    get-req-code(nome)+if extended{
      separator+nome
    } else {[]}

    )
}


#let req-link-extended=get-req-code.with(extended:true)