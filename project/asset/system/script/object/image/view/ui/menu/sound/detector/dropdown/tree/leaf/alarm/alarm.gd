extends HBoxContainer

@onready var leaf: Button = $leaf
@onready var active: Button = $active

func set_metadata(track: Array) -> void:
	active.set_metadata(track[0])
	leaf.set_metadata(track[1])

func set_track_authority(ui_track: String) -> void:
	leaf.set_track_authority(ui_track)

func set_options(options: Node, context: Dictionary) -> void:
	options.set_named_theme(context)
