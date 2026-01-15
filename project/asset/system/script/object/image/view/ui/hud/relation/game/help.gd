extends Node

func connect_hint(hint: InputObserver, hints, act: String) -> void:
	hint.input.connect(hints.get_node(act).sync_control_hint)

func controls(hud: CanvasLayer, game: Control) -> void:
	var hint: InputObserver = hud.processor.game.help
	var hints: VBoxContainer = game.controls.preview.help.help.hints
	# var hints: VBoxContainer = hud.detector.game.hints

	# hint.input.connect(analyze.short.sync_control_hint)
	var analyze: Button = game.controls.preview.help.tabs.analyze

	# """
	#analyze.pressed.connect(hints.toggle_help)
	# TODO FIXME CATEGORY
	#for button in game.hints.get_node("group").get_children():
	#	button.toggled.connect(func(off: bool):
	#		game.hints.help[button.name].visible = !off)

	connect_hint(hint, hints.action, "act")
	for act in ["move", "push"]:
		connect_hint(hint, hints.motion, act)
	for act in ["team", "group"]:
		connect_hint(hint, hints.reason, act)
	# """
	#hint.show_help(true)0.1
