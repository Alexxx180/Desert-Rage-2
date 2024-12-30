extends Node

var _pause: Control
var _short: Node

func _shortcut_available() -> void:
	Processors.turn(_short, _pause.visible)

func controls(hud: Control, exit: Button) -> void:
	var leave: InputObserver = hud.processor.pause.exit

	_pause = hud.detector.pause
	_pause.visibility_changed.connect(_shortcut_available)
	_short = leave.shortcut
	_short.pressed.connect(leave.exit_the_game)
	exit.pressed.connect(leave.exit_the_game)

	for short in exit.leave.short:
		leave.input.connect(short.sync_control_hint)
