extends Node

@export_range(0.5, 4.0, 0.5) var time: float = 0.75

func disappear(ui: Control) -> Tween:
	var tween: Tween = create_tween()
	tween.tween_property(ui, "modulate", Color.TRANSPARENT, time)
	return tween

func appear(ui: Control) -> void:
	ui.modulate = Color.WHITE
