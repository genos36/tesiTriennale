#import "code-set-up.typ":get-req-code, slugify, req-link, req-link-extended

#import "/content/chapters/3_requirements/use-case/content/deps/utils/code-set-up.typ":uc-link



#import "/flags.typ":debug


#import "/template/requirements/use-case/use-case-diagram/draw-uc-expansion.typ":draw-uc-expansion
#import "/template/requirements/use-case/use-case-diagram/draw-uc-diagram.typ":draw-uc-diagram

#let format-array(fonti,transf:function)={



  return fonti.map(it=>{
    transf(..it)
  }).join(",")
}