extends Button

class_name SountrackLeaf

@onready var description: Label = $margin/caption/description
@onready var metadata: Label = $margin/caption/metadata

func set_metadata(track: String) -> void:
	var slash: int = track.rfind("/")
	var dot: int = track.rfind(".")
	metadata.text = track.replace("\\", "/")
	description.text = metadata.text.substr(slash).substr(dot)

func set_track_authority(ui_track: String) -> void:
	metadata.text = ui_track
	description.text = ui_track + "_metadata"
