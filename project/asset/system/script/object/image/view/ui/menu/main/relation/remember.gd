extends Node

func controls(hud: Control, remember: Node) -> void:
	hud.options.menu.remember.pressed.connect(remember.scene_change)
