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
			entry.ui.set[ui.i].set_metadata(metadata.track)
			entry.theme.set[ui.i] = metadata.track
		)

func for_named(entry: Dictionary, ui: Control) -> void:
	if enabled:
		search_leaf(func(metadata: Dictionary):
			entry.ui.set[ui.event.name].set_metadata(metadata.track)
			entry.theme[ui.event.name] = metadata.track
		)

func for_ambient(entry: Dictionary, status: String, ui: Control) -> void:
	if enabled:
		search_leaf(func(metadata: Dictionary):
			entry.ui.set[ui.i].content[status].set_metadata(metadata)
			entry.theme.set[ui.i][status] = metadata.track
		)
