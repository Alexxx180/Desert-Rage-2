extends Node

func controls(hud: Control, button: Button) -> void:
	var motion: VBoxContainer = hud.detector.get_node("game/margin/hints/motion")
	var content: Control = button.get_node("content/help")
	var hint: Node = hud.processor.help

	#button.toggled.connect(hint.show_help)
	#button.pressed.connect(motion.toggle_hints)

	hint.state = content.get_node("mode/state")
	hint.short = content.get_node("short")
	hint.show_help(true)
