#import "@preview/tablex:0.0.5": tablex, rowspanx
#import "lib/helper.typ" as lib
#import "lib/default-blocks.typ"

#let timetable(
  all-data,
  language: "en",
  date: datetime.today().display("[day].[month].[year]"),
  show-header: true,
  show-alternatives: true,
  show-description: true,
  tablex-args: (:),
  event-cell: default-blocks.event-cell,
  time-cell: default-blocks.time-cell,
  color-theme: "tab",
) = {
  let lang-dict = if type(language) == str {
    lib.load-language(language)
  } else { language }

  let colors = if type(color-theme) == str {
    lib.load-color-theme(color-theme)
  } else { color-theme }

  let (times, courses, description, slots, alts) = lib.process-timetable-data(all-data, colors)
  
  let final-data = times.enumerate().map(
    time => (
      time-cell(time.at(1), lang-dict),
      lib.weekdays.enumerate().map(d => slots.at(d.at(0)).at(time.at(0))).map(ev =>
        if ev == none {
          []
        } else if ev.at("occupied", default: false) {
          ()
        } else {
          let cell = event-cell(
            ev,
            show-time: time.at(1).at("show-time", default: false),
            unique: ev.at("unique", default: true)
          )
          if ev.duration > 0 { rowspanx(ev.duration + 1, cell) } else { cell }
        }
      ).flatten()
    ).flatten()
  ).flatten()
  
  // Title
  if show-header {
    text(16pt, strong(lang-dict.title + " " + all-data.general.period))
    " " + lang-dict.of + " " + all-data.general.person
    if date != none {
      h(1fr)
      date
    }
  }

  // Main Timetable
  tablex(
    columns: (auto, 1fr, 1fr, 1fr, 1fr, 1fr),
    stroke: (
      paint: gray,
      thickness: 0.5pt,
      dash: "dashed"
    ),
    ..tablex-args,
    [], ..lang-dict.weekdays.map(day => align(center, day)),
    ..final-data,
  )

  show link: underline

  // Alternatives
  if show-alternatives and alts.len() > 0 {
    text(14pt, lang-dict.alternatives + ":")
    v(-12pt)
    table(
      columns: (1fr, 1fr, 1fr, 1fr, 1fr),
      column-gutter: 5pt,
      //stroke: gray + 0.5pt,
      stroke: none,
      ..alts.map(
        ev => event-cell(ev, show-time: true, show-day: true)
      )
    )
  }

  // Abbreviations
  if show-description {
    text(14pt, lang-dict.description + ":")
    v(-6pt)
    style(sty => {
      let h = measure([Hello], sty).height
      table(
        columns: description.len() + 2,
        stroke: (
          paint: gray,
          thickness: 0.5pt,
          dash: "dashed"
        ),
        ..tablex-args, // at the moment tablex does not span the whole width
        none, none, ..description.map(d => strong(d.title)),
        ..courses.filter(
          c => not c.at("hide-description", default: false)
        ).map(
          c => (
            rect(fill: c.color, width: h, height: h),
            strong(c.abbrv),
            ..description.map(
              d => (d.contentfn)(c.at(d.id, default: "")) // wraps content in link or other stuff
            )
          )
        ).flatten()
      )
    })
  }
}
