extends Button

class_name SoundtrackLeaf

@onready var description: Label = $margin/caption/description
@onready var metadata: Label = $margin/caption/metadata

func set_metadata(track: String) -> void:
	var slash: int = track.rfind("/") + 1
	var path: String = track.replace("\\", "/").substr(slash)
	var dot: int = path.rfind(".")
	metadata.text = track
	description.text = path.substr(0, dot)

func set_track_authority(ui_track: String) -> void:
	metadata.text = ui_track
	description.text = ui_track + "_metadata"
