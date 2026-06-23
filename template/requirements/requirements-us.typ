#let requiremnts-us-title(
  title,
  level: 4,
) = {
  // Questo 'set' ha effetto solo ed esclusivamente qui dentro
  set heading(
    numbering: (..numbers) => numbering("US1", numbers.pos().last()),
    supplement: none,
  )

  // Generiamo il titolo
  heading(level: level, title)
}
