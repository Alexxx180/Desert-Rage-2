extends Node

func controls(hud: CanvasLayer) -> void:
	hud.detector.pause.options.navigate.toggled.connect(
		func(state: bool): hud.detector.pause.navigation.visible = state)
	#var info: Node = hud.processor.pause.info
	#var short: Control = hud.detector.pause.options.hints.short
	#info.input.connect(short.sync_control_hint)
