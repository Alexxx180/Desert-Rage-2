extends Button

@onready var caption: VBoxContainer = $margin/caption

func set_metadata(mix: int) -> void:
	caption.status.text = str(mix)
