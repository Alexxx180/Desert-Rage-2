extends Node

var switch: Node

func controls(hud: CanvasLayer, settings: Button) -> void:
	switch = hud.processor.pause.settings
	
	var pause: Control = hud.detector.pause
	pause.visibility_changed.connect(func():
		Processors.turn(switch.short, pause.visible)
	)
	settings.pressed.connect(switch.feedback)
