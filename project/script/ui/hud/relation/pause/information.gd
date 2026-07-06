extends Node

var switch: Node

func _lazy_transit_connection(hud: CanvasLayer) -> void:
	switch = hud.processor.pause.info

func controls(hud: CanvasLayer, information: Button) -> void:
	_lazy_transit_connection(hud)
	#var pause: Control = hud.detector.pause
	#pause.visibility_changed.connect(func():
		#Processors.turn(switch.short, pause.visible))
	information.pressed.connect(switch.feedback)
