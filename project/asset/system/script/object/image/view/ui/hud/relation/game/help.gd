extends Node

func controls(hud: Control, analyze: Button) -> void:
	var hint: InputObserver = hud.processor.game.help
	var hints: VBoxContainer = hud.detector.game.margin.hints

	hint.input.connect(analyze.short.sync_control_hint)
	hint.input.connect(hints.motion.get_node("move").sync_control_hint)
	hint.input.connect(hints.action.get_node("act").sync_control_hint)
	hint.input.connect(hints.reason.get_node("team").sync_control_hint)
	hint.input.connect(hints.reason.get_node("group").sync_control_hint)
	#hint.show_help(true)
