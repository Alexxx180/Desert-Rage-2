extends Node

func controls(hud: Control) -> void:
	hud.processor.hints.short = hud.detector.get_node("pause/margin/hints/short")
