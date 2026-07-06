extends Node

var switch: Node

func _lazy_transit_connection(hud: CanvasLayer) -> void:
	switch = hud.processor.pause.settings

func controls(hud: CanvasLayer, settings: Button) -> void:
	_lazy_transit_connection(hud)
	var pause: Control = hud.see.pause
	pause.visibility_changed.connect(func():
		Works.turn(switch.short, pause.visible))
	settings.pressed.connect(switch.feedback)
