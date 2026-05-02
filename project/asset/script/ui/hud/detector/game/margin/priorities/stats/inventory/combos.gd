extends Label

var tools: Dictionary

func _ready() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.5).set_delay(1)
	tween.tween_callback(disappear)

func disappear() -> void:
	tools.combos = null
	queue_free()
