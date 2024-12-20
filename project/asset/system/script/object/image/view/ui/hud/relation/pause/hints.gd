extends Node

func controls(hud: Control) -> void:
	var hints: InputObserver = hud.processor.pause.hints
	var short: Control = hud.detector.pause.options.hints.short
	hints.input.connect(short.sync_control_hint)
