extends Node

func connect_hint(hint: InputObserver, hints, act: String) -> void:
	hint.input.connect(hints.get_node(act).sync_control_hint)

func controls(hud: CanvasLayer, analyze: Button) -> void:
	var hint: InputObserver = hud.processor.game.help
	var hints: VBoxContainer = hud.detector.game.hints

	# hint.input.connect(analyze.short.sync_control_hint)
	analyze.pressed.connect(hints.toggle_help)
	connect_hint(hint, hints.action, "act")
	for act in ["move", "push"]:
		connect_hint(hint, hints.motion, act)
	for act in ["team", "group"]:
		connect_hint(hint, hints.reason, act)
	#hint.show_help(true)0.1
