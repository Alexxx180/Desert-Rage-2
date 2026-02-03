extends Node

@onready var buttons: Node = $buttons  # TODOT GAME CONTROLS

enum { M = 0, S = 1 }

func connect_mouse(type: int) -> void: # var options: Array = ["map", "settings", "main_menu", "soundtrack", "checkpoint", "fast_save", "fast_load", "saves", "fullscreen", "photo_mode"] # var luggage: Array = ["inventory", "equipment", "ability", "priorities"] # "movement"
	var agg: Dictionary = {
		"subjects": ["inventory_prev", "inventory_next", "fire", "combo"],
		"skills": ["hands", "legs", "skill_1", "skill_2"]
	}
	var keys: Dictionary = {
		"HOT": ["movement"] + agg.skills + agg.subjects,
		"ALL": ["skills", "subjects"],
		"MASK": { "skills": agg.skills.size(), "subjects": agg.subjects.size() }
	}
	buttons.connect_all(keys, type, agg)

func connect_keyboard(type: int) -> void:
	var agg: Dictionary = {
		"options": ["map", "settings", "main_menu", "soundtrack", "checkpoint", "fast_save",
		"fast_load", "saves", "fullscreen", "photo_mode"],
		"luggage": ["inventory", "equipment", "ability", "priorities"],
		"movement": ["left", "forward", "right", "backward"],
		"skills": ["hands", "legs", "skill_1", "skill_2"]
	}
	var luggage: Array = ["inventory", "equipment", "ability", "priorities"]
	var keys: Dictionary = {
		"ALT": ["quick_heal", "quick_refresh"] + agg.movement + agg.skills,
		"HOT": ["fire"] + agg.luggage + agg.options,
		"AGG": ["movement"], "ALL": ["luggage", "options"],
		"MASK": { "options": agg.options.size(), "luggage": agg.luggage.size() }
	} # var agg: Array[String] = ["movement"] # var all: Array[String] = ["luggage"] # [alt, hot, agg]
	buttons.connect_all(keys, type, agg)

func connect_gamepad(type: int) -> void:
	var agg: Dictionary = {
		"luggage": ["inventory", "equipment", "ability", "priorities"],
		"movement": ["left", "forward", "right", "backward"],
		"skills": ["hands", "legs", "skill_1", "skill_2"]
	}
	var keys: Dictionary = {
		"ONE": agg.movement + agg.skills,
		"HOT": ["fire"] + agg.luggage,
		"AGG": ["movement", "targeting"]
	} # enum { NONE = 0, KEY = 1, ALT = 2, HOT = 3, AGG = 4, ALL = 5 } # var all: Array[String] = ["luggage"]
	buttons.connect_all(keys, type, agg)
