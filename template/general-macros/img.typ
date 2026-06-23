#let path = "/images/"

#let img(name, caption: none, width: auto, height: auto, alt: none, path: path) = {
  let full = path + name

  figure(
    image(full, width: width, height: height, alt: alt),
    caption: caption,
  )
}
