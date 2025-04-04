extends Button

@onready var caption: VBoxContainer = $margin/caption

func _toggled(toggled_on: bool) -> void:
	print("TOGGLE")
	set_metadata(toggled_on)

func set_metadata(status: bool) -> void:
	caption.status.text = "V" if status else "X"
