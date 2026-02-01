extends Node

@onready var buttons: Node = $buttons  # TODOT GAME CONTROLS
@onready var resolve: Node = $resolve

var d: Node:
	get: return buttons.resolve.mode.device

func setup(work: Node) -> Node:
	buttons.resolve = resolve
	resolve.mode = work.controls.manage.mode
	return self

func connect_mouse(ui: VBoxContainer) -> void:
	var nodes: Array[Node] = ui.options.get_children()
	nodes.pop_front()
	buttons.connect_mouse(ui, nodes)

func connect_keyboard(ui: VBoxContainer) -> void:
	var hot: Array = ["map", "settings", "main_menu", "soundtrack", "checkpoint", "fast_save",
		"fast_load", "saves", "fullscreen", "photo_mode"]
	var keys: Dictionary = {
		"ALT": ["hands", "legs", "skill_1", "skill_2", "left", "forward", "right", "backward",
		"quick_heal", "quick_refresh"],
		"HOT": ["fire", "inventory", "equipment", "ability", "priorities"],
		"AGG": ["movement"],# "targeting"],
		"MASK": { "options": hot.size() }
	}
	var agg: Array[String] = ["movement"]
	keys.HOT += hot
	# var all: Array[String] = ["luggage"] # [alt, hot, agg]
	buttons.connect_all(keys, ui, d.KEYBOARD)

func connect_gamepad(ui: VBoxContainer) -> void:
	var keys: Dictionary = {
		"ONE": ["hands", "legs", "skill_1", "skill_2", "left", "forward", "right", "backward"],
		"HOT": ["fire", "inventory", "equipment", "ability", "priorities"],
		"AGG": ["movement", "targeting"]
	} # enum { NONE = 0, KEY = 1, ALT = 2, HOT = 3, AGG = 4, ALL = 5 }
	# var all: Array[String] = ["luggage"]
	buttons.connect_all(keys, ui, d.GAMEPAD)
