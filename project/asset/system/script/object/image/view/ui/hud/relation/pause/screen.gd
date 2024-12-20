extends Node

func controls(hud: Control, screen: Button) -> void:
	var mode: Node = hud.processor.pause.screen
	screen.toggled.connect(mode.toggle)
	mode.state = screen.window.mode
	mode.short = screen.window.short
