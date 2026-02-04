extends Node

@onready var buttons: Node = $buttons  # TODOT GAME CONTROLS

enum { M = 0, S = 1 }

var _mask: Dictionary

func n(mask: Dictionary) -> Node:
	_mask = mask
	return self
func m() -> Dictionary: return _mask
func s(agg: Dictionary, key: String) -> Node:
	_mask[key] = agg[key].size()
	return self

func movement() -> Array: return ["forward", "left", "backward", "right"]
func skills() -> Array: return ["hands", "legs", "skill_1", "skill_2"]
func luggage() -> Array: return ["inventory", "equipment", "ability", "priorities"]
func subjects() -> Array: return ["inventory_prev", "inventory_next", "fire", "combo"]
func quick() -> Array: return ["team", "group", "quick_heal", "quick_refresh"]
func aggregated() -> Dictionary:
	return { "luggage": luggage(), "movement": movement(), "skills": skills(), "subjects": subjects(), "quick": quick() }

func connect_mouse(type: int) -> void: # var options: Array = ["map", "settings", "main_menu", "soundtrack", "checkpoint", "fast_save", "fast_load", "saves", "fullscreen", "photo_mode"] # var luggage: Array = ["inventory", "equipment", "ability", "priorities"] # "movement"
	var agg: Dictionary = { "subjects": subjects(), "skills": skills() }
	var keys: Dictionary = {
		"HOT": ["movement"] + agg.skills + agg.subjects,
		"ALL": ["skills", "subjects"],
		"MASK": n({}).s(agg, "skills").s(agg, "subjects").m()
	}
	buttons.connect_all(keys, type, agg)

func connect_keyboard(type: int) -> void:
	var agg: Dictionary = aggregated()
	agg.options = ["map", "settings", "main_menu", "soundtrack", "checkpoint", "fast_save",
		"fast_load", "saves", "fullscreen", "photo_mode"]
	var keys: Dictionary = {
		"ALT": agg.movement + agg.skills,
		"HOT": ["fire"] + agg.luggage + agg.options + agg.quick,
		"AGG": ["movement", "skills"], "ALL": ["luggage", "options"],
		"MASK": n({}).s(agg, "options").s(agg, "luggage").s(agg, "quick").m()
	} # var agg: Array[String] = ["movement"] # var all: Array[String] = ["luggage"] # [alt, hot, agg]
	buttons.connect_all(keys, type, agg)

func connect_gamepad(type: int) -> void:
	var agg: Dictionary = aggregated()
	var keys: Dictionary = {
		"ONE": agg.movement + agg.skills,
		"HOT": ["fire"] + agg.luggage + agg.subjects,
		"AGG": ["movement", "targeting"],
		"ALL": agg.quick
	} # enum { NONE = 0, KEY = 1, ALT = 2, HOT = 3, AGG = 4, ALL = 5 } # var all: Array[String] = ["luggage"]
	buttons.connect_all(keys, type, agg)
