extends Node

var mode: Node # TODOT GAME CONTROLS

func setup(work: Node) -> Node:
	mode = work.controls.manage.mode
	return self

func connect_mouse(ui: VBoxContainer) -> void:
	var nodes: Array[Node] = ui.options.get_children()
	nodes.pop_front()
	for button in nodes:
		button.pressed.connect(func():
			mode.as_device(mode.MOUSE)
			mode.hot())

func connect_keyboard(ui: VBoxContainer) -> void:
	var nodes: Array[Node] = ui.options.get_children()
	nodes.pop_front()
	for button in nodes:
		button.pressed.connect(func():
			mode.as_device(mode.MOUSE)
			mode.hot())

func connect_gamepad(ui: VBoxContainer) -> void:
	var one: Array[String] = ["hands", "legs", "skill_1", "skill_2"]
	var hot: Array[String] = ["fire"]
