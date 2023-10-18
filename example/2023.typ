#import "../timetable.typ": timetable

#set page(margin: 0.5cm, height: auto)

#timetable(
  toml("2023.toml"),
  //language: "it",
  //date: [this year],
  //show-header: false,
  //show-alternatives: false,
  //show-description: false,
  //color-theme: "Set1_9",
)