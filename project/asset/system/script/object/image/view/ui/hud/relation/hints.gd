extends Node

func controls(hud: Control) -> void:
	var path: String = "pause/margin/stretch/pause/hints/short"
	hud.processor.hints.short = hud.detector.get_node(path)
