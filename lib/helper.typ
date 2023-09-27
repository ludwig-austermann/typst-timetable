#let weekdays = ("Mon", "Tue", "Wed", "Thu", "Fri")

#let load-language(lang, language-file: "languages.toml") = {
  let language-dict = toml(language-file)
  if lang in language-dict {
    language-dict.at(lang)
  } else {
    panic("Unfortunately, `" + lang + "` does not exist in `" + language-file + "`.")
  }
}

#let process-timetable-data(data) = {
  let time-overlap(ev, time) = time.start <= ev.start and ev.start < time.end or time.start < ev.end and ev.end <= time.end or ev.start < time.start and time.end < ev.end

  let slots = weekdays.map(_ => data.general.times.map(_ => none))
  let alts  = ()

  for (i, day) in weekdays.enumerate() {
    let day-evs = data.courses.pairs().map(
      course => course.at(1).events.pairs().map(
        evtype => evtype.at(1).filter(
          ev => if "hidden" in ev { not ev.hidden } else { true } and ev.day == day
        ).map(k => (
          name: course.at(0),
          color: eval(course.at(1).color),
          kind: evtype.at(0),
          priority: course.at(1).at("priority", default: 0),
          ..k
        )).flatten()
      ).flatten()
    ).flatten().sorted(key: ev => ev.priority).rev()
    
    for ev in day-evs {
      for (j, time) in data.general.times.enumerate() {
        if time-overlap(ev, time) {
          if slots.at(i).at(j) == none {
            // also check the duration
            let duration = data
              .general.times.slice(j + 1).enumerate()
              .find(x => not time-overlap(ev, x.at(1)))
            let duration = if duration == none { 0 } else { duration.at(0) }
            ev.insert("duration", duration)
            
            slots.at(i).at(j) = ev
            if duration > 0 {
              for k in range(duration) {
                slots.at(i).at(j + k + 1) = -1 // notify that this spot is already occupied
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

  (slots, alts)
}