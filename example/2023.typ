#import "../timetable.typ": timetable

#set page(margin: 0.5cm, height: auto)

#timetable(
  toml("2023.toml"),
  //language: "it",
  //show-header: false,
  //show-alternatives: false,
)