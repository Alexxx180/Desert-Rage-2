extends Button

@onready var description: Label = $margin/caption/description
@onready var metadata: Label = $margin/caption/metadata

var caption: String:
	set(value):
		description.text = value

var path: String:
	set(value):
		metadata.text = value

func set_track_authority(ui_track: String) -> void:
	caption = ui_track
	path = ui_track + "_metadata"
