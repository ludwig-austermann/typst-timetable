# v0.2.0-beta
- removed page sizing from function
- added arguments `show-header`, `show-alternatives`
- *changed `show_time` argument to `show-time` for the data dictionary*
- added `priority` argument to data dictionary
- using now tablex
- because of tablex, rowspans are used if events are longer than duration
- added `tablex-args` to timetable arguments to modify style
- added `event-cell` and `time-cell` to timetable arguments, to modify the blocks. The default functions live in `lib\default-blocks.typ`