extends Node

@onready var buttons: Node = $buttons  # TODOT GAME CONTROLS

func setup(work: Node) -> Node:
	buttons.mode = work.controls.manage.mode
	return self

func connect_mouse(ui: VBoxContainer) -> void:
	buttons.connect_finish(ui)
	
	var nodes: Array[Node] = ui.options.get_children()
	nodes.pop_front()
	for button in nodes:
		buttons.connect_button(button, ui, buttons.mode.MOUSE)
		button.pressed.connect(buttons.mode.hot)

func connect_keyboard(ui: VBoxContainer) -> void:
	var alt: Array[String] = ["hands", "legs", "skill_1", "skill_2", "left", "forward", "right", "backward",
		"quick_heal", "quick_refresh"]
	var hot: Array[String] = ["fire", "inventory", "equipment", "ability", "priorities", "map", "settings", "main_menu",
		"soundtrack", "checkpoint", "fast_save", "fast_load", "saves", "fullscreen", "photo_mode"]
	var agg: Array[String] = ["movement"]#, "targeting"]
	# var all: Array[String] = ["luggage"]
	buttons.connect_all([alt, hot, agg], ["alternate", "hot", "aggregate"], ui, buttons.mode.KEYBOARD)

func connect_gamepad(ui: VBoxContainer) -> void:
	var one: Array[String] = ["hands", "legs", "skill_1", "skill_2", "left", "forward", "right", "backward"]
	var hot: Array[String] = ["fire", "inventory", "equipment", "ability", "priorities"]
	var agg: Array[String] = ["movement", "targeting"]
	# var all: Array[String] = ["luggage"]
	buttons.connect_all([one, hot, agg], ["one_key", "hot", "aggregate"], ui, buttons.mode.GAMEPAD)
