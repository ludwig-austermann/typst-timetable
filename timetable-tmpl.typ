#let display_time(time) = {
  let hour = int(time)
  let minute = 60 * (time - hour)
  if hour < 10 { [0] }
  str(hour)
  [:]
  if minute < 10 { [0] }
  str(minute)
}

#let weekdays = ("Mon", "Tue", "Wed", "Thu", "Fri")

#let timetable(all_data, language: "EN", date: none) = {
  set page(margin: 0.5cm, height: auto)
  //#set page(paper: "a6", flipped: true)
  //#set page(paper: "a5", flipped: true)
  //#set page(width: 11cm, height: 7.5cm, margin: 0.1cm)

  let lang_dict = if language == "DE" {(
    weekdays: ("MO", "DI", "MI", "DO", "FR"),
    title: "Stundenplan",
    from: "von",
    to: "bis",
    of: "von",
    alternatives: "Alternativen",
  )} else {(
    weekdays: ("Mon", "Tue", "Wed", "Thu", "Fri"),
    title: "Timetable",
    from: "from",
    to: "to",
    of: "of",
    alternatives: "Alternatives"
  )}

  let event_cell(event, show_time: false, show_day: false, unique: true) = {
    box(stroke: (left: event.color + 3pt), inset: (left: 5pt, y: 2pt), {
      strong(event.name)
      h(1fr)
      event.kind
      linebreak()
      set text(9pt)
      event.room
      if not unique {
        h(1fr)
        emoji.warning
      }
      if show_time {
        linebreak()
        if show_day { event.day + ": "}
        display_time(event.start)
        [ -- ]
        display_time(event.end)
      }
    })
  }

  let time_cell(time) = align(horizon + right, {
    if time.keys().contains("display") {
      time.display
    } else {
      lang_dict.from + " "
      display_time(time.start)
      linebreak()
      lang_dict.to + " "
      display_time(time.end)
    }
  })

  let data_per_day = weekdays.map(
    day => all_data.courses.pairs().map(
      course => course.at(1).events.pairs().map(
        evtype => evtype.at(1).filter(
          ev => if ev.keys().contains("hidden") { not ev.hidden } else { true } and ev.day == day
        ).map(k => (
          name: course.at(0),
          color: eval(course.at(1).color),
          kind: evtype.at(0),
          ..k
        )).flatten()
      ).flatten()
    ).flatten()
  )

  let datas = all_data.general.times.map(
    time => {
      let show_time = if time.keys().contains("show_time") { time.show_time } else { false }
      data_per_day.map(
        daydata => {
          let events = daydata.filter(
            ev => time.start <= ev.start and ev.start < time.end or time.start < ev.end and ev.end <= time.end or ev.start < time.start and time.end < ev.end
          )
          if events.len() == 1 {
            (
              event_cell(events.first(), show_time: show_time),
              events.slice(1)
            )
          } else if events.len() > 1 {
            (
              event_cell(events.first(), show_time: show_time, unique: false),
              events.slice(1)
            )
          } else { ([], ()) }
        }
      )
    }
  )//.flatten()

  let final_datas = all_data.general.times.enumerate().map(
    time => (
      time_cell(time.at(1)),
      ..datas.at(time.at(0)).map(k => k.at(0))
    )
  ).flatten()

  text(16pt, strong(lang_dict.title + " " + all_data.general.period))
  " " + lang_dict.of + " " + all_data.general.person
  if date != none {
    h(1fr)
    date
  }

  table(
    columns: (auto, 1fr, 1fr, 1fr, 1fr, 1fr),
    stroke: gray + 0.5pt,
    [], ..lang_dict.weekdays.map(day => align(center, day)),
    ..final_datas,
  )
  lang_dict.alternatives + ":"
  v(-12pt)
  table(columns: (1fr, 1fr, 1fr, 1fr, 1fr),
    //stroke: gray + 0.5pt,
    stroke: none,
    ..datas.map(
      time => time.map(
        tuple => tuple.at(1)
      ).filter(k => k.len() > 0).flatten()
    ).flatten().map(
      ev => event_cell(ev, show_time: true, show_day: true)
    )
  )
}
