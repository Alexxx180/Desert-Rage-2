extends Node

@onready var buttons: Node = $buttons  # TODOT GAME CONTROLS

enum { M = 0, S = 1 }

func mask_hot_keys(keys: Dictionary, agg: Dictionary) -> Dictionary:
	keys.MASK = {}
	for key in keys.ALL: keys.MASK[key] = agg[key].size()
	return keys

func movement() -> Array: return ["forward", "left", "backward", "right"]
func skills() -> Array: return ["hands", "legs", "skill_1", "skill_2"]
func luggage() -> Array: return ["inventory", "equipment", "ability", "priorities"]
func subjects() -> Array: return ["inventory_prev", "inventory_next", "fire", "combo"]
func quick() -> Array: return ["team", "group", "quick_heal", "quick_refresh"]
func aggregated() -> Dictionary:
	return { "luggage": luggage(), "movement": movement(), "skills": skills(), "subjects": subjects(), "quick": quick() }

func connect_mouse(type: int) -> void:
	var agg: Dictionary = { "subjects": subjects(), "skills": skills() }
	var keys: Dictionary = {
		"HOT": ["movement"] + agg.skills + agg.subjects, "ALL": ["skills", "subjects"],
	}
	buttons.connect_all(mask_hot_keys(keys, agg), type, agg)

func connect_keyboard(type: int) -> void:
	var agg: Dictionary = aggregated()
	agg.options = ["map", "settings", "main_menu", "soundtrack", "checkpoint", "fast_save",
		"fast_load", "saves", "fullscreen", "photo_mode"]
	var keys: Dictionary = {
		"ALT": agg.movement + agg.skills,
		"HOT": ["fire"] + agg.luggage + agg.options + agg.quick + agg.subjects,
		"AGG": ["movement", "skills"], "ALL": ["luggage", "options", "quick", "subjects"]
	}
	buttons.connect_all(mask_hot_keys(keys, agg), type, agg)

func connect_gamepad(type: int) -> void:
	var agg: Dictionary = aggregated()
	var keys: Dictionary = {
		"ONE": agg.movement + agg.skills,
		"HOT": ["fire"] + agg.luggage + agg.subjects + agg.quick,
		"AGG": ["movement", "targeting", "subjects"],
		"ALL": ["quick"]
	}
	buttons.connect_all(mask_hot_keys(keys, agg), type, agg)
