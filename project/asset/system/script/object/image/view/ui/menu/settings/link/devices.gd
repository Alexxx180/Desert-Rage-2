extends Node

@onready var buttons: Node = $buttons  # TODOT GAME CONTROLS

func connect_mouse(type: int) -> void:
	var options: Array = ["map", "settings", "main_menu", "soundtrack", "checkpoint", "fast_save",
		"fast_load", "saves", "fullscreen", "photo_mode"]
	#var luggage: Array = ["inventory", "equipment", "ability", "priorities"]
	# "movement"
	var subjects: Array = ["inventory_prev", "inventory_next", "fire", "combo"]
	var skills: Array = ["hands", "legs", "skill_1", "skill_2"]
	var keys: Dictionary = {
		"HOT": skills + subjects,
		"ALL": ["skills", "subjects"],
		"MASK": { "skills": skills.size(), "subjects": subjects.size() }
	}
	#var nodes: Array[Node] = buttons.t.management.mouse.options.get_children()
	#nodes.pop_front()
	#buttons.connect_mouse(nodes, type)
	buttons.connect_all(keys, type)

func connect_keyboard(type: int) -> void:
	var options: Array = ["map", "settings", "main_menu", "soundtrack", "checkpoint", "fast_save",
		"fast_load", "saves", "fullscreen", "photo_mode"]
	var luggage: Array = ["inventory", "equipment", "ability", "priorities"]
	var keys: Dictionary = {
		"ALT": ["hands", "legs", "skill_1", "skill_2", "left", "forward", "right", "backward",
		"quick_heal", "quick_refresh"],
		"HOT": ["fire"], "AGG": ["movement"], "ALL": ["luggage", "options"],
		"MASK": { "options": options.size(), "luggage": luggage.size() }
	}
	var agg: Array[String] = ["movement"]
	for i in [luggage, options]: keys.HOT += i
	# var all: Array[String] = ["luggage"] # [alt, hot, agg]
	buttons.connect_all(keys, type)

func connect_gamepad(type: int) -> void:
	var keys: Dictionary = {
		"ONE": ["hands", "legs", "skill_1", "skill_2", "left", "forward", "right", "backward"],
		"HOT": ["fire", "inventory", "equipment", "ability", "priorities"],
		"AGG": ["movement", "targeting"]
	} # enum { NONE = 0, KEY = 1, ALT = 2, HOT = 3, AGG = 4, ALL = 5 }
	# var all: Array[String] = ["luggage"]
	buttons.connect_all(keys, type)
