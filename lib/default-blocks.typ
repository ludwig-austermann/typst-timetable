#let display-time(time) = if time.day() == 2 {
  "24:00"
} else {
  time.display("[hour]:[minute]")
}

// taken from qcm: Set3_12
#let default-color-theme = (
  rgb("#8dd3c7"),
  rgb("#ffffb3"),
  rgb("#bebada"),
  rgb("#fb8072"),
  rgb("#80b1d3"),
  rgb("#fdb462"),
  rgb("#b3de69"),
  rgb("#fccde5"),
  rgb("#d9d9d9"),
  rgb("#bc80bd"),
  rgb("#ccebc5"),
  rgb("#ffed6f"),
)

#let event-cell(event, show-time: false, show-day: false, unique: true) = {
  box(stroke: (left: event.color + 4pt), inset: (left: 5pt, y: 2pt), {
    strong(event.abbrv)
    h(1fr)
    event.kind
    linebreak()
    set text(9pt)
    event.room
    if not unique {
      h(1fr)
      emoji.warning
    }
    if show-time {
      linebreak()
      if show-day { event.day + ": "}
      display-time(event.start)
      [ -- ]
      display-time(event.end)
    }
  })
}

#let time-cell(time, lang-dict) = align(horizon + right,
  time.at("display", default: {
    lang-dict.from + " "
    display-time(time.start)
    linebreak()
    lang-dict.to + " "
    display-time(time.end)
  })
)
