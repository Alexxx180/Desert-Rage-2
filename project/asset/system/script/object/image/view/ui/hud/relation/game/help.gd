extends Node

func controls(hud: Control, analyze: Button) -> void:
	var hint: InputObserver = hud.processor.game.help
	var motion: VBoxContainer = hud.detector.game.margin.hints.motion

	hint.input.connect(analyze.short.sync_control_hint)
	hint.input.connect(motion.get_node("move").sync_control_hint)
	#hint.show_help(true)
