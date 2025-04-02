extends Button

@onready var caption: Label = $margin/caption

func _toggled(toggled_on: bool) -> void:
	caption.text = "X" if toggled_on else "Y"
