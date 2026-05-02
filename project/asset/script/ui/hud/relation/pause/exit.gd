extends Node

func controls(hud: CanvasLayer, exit: Button) -> void:
	var leave: Node = hud.processor.pause.exit

	var pause: Control = hud.see.pause
	pause.visibility_changed.connect(func():
		Works.turn(leave.short, pause.visible)
	)
	exit.pressed.connect(leave.feedback)
