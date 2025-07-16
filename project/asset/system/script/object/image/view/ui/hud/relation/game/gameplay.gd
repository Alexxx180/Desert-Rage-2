extends Node

var _actions: bool = false

func controls(hud: CanvasLayer, options: HFlowContainer) -> void:
	options.menu.pressed.connect(func():
		_actions = !_actions
		options.skills.visible = _actions
	)
