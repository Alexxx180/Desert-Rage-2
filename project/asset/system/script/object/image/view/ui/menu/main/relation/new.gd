extends Node

func controls(hud: Control, new: Node) -> void:
	hud.options.menu.new.pressed.connect(new.scene_change)
