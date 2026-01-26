#import "../timetable.typ": timetable
#import "@local/qcm:0.1.0": colormap

#set page(margin: 0.5cm, height: auto)

#timetable(
  toml("data/2023.toml"),
  //language: "it",
  //date: [this year],
  //show-header: false,
  //show-alternatives: false,
  //show-description: false,
  color-theme: colormap("Pastel1", 9),
)