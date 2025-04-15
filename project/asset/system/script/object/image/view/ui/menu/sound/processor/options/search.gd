extends Node

func search_leaf(setter: Callable) -> void:
	var metadata: Dictionary = {}
	if SoundtrackSystem.get_file(metadata):
		setter.call(metadata)

func for_theme(entry: Dictionary, ui: Control) -> void:
	search_leaf(func(metadata: Dictionary):
		entry.ui.set[ui.i].set_metadata(metadata.track)
		entry.theme.set[ui.i] = metadata.track
	)

func for_named(entry: Dictionary, ui: Control) -> void:
	search_leaf(func(metadata: Dictionary):
		var event: String = ui.event.name
		entry.ui.set[event].set_metadata(metadata.track)
		entry.theme[event] = metadata.track
	)

func for_blend(entry: Dictionary, ui: Control) -> void:
	search_leaf(func(metadata: Dictionary):
		var event: String = ui.event.name
		entry.ui.set[event].set_metadata(metadata.track)
		entry.theme.set[event] = metadata.track
	)

func for_ambient(entry: Dictionary, status: String, ui: Control) -> void:
	search_leaf(func(metadata: Dictionary):
		entry.ui.set[ui.i].content[status].set_metadata(metadata.track)
		entry.theme.set[ui.i][status] = metadata.track
	)
