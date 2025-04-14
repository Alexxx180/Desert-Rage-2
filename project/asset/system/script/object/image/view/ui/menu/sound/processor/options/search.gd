extends Node

var enabled: bool = false

func on_toggle(toggled: bool) -> void:
	enabled = toggled
	print(name + " enabled: ", enabled)

func search_leaf(setter: Callable) -> void:
	var metadata: Dictionary = {}
	if SoundtrackSystem.get_file(metadata):
		setter.call(metadata)

func for_theme(entry: Dictionary, ui: Control) -> void:
	if enabled:
		search_leaf(func(metadata: Dictionary):
			entry.ui[ui.i].set_metadata(metadata)
			entry.theme.set[ui.i] = metadata.track
		)

func for_ambient(entry: Dictionary, status: String, ui: Control) -> void:
	if enabled:
		search_leaf(func(metadata: Dictionary):
			entry.ui[ui.i].content[status].set_metadata(metadata)
			entry.theme.set[ui.i][status] = metadata.track
		)
