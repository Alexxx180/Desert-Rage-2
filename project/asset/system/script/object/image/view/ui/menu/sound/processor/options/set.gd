extends Node

var enabled: bool = false

func search_leaf(setter: Callable) -> void:
	var metadata: Dictionary = {}
	if SoundtrackSystem.get_file(metadata):
		setter.call(metadata)

func search_theme(entry: Dictionary) -> void:
	if enabled:
		search_leaf(func(metadata: Dictionary):
			var i: int = entry.i
			entry.ui[i].set_metadata(metadata)
			entry.ost[i] = metadata.track
		)

func search_fight(entry: Dictionary, status: String) -> void:
	if enabled:
		search_leaf(func(metadata: Dictionary):
			var i: int = entry.i
			entry.ui[i].content[status].set_metadata(metadata)
			entry.ost[i][status] = metadata.track
		)

