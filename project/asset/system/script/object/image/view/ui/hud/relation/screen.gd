extends Node

func controls(hud: Control, button: Button) -> void:
	var content: Control = button.get_node("content/window")
	var screen: Node = hud.processor.screen

	button.toggled.connect(screen.toggle)

	screen.state = content.get_node("mode")
	screen.short = content.get_node("short")
