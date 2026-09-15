#let slugify(text) = {
  lower(text.trim()).replace(" ", "-")
}

#let snakify(text) = {
  lower(text.trim()).replace(" ", "_")
}
