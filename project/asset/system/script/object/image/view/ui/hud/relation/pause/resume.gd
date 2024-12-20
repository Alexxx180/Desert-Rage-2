extends Node

func controls(hud: Control, resume: Button) -> void:
	var suspend: Node = hud.processor.pause.resume
	suspend.input.connect(resume.short.sync_control_hint)
	resume.pressed.connect(suspend.resume)
	suspend.ui = hud.detector
