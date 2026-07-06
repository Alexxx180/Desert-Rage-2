extends Button

@onready var caption: Label = $margin/caption

func _toggled(toggled_on: bool) -> void:
	set_metadata(toggled_on)

func set_metadata(status: bool) -> void:
	caption.text = "📢" if status else "🔇"
