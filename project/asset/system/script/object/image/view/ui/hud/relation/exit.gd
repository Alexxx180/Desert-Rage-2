extends Node

var _pause: Control
var _exit: Node

func _shortcut_available() -> void:
	Processors.turn(_exit, _pause.visible)

func controls(hud: Control, button: Button) -> void:
	var content: Control = button.get_node("content/exit")
	var exit: Node = hud.processor.exit

	_exit = exit.shortcut
	_pause = hud.detector.get_node("pause")
	
	_pause.visibility_changed.connect(_shortcut_available)
	
	_exit.pressed.connect(exit.exit_the_game)
	button.pressed.connect(exit.exit_the_game)

	exit.short.push_back(content.get_node("short"))
	exit.short.push_back(content.get_node("alt"))
