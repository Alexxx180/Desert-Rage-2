extends HBoxContainer

@onready var leaf: Button = $leaf
@onready var active: Button = $active

var event: Dictionary = { "id": 0, "name": "" }

func set_track_metadata(track: String) -> void:
	leaf.set_metadata(track)

func set_metadata(track: Array) -> void:
	active.set_metadata(track[0])
	set_track_metadata(track[1])

func set_track_authority(ui_track: String) -> void:
	leaf.set_track_authority(ui_track)

func set_options(options: Node, context: Dictionary) -> void:
	options.set_standalone(context, self)

func set_feedback(feedback: Callable) -> void:
	leaf.pressed.connect(feedback)
