#import "/template/requirements/use-case/template.typ": use-case
#import "/template/mod.typ":slugify

#import "/template/general-macros/code-handler.typ": build-map-from-configuration

#let config = yaml("/content/chapters/3_requirements/use-case/content/deps/config/config.yaml")

#let uc-format-settings = (
  padding: config.settings.formatting.padding,
  separator: config.settings.formatting.separator,
  prefix: config.settings.prefix,
  title-separator: config.settings.formatting.title_separator,
)

// Mappa costruita una sola volta a partire dalla struttura del config
#let uc-mappa = build-map-from-configuration(config.structure)

#import "/template/general-macros/code-handler.typ":get-code-from-configuration,get-depth-from-configuration

#let get-use-case-code=get-code-from-configuration.with(mappa:uc-mappa,format-settings: uc-format-settings)

#let uc-link(nome,extended:false,separator:none)={
  link(
    label(slugify(nome)),
    get-use-case-code(nome)+if extended{
      separator+nome
    } else {[]}

    )
}


#let uc-link-extended=uc-link.with(extended:true)