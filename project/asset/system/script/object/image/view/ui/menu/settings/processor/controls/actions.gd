extends Node

class_name ActionsControl

var keys: Node
var defaults: Node
var word: String
var actions: Dictionary

func _set_event(act: String, event: InputEvent) -> void:
	InputMap.action_erase_event(act, event)
	InputMap.action_add_event(act, event)

func a(no: int) -> String: return _act[no]

func translate_word(key: int) -> bool:
	if not keys.escapes.has(key):
		word = OS.get_keycode_string(key)
		return false
	word = keys.escapes[key]
	return true

func translate(acts: Array[Array]) -> Array[String]:
	var result: Array[String] = []
	for act in acts:
		var sentence: Array[String] = []
		for i in act:
			translate_word(actions[a(i)])
			sentence.append(word)
		result.append("".join(sentence))
	return result

func masked_translate(hint: String) -> Array[String]:
	if mask.has(hint): return translate(mask[hint])
	if defaults.has(hint): return defaults[hint]
	return Defaults.ARRAY

enum ACT {
	MOVEMENT, LEFT, UP, RIGHT, DOWN, HANDS,
	LEGS, SKILL_ONE, SKILL_TWO, FIRE, VIEW_UP,
	VIEW_DOWN, INVENTORY_UP, INVENTORY_DOWN, GROUP_TEAM,
	GROUP_DEPLOY, QUICK_HEAL, QUICK_REFRESH, MAP,
	SAVES, SETTINGS, MAIN_MENU, OST_SYSTEM,
	CHECKPOINT, FAST_SAVE, FAST_LOAD, FULLSCREEN,
	PHOTOMODE, AIMING, PANEL_LEFT_TOGGLE, PANEL_RIGHT_TOGGLE,
	INVENTORY_TOGGLE, ABILITY_TOGGLE, EQUIPMENT_TOGGLE, PRIORITIES_TOGGLE,
	INVENTORY_SHOW, ABILITY_SHOW, EQUIPMENT_SHOW, PRIORITIES_SHOW,
	INVENTORY_HIDE, ABILITY_HIDE, EQUIPMENT_HIDE, PRIORITIES_HIDE,
	UI_LMB
}

const _act: Array[String] = [
	"movement", "left", "forward", "right", "backward", "action", "run", "skill_one",
	"skill_two", "fire", "view_left", "view_right", "inventory_up", "inventory_down",
	"select", "deploy", "quick_heal", "quick_refresh", "map", "saves", "settings",
	"main_menu", "ost_system", "checkpoint", "fast_save", "fast_load", "fullscreen",
	"photomode", "aiming", "panel_left_toggle", "panel_right_toggle",
	"inventory_toggle", "ability_toggle", "equipment_toggle", "priorities_toggle",
	"inventory_show", "ability_show", "equipment_show", "priorities_show",
	"inventory_hide", "ability_hide", "equipment_hide", "priorities_hide", "ui_lmb"
]

func m(type: String, value: Array) -> ActionsControl:
	mask[type] = value
	return self

func set_mask() -> ActionsControl:
	return m("СM", [[ACT.INVENTORY_TOGGLE], [ACT.HANDS]]
	).m("RM", [[ACT.GROUP_TEAM]]).m(
		"RG", [[ACT.GROUP_DEPLOY], [ACT.GROUP_DEPLOY]]
	).m("AM", [[ACT.AIMING], [ACT.MOVEMENT]]).m(
		"LG", [
		[ACT.INVENTORY_SHOW], [ACT.INVENTORY_HIDE],
		[ACT.EQUIPMENT_SHOW], [ACT.EQUIPMENT_HIDE],
		[ACT.PRIORITIES_SHOW], [ACT.PRIORITIES_HIDE],
		[ACT.ABILITY_SHOW], [ACT.ABILITY_HIDE],
	]).m("CF", [[ACT.HANDS]]).m("AY", [[ACT.HANDS]])

func _ready() -> void: set_mask()

var mask: Dictionary = {
	"MB": [[ACT.HANDS]],
	"AA": [[ACT.HANDS]],
	"AF": [[ACT.SKILL_ONE]],
	"AH": [[ACT.SKILL_TWO]],
	"AW": [[ACT.SKILL_ONE]],
	"AT": [[ACT.SKILL_TWO]],
	"CF": [[ACT.HANDS]],
	"SR": [[ACT.LEGS], [ACT.LEGS]],
}
