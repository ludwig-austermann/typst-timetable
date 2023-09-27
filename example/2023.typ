#import "../timetable.typ": timetable

#set page(margin: 0.5cm, height: auto)

#timetable(
  toml("2023.toml"),
  language: "it",
  //show-header: false,
  //show-alternatives: false,
  tablex-args: (stroke: (
      paint: green.darken(50%),
      thickness: 0.2pt,
      dash: "dashed"
    )),
)