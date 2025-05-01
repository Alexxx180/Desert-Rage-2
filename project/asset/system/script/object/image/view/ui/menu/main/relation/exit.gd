extends Node

func controls(hud: Control, exit: Node) -> void:
	hud.options.menu.exit.pressed.connect(exit.exit_the_game)
