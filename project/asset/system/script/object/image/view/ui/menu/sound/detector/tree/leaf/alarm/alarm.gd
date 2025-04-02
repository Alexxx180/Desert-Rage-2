extends HBoxContainer

@onready var leaf: Label = $leaf

func set_metadata(track: String) -> void:
	leaf.set_metadata(track)

func set_track_authority(ui_track: String) -> void:
	leaf.set_track_authority(ui_track)
