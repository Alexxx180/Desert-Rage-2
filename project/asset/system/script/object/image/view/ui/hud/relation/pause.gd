extends Node

func controls(hud: Control) -> void:
	var ui: Control = hud.detector
	var suspend: Node = hud.processor.suspend

	var pause: Button = hud.detector.get_node("game/margin/pause")
	suspend.short.push_back(pause.get_node("content/pause/short"))
	pause.pressed.connect(suspend.toggle_pause)

	var resume = hud.detector.get_node("pause/margin/stretch/pause/menu/resume")
	suspend.short.push_back(resume.get_node("content/resume/short"))
	resume.pressed.connect(suspend.toggle_pause)

	suspend.game = ui.get_node("game")
	suspend.pause = ui.get_node("pause")
