class_name SoundtrackLeaf extends Button

@onready var metadata: Label = $metadata

var i: int
var caption: String = ""

func set_metadata(track: String) -> void:
	var slash: int = track.rfind("/") + 1
	var path: String = track.replace("\\", "/").substr(slash)
	var dot: int = path.rfind(".")
	caption = path.substr(0, dot)
	metadata.text = track
	text = caption

func set_track_authority(ui_track: String) -> void:
	metadata.text = ui_track
	text = ui_track + "_metadata"

func set_options(options: Node, context: Dictionary) -> void:
	options.set_leaf_theme(context, self)
