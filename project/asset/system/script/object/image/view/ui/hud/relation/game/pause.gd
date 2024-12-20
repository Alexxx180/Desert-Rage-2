extends Node

func controls(hud: Control, pause: Button) -> void:
	var game: InputObserver = hud.processor.game.pause
	game.input.connect(pause.short.sync_control_hint)
	pause.pressed.connect(game.suspend)
	game.ui = hud.detector
