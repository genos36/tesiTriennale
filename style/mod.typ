#import "typography/typography.typ": apply-typography
#import "components/components.typ": apply-components

// Una singola funzione che applica tutti gli stili in un colpo solo
#let apply-styles(body) = {
  show: apply-typography
  show: apply-components
  body
}
