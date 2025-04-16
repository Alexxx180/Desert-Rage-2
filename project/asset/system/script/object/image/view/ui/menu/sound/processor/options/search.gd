extends Node

var theme: OpenThemeDialog

func for_theme(entry: Dictionary, ui: Control) -> void:
	theme.show_dialog(func(track: String):
		entry.ui.set[ui.i].set_metadata(track)
		entry.theme.set[ui.i] = track
	)

func for_named(entry: Dictionary, ui: Control) -> void:
	theme.show_dialog(func(track: String):
		var event: String = ui.event.name
		entry.ui.set[event].set_metadata(track)
		entry.theme[event] = track
	)

func for_standalone(entry: Dictionary, ui: Control) -> void:
	theme.show_dialog(func(track: String):
		entry.ui.set.set_track_metadata(track)
		entry.theme[1] = track
	)

func for_blend(entry: Dictionary, ui: Control) -> void:
	theme.show_dialog(func(track: String):
		var event: String = ui.event.name
		entry.ui.set[event].set_metadata(track)
		entry.theme.set[event] = track
	)

func for_ambient(entry: Dictionary, status: String, ui: Control) -> void:
	theme.show_dialog(func(track: String):
		entry.ui.set[ui.i].content[status].set_metadata(track)
		entry.theme.set[ui.i][status] = track
	)
