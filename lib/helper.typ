#let weekdays = ("Mon", "Tue", "Wed", "Thu", "Fri")

#let load-language(lang, language-file: "languages.toml") = {
  let language-dict = toml(language-file)
  if lang in language-dict {
    language-dict.at(lang)
  } else {
    panic("Unfortunately, `" + lang + "` does not exist in `" + language-file + "`.")
  }
}

#let load-color-theme(theme-name, themes-file: "colorthemes.toml") = {
  let theme-dict = toml(themes-file)
  if theme-name in theme-dict {
    theme-dict.at(theme-name).map(c => color.rgb(c.at(0), c.at(1), c.at(2)))
  } else {
    panic("Color Theme `" + theme-name + "` does not exist. Alternatives are: {" + theme-dict.keys().join(", ") + "}")
  }
}

#let description-parser(data) = if "description" in data {
  data.description.map(d => {
    if "title" not in d { d.insert("title", upper(d.id)) }
    let dtype = d.at("type", default: "text")
    if dtype == "link" {
      d.contentfn = x => if x == "" { x } else { link(x, "link") }
    } else if dtype == "content" {
      d.contentfn = x => eval(x, mode: "markup")
    } else {
      d.contentfn = x => x
    }
    d
  })
} else { () }

#let courses-parser(data, colors) = {
  let colors = colors.rev()
  let courses = ()

  for (cabbrv, cvalues) in data.courses.pairs() {
    if cvalues.at("hide", default: false) {
      continue
    }
    if "color" in cvalues {
      cvalues.color = eval(cvalues.color)
    } else {
      cvalues.color = colors.pop()
    }
    cvalues.abbrv = cabbrv // handle abbreviation and name differently
    cvalues.priority = cvalues.at("priority", default: 0)
    courses.push(cvalues)
  }

  courses
}

#let process-timetable-data(data, colors) = {
  let time-overlap(ev, time) = time.start <= ev.start and ev.start < time.end or time.start < ev.end and ev.end <= time.end or ev.start < time.start and time.end < ev.end

  let defaults = data.at("defaults", default: (:))
  let default-duration = defaults.at("duration", default: 2)

  let slots = weekdays.map(_ => data.general.times.map(_ => none))
  let alts  = ()
  let times = data.general.times.map(
    time => (
      ..time,
      start: if "start" in time { time.start } else { time.end - default-duration },
      end: if "end" in time { time.end } else { time.start + default-duration }
    )
  )
  
  let courses = courses-parser(data, colors)

  for (i, day) in weekdays.enumerate() {
    let day-evs = courses.map(
      course => course.at("events", default: (:)).pairs().map(
        evtype => evtype.at(1).filter(
          ev => not ev.at("hide", default: false) and ev.day == day
        ).map(k => (
          ..course, // get all properties from the course
          ..k,      // get all properties from the event, included later hence can overwrite course properties (e.g. for priority)
          kind: evtype.at(0),
          // change if absent with special values
          start: if "start" in k { k.start } else { k.end - default-duration },
          end: if "end" in k { k.end } else { k.start + default-duration }
        )).flatten()
      ).flatten()
    ).flatten().sorted(key: ev => ev.priority).rev()
    
    for ev in day-evs {
      for (j, time) in times.enumerate() {
        if time-overlap(ev, time) {
          if slots.at(i).at(j) == none {
            // also check the duration
            let duration = times.slice(j + 1).enumerate()
              .find(x => not time-overlap(ev, x.at(1)))
            let duration = if duration == none { 0 } else { duration.at(0) }
            ev.insert("duration", duration)
            
            slots.at(i).at(j) = ev
            if duration > 0 {
              for k in range(duration) {
                slots.at(i).at(j + k + 1) = ("occupied": true) // notify that this spot is already occupied
              }
            }
            break
          } else {
            alts.push(ev)
            slots.at(i).at(j).insert("unique", false)
          }
        }
      }
    }
  }

  let description = description-parser(data)

  (times, courses, description, slots, alts)
}