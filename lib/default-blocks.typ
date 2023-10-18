#let display-time(time) = {
  let hour = int(time)
  let minute = 60 * (time - hour)
  if hour < 10 { [0] }
  str(hour)
  [:]
  if minute < 10 { [0] }
  str(minute)
}

#let event-cell(event, show-time: false, show-day: false, unique: true) = {
  box(stroke: (left: event.color + 3pt), inset: (left: 5pt, y: 2pt), {
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

#let time-cell(time, lang-dict) = align(horizon + right, {
  if time.keys().contains("display") {
    time.display
  } else {
    lang-dict.from + " "
    display-time(time.start)
    linebreak()
    lang-dict.to + " "
    display-time(time.end)
  }
})