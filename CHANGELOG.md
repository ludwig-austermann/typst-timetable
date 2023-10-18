# v0.2.0-beta.1
## code facing
- added color themes. you can specify one of the color themes as given in `colorthemes.pdf` and overwrite special colors in the data file
- added description table, showing further information about your courses
## data / dictionary
- added `duration` the new `defaults`, so that only `start` or `end` has to be specified for events
- added `hide` for courses
- added `description` table to specify description table
- added `course -> hide-discription` option, to hide course from description

# v0.2.0-beta
- entrypoint is now `timetable.typ`
- added a `typst.toml`
- removed page sizing from function
- added arguments `show-header`, `show-alternatives`
- *changed `show_time` argument to `show-time` for the data dictionary*
- added `priority` argument to data dictionary
- using now tablex
- because of tablex, rowspans are used if events are longer than duration
- added `tablex-args` to timetable arguments to modify style
- added `event-cell` and `time-cell` to timetable arguments, to modify the blocks. The default functions live in `lib\default-blocks.typ`