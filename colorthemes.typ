#let colorthemes = toml("lib/colorthemes.toml").pairs().map(
  theme => (
    theme.at(0),
    theme.at(1).map(c => box(height: 20pt, width: 20pt, fill: color.rgb(c.at(0), c.at(1), c.at(2))))
  )
)
#let max-size = colorthemes.fold(
  0,
  (acc, x) => calc.max(
    acc,
    x.at(1).len()
  )
)

= Color themes / palette in this package
Taken from `ColorSchemes.jl` package with can be found here: #link("https://github.com/JuliaGraphics/ColorSchemes.jl")

#table(
  columns: max-size + 1,
  inset: 1pt,
  row-gutter: 9pt,
  stroke: none,
  align: horizon,
  none, ..range(1, max-size + 1).map(x => align(center, str(x))),
  ..colorthemes.map(
    x => {
      let l = x.at(1).len()
      if l < max-size {
        (raw(x.at(0)), ..(x.at(1) + (none,) * (max-size - l)))
      } else {
        (raw(x.at(0)), ..x.at(1))
      }
    }
  ).flatten()
)