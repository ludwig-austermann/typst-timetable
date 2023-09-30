# typst-timetable
A typst template for timetables

## Features
A resulting timetable looks like this:
![example](example/2023.png)

- Collision detection
- Automatic extension over multiple fields / cells / time slots
- ...

## Usage
The main difficulty lies in defining the dictionary with the necessary data. Take a look into the example to see how a `json` or `toml` file can be used to specify the data, which can then be included into `.typ` files.

### Functions
The exposed `timetable` function takes the following arguments:
- `all-data`: is the necessary data input
- `language: "en"`: the language to use for weekdays and other terms
- `date: datetime.today().display("[day].[month].[year]")`: the date to be displayed in the header
- `show-header: true`: if to show the header
- `show-alternatives: true`: if to show collisions and their corresponding alternatives
- `tablex-args: (:)`: arguments to be passed to the underlying tablex table, to overwrite the style
- `event-cell: default-blocks.event-cell`: how to display the events
- `time-cell: default-blocks.time-cell`: how to display the time cells

## Git/Typst Usage Tipp
If you want your own project to be git controlled, but still want to recieve updates from this repo, you can use git submodules.