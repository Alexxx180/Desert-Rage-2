class_name Settings extends RefCounted

enum {
	H_RAY, H_ROCK, H_ZARAH, H_ARTHUR, TITLE, PAUSE, ENDING,
	P_DESERT, T_DESERT, P_WATER, T_WATER, P_AIR, T_AIR,
	P_FOREST, T_FOREST, P_HILLS, T_HILLS, P_MOTOR, T_MOTOR, P_MECHA, T_MECHA,
	DIALOG, NIGHT, ACCENT, ESCAPE,
	
	BOSSES = 64, MINOR_BOSS, MAJOR_BOSS, SPIDER, WORM, SHADOW_REAPER, PHARAOH,
	MASTER,
	
	CP_CAVES1 = 128, CT_CAVES1, CF_CAVES1, CP_CAVES2, CT_CAVES2, CF_CAVES2,
	CP_CAVES3, CT_CAVES3, CF_CAVES3,  CP_TEMPLE1, CT_TEMPLE1, CF_TEMPLE1,
	CP_TEMPLE2, CT_TEMPLE2, CF_TEMPLE2, CP_TEMPLE3, CT_TEMPLE3, CF_TEMPLE3,
	
	SP_ORIGIN = 256, ST_ORIGIN, SF_ORIGIN,  SP_SMOKE, ST_SMOKE, SF_SMOKE,
	SP_SPARK, ST_SPARK, SF_SPARK,  SP_SHADOW, ST_SHADOW, SF_SHADOW,
	SP_TEMPLE, ST_TEMPLE, SF_TEMPLE,
	
	HEROES_BLEND = 512, CAVES_BLEND = 520, TEMPLE_BLEND = 528
}

var playback_no: int = 0
var playback: PackedInt32Array = [TITLE, H_RAY,
	SP_ORIGIN, ST_ORIGIN, SF_ORIGIN, SPIDER, ACCENT,
	SP_SMOKE, ST_SMOKE, SF_SMOKE, P_DESERT, WORM,
	SP_SPARK, ST_SPARK, SF_SPARK, SHADOW_REAPER, NIGHT,
	SP_SHADOW, ST_SHADOW, SF_SHADOW, DIALOG, H_ROCK, PAUSE,
	SP_TEMPLE, ST_TEMPLE, SF_TEMPLE, PHARAOH, ENDING]
var _ost: PackedInt64Array

enum { DEFAULTED = -1,
	LT_WORLD = 0, LT_ORIGIN_A = 1, LT_ORIGIN_B = 7, LT_SMOKE_A = 8,
	LT_SMOKE_B = 14, LT_SPARK_A = 15, LT_SPARK_B = 26, LT_TEMPLE_A = 27,
	LT_TEMPLE_B = 35, LT_CREDITS = 36,
}

func toggle_ost(type: int, next: bool) -> void:
	_ost[type >> 64] = Def.to(_ost[type >> 64], type & ((1 << 64) - 1), next)

func check_ost(type: int) -> bool:
	return Def.of(_ost[type >> 64], type & ((1 << 64) - 1))

func level_fight(fight_mode: int) -> void:
	var level_no: int
	if level_no == LT_WORLD:
		if fight_mode == 1:
			level_theme[1] = get_hero_world_theme()
		else:
			level_theme[0] = P_DESERT
	else:
		
	fight_mode = _fight_mode
	
func theme_playback_exit() -> void:
	pass

func get_hero_world_theme() -> void:
	if blend(HEROES_BLEND):
		return [H_RAY, H_ROCK][HUD.hero]
	else:
		return T_DESERT

func _d(from: int, to: int) -> bool:
	return from <= level_no and level_no <= to

var level_no: int
var ost_no: int
var default_no: int
var collection_no: int
var fight_mode: int

func p(ter) -> void:
	ResourceLoader.exists("res://data/ost/music/" + str(no).pad_zeros(2) + ".ogg")

func exists(no: int) -> bool: return check_ost(no) and _defuse(no)
func _defuse(no: int) -> bool:
	if FileAccess.file_exists("user://" + str(no).pad_zeros(2) + ".ogg"): return true
	toggle_ost(no, false)
	return false

func set_fight_mode(mode: int) -> void:
	fight_mode = mode

func set_hero_theme(common: int) -> void:
	if _blend(HEROES_BLEND):
		ost_no = HUD.hero
	else:
		ost_no = common

func set_common_theme(common: int, finished: bool) -> bool:
	if finished:
		no_peace = !check_ost(common + 0)
		no_tense = !check_ost(common + 1)
		no_fight = !check_ost(common + 2)
		if _fight_mode == 0 or (no_tense and no_fight):
			set_hero_theme(DEFAULTED if no_peace else common)
		elif _fight_mode == 1 or no_fight:
			set_hero_theme(common + 1)
		else:
			set_hero_theme(common + 2)
	elif no_tense and no_fight and _blend(HEROES_BLEND):
		ost_no = HUD.hero
		default_no = HUD.hero
	else:
		return false
	return true

func set_theme(common: int, specific: int, defaulted: int, common_blend: bool, finished: bool) -> void:
	if finished:
		collection_no = int(_theme(common)) + int(_theme(common + 3)) + int(_theme(common + 6))
		collection_no = randi_range(0, collection_no)
	common += collection_no * 3
	default_no = defaulted
	var no_peace: bool = !check_ost(specific + 0)
	var no_tense: bool = !check_ost(specific + 1)
	var no_fight: bool = !check_ost(specific + 2)
	finished = finished and (no_peace or common_blend)
	if _fight_mode == 0 or (no_tense and no_fight):
		if !set_common_theme(common, finished): ost_no = specific
	elif _fight_mode == 1 or no_fight:
		if !set_common_theme(common, finished): ost_no = specific + 1
	else:
		if !set_common_theme(common, finished): ost_no = specific + 2

func level_playback_enter(finished: bool = false) -> void:
	if level_no == LT_WORLD:
		if _fight_mode == 0:
			default_no = P_DESERT
			ost_no = P_DESERT
		elif _blend(HEROES_BLEND):
			ost_no = HUD.hero
			default_no = HUD.hero
		else:
			default_no = T_DESERT
			ost_no = T_DESERT
	elif _d(LT_ORIGIN_A, LT_ORIGIN_B): # check for fight mode on defaults
		set_theme(CP_CAVES1, SP_ORIGIN, CP_CAVES1, _blend(CAVES_BLEND), finished)
	elif _d(LT_SMOKE_A, LT_SMOKE_B):
		set_theme(CP_CAVES1, SP_SMOKE, CP_CAVES1, _blend(CAVES_BLEND), finished)
	elif _d(LT_SPARK_A, LT_SPARK_B):
		set_theme(CP_CAVES1, SP_SPARK, CP_CAVES1, _blend(CAVES_BLEND), finished)
	elif _d(LT_SHADOW_A, LT_SHADOW_B):
		set_theme(CP_CAVES1, SP_SPARK, CP_CAVES1, _blend(CAVES_BLEND), finished)
	elif _d(LT_TEMPLE_A, LT_TEMPLE_B):
		set_theme(CP_TEMPLE1, SP_TEMPLE, CP_TEMPLE1, _blend(TEMPLE_BLEND), finished)
	elif level_no == LT_CREDITS:
		ost_no = ENDING
		default_no = ENDING

enum { P_ORIGIN = 2, P_SMOKE = 7, P_SPARK = 12, P_SHADOW = 17, P_TEMPLE = 22,
	D_BOSSES = 8, D_COMMON = 16, D_SPECIFIC = 32 }

func _theme(no: int) -> bool: return Def.of(_ost[no >> D_COMMON], no & 64)

func set_next_playback(idx: int, blend: int,
	common: int, specific: int, hero_blend: bool) -> void:
	if _blend(blend):
		var no: int = 1 + int(_theme(common + 3)) + int(_theme(common + 6))
		no = randi_range(0, no) * 3
		playback[idx] = common + no
		playback[idx + 1] = common + no + 1
		playback[idx + 2] = common + no + 2
	else:
		playback[idx] = specific
		playback[idx + 1] = specific + 1
		playback[idx + 2] = specific + 2
	if hero_blend and _blend(HEROES_BLEND):
		playback[idx + 2] = randi_range(H_RAY, H_ROCK + 1)

func finish_playback() -> void:
	playback_no = 0
	set_next_playback(P_ORIGIN, CAVES_BLEND, CP_CAVES1, SP_ORIGIN, false)
	set_next_playback(P_ORIGIN, CAVES_BLEND, CP_CAVES1, SP_SMOKE, false)
	set_next_playback(P_ORIGIN, CAVES_BLEND, CP_CAVES1, SP_SPARK, false)
	set_next_playback(P_ORIGIN, CAVES_BLEND, CP_CAVES1, SP_SHADOW, false)
	set_next_playback(P_ORIGIN, CAVES_BLEND, CP_CAVES1, SP_TEMPLE, false)

func _blend(_type: int) -> bool:
	ost_preferences[_type]
	return Def.byte(_type, 9) < randi_range(0, 100)

func determine_track() -> int:
	return -0
	
func funish_theme() -> void:
	pass





extends Node

@onready var type: Node = $type

var device: Dictionary = {
	"name": get_first_gamepad_name(),
	"type": KeyAndButtonEscapes.PAD.XBOX
}

func is_gamepad_connected() -> bool:
	return Input.get_connected_joypads().size() > 0

func get_first_gamepad_name() -> String:
	return Input.get_joy_name(0).to_lower()

func coop() -> void: pass # get_connected_joypads()
func determine(event: InputEvent) -> bool:
	if not (event is InputEventJoypadButton or event is InputEventJoypadMotion):
		return false
		
	device.name = get_first_gamepad_name()
	if device.name != "":
		device.type = type.get_gamepad_type()
		return true
	return false



extends Node

var types: Array[Array] = [["ps"], ["xbox"], ["xinput", "nintendo", "stk"]]
var found: bool = false

func determine_model(model: Array, device: String) -> void:
	var no: int = model.size()
	while no > 0 and not found:
		no -= 1 # print(size.x, ", ", size.y, ", ", type[size.x][size.y])
		found = device.contains(model[no])

func determine_type(type: int, device: String) -> int:
	while type > 0 and not found:
		type -= 1 # print("Device: ", device)
		determine_model(types[type], device)
	return type

func get_gamepad_type(device: String) -> KeyAndButtonEscapes.PAD:
	found = false
	return (determine_type(types.size(), device)
		if found else KeyAndButtonEscapes.PAD.XBOX)



extends Node

class_name KeyAndButtonEscapes

@onready var mouse: Node = $mouse
@onready var keyboard: Node = $keyboard
@onready var gamepad: Node = $gamepad

func _ready() -> void:
	for i in [mouse, keyboard, gamepad]:
		i.keys = self
		i.defaults = keyboard

enum PAD { XBOX = 0, PS = 1, NINTENDO = 2 }

var pad: Dictionary = {
	PAD.PS: {
		"BTX": "BRT", "BTY": "BTR", "BTA": "BCR", "BTB": "BCL",
		"BLB": "BL1", "BRB": "BR1", "BLT": "BL2", "BRT": "BR2"
	},
	PAD.NINTENDO: {
		"BTX": "BTY", "BTY": "BTX", "BTA": "BTB", "BTB": "BTA",
		"BLB": "BL1", "BRB": "BR1", "BLT": "BL2", "BRT": "BR2"
	}
}

var sticks: Dictionary = {
	"BLS": [JOY_AXIS_LEFT_X, JOY_AXIS_LEFT_Y],
	"BRS": [JOY_AXIS_RIGHT_X, JOY_AXIS_RIGHT_Y]
}

var mouses: Dictionary = {
	MOUSE_BUTTON_LEFT: "LMB", MOUSE_BUTTON_RIGHT: "RMB", MOUSE_BUTTON_WHEEL_DOWN: "WDN",
	MOUSE_BUTTON_WHEEL_UP: "WUP", MOUSE_BUTTON_WHEEL_LEFT: "WLT", MOUSE_BUTTON_WHEEL_RIGHT: "WRT"
}

var escapes: Dictionary = {
	KEY_LEFT: "KAL", KEY_RIGHT: "KAR", KEY_DOWN: "KAD", KEY_UP: "KAU",
	KEY_SHIFT: "KSH", KEY_BACKSPACE: "BSP", KEY_TAB: "TAB", KEY_NUMLOCK: "KNL",
	KEY_SPACE: "KSP", KEY_ESCAPE: "KEC", KEY_INSERT: "KIN", KEY_DELETE: "KDL",
	KEY_PRINT: "KPS", KEY_CAPSLOCK: "KCL", KEY_PAUSE: "KPB", KEY_PAGEUP: "KPU",
	KEY_PAGEDOWN: "KPD", KEY_HOME: "KHM", KEY_END: "KED", KEY_KP_PERIOD: "KGM",
	KEY_KP_DIVIDE: "KGD", KEY_KP_ADD: "KGA", KEY_KP_SUBTRACT: "KGS",
	JOY_BUTTON_DPAD_LEFT: "KAL", JOY_BUTTON_DPAD_UP: "KAU",
	JOY_BUTTON_DPAD_RIGHT: "KAR", JOY_BUTTON_DPAD_DOWN: "KAD",
	JOY_BUTTON_A: "BTA", JOY_BUTTON_B: "BTB", JOY_BUTTON_X: "BTX", JOY_BUTTON_Y: "BTY",
	JOY_AXIS_TRIGGER_LEFT: "BLT", JOY_AXIS_TRIGGER_RIGHT: "BRT",
	JOY_BUTTON_LEFT_SHOULDER: "BLB", JOY_BUTTON_RIGHT_SHOULDER: "BRB",
}


"""
extends ActionsControl

func get_escapes() -> Dictionary: return keys.mouses

func new_controls(act: String) -> void:
	var event := InputEventMouseButton.new()
	event.button_index = actions[act]
	event.pressed = true
	_set_event(act, event)

func set_mask() -> ActionsControl:
	return m("CF", [[ACT.UI_LMB]]).m("AY", [[ACT.UI_LMB]])

func _ready() -> void:
	super._ready()
	actions = {
		a(ACT.HANDS): [MOUSE_BUTTON_LEFT],
		a(ACT.LEGS): [MOUSE_BUTTON_RIGHT],
		a(ACT.SKILL_ONE): [MOUSE_BUTTON_WHEEL_DOWN],
		a(ACT.SKILL_TWO): [MOUSE_BUTTON_WHEEL_UP],
		a(ACT.MOVEMENT): [MOUSE_BUTTON_LEFT],
		a(ACT.FIRE): [MOUSE_BUTTON_RIGHT, MOUSE_BUTTON_LEFT],
		a(ACT.UI_LMB): [MOUSE_BUTTON_LEFT]
		#, # a.GD: MOUSE_BUTTON_LEFT, # a.GT: MOUSE_BUTTON_LEFT,
	}
"""



class_name ActionsControl extends Node

var keys: Node
var defaults: Node
var word: String
var actions: Dictionary
var escapes: Dictionary: get = get_escapes

func get_escapes() -> Dictionary: return keys.escapes
func _set_event(act: String, event: InputEvent) -> void:
	InputMap.action_erase_event(act, event)
	InputMap.action_add_event(act, event)

func set_action(caption: String, keys: Array) -> void:
	actions[caption] = keys

func a(no: int) -> String: return _act[no]

func translate_word(key: int) -> bool:
	if not escapes.has(key):
		word = OS.get_keycode_string(key)
		return false
	word = tr("S" + escapes[key])
	return true

func translate_sentence(act: Array, s: bool = false) -> Array[String]:
	var sentence: Array[String] = []
	for i in act:
		if i == Def.INT:
			word = "_"
		else:
			translate_word(i if s else actions[a(i)])
		sentence.append(word)
	return sentence

func translate(acts: Array, sep: String, s: bool = false) -> Array[String]:
	var result: Array[String] = []
	for act in acts: result.append(sep.join(translate_sentence(act, s)))
	return result

func translate_alt(acts: Array) -> Array[String]: return translate_sentence(acts, true)
func translate_agg(acts: Array) -> Array[String]: return translate(acts, "", true)
func translate_all(acts: Array) -> Array[String]: return translate(acts, " + ", true)

func masked_translate(hint: String, sep: String) -> Array[String]:
	if mask.has(hint): return translate(mask[hint], sep)
	if defaults.has(hint): return defaults[hint]
	return Def.ARRAY

func masked_agg(hint: String) -> Array[String]: return masked_translate(hint, "")
func masked_all(hint: String) -> Array[String]: return masked_translate(hint, " + ")

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




extends Node

@onready var keys: Node = $keys
@onready var determine: Node = $determine
@onready var manage: Node = $manage




extends Node

@onready var mode: Node = $mode
@onready var mouse: Node = $mouse
@onready var keyboard: Node = $keyboard
@onready var gamepad: Node = $gamepad

func _input(event: InputEvent) -> void:
	if mode.type.listen():
		mode.manage(get(mode.device.named), event)


extends Node

var manage: Node

func c(e: InputEvent) -> int: return e.button_index

func add_mouse(event: InputEvent) -> void:
	if event is InputEventMouseMotion: return
	
	if event.pressed:
		manage.mode.input.append(c(event))
		manage.mode.input.enter()
	else:
		manage.mode.input.finish()

func hot(event: InputEvent) -> void: add_mouse(event)




extends Node

var input: Node

func c(e: InputEvent) -> int: return e.keycode

func delete(drop: Callable) -> void:
	if input.store.masked():
		input.delete_last()
	else:
		drop.call()

func complete(check: String) -> void:
	if input.store.get(check).call():
		input.stop_operating()
	else:
		input.finish()

func all(event: InputEvent) -> void:
	if input.locked or not input.got_hotkey(event, false):
		input.add() ; input.enter()

func add(event: InputEvent) -> void:
	if event.is_pressed() and not input.store.limit():
		input.start_enter()
		input.enter()

func add_key(code: int, check: Callable, count: String) -> Callable:
	return func(): if check.call(code): input.add_key(code, count) # print("INPUT A KEY!!")

func aggregate_next(code: int) -> Callable:
	return func(): input.enter_next(code)

func _form(check: String, next: Callable, drop: Callable) -> Dictionary:
	return { "add": next, "drop": drop, "check": check }

func alternate(event: InputEvent, key: String, count: String = "MAX", default: String = "nullify") -> Dictionary:
	return _form("is_mask", add_key(c(event), input.store.get(key), count), input.get(default))

func aggregate(event: InputEvent) -> Dictionary:
	return _form("undefined", aggregate_next(c(event)), input.clear_last)




extends Node

@onready var sequence: Node = $sequence

func one_key(event: InputEvent) -> void:
	if event.keycode in sequence.hardcoded():
		sequence.manage.mode.clear()
	else:
		sequence.manage.finish([event.keycode])

func add_keys(event: InputEvent, op: Dictionary) -> void:
	print("KEYCODE: ", event.keycode, " - Is: ", event.keycode == KEY_BACKSPACE)
	match event.keycode:
		KEY_BACKSPACE: sequence.delete(op.defaulting)
		KEY_ESCAPE: sequence.clear_keys()
		KEY_ENTER: sequence.complete(op.check)
		_: op.add.call()

func _alt(state: bool, event: InputEvent, type: String, count: String = "MAX", default: String = "nullify") -> void:
	if state: add_keys(event, sequence.alternate(event, "key_" + type, count, default))

func _agg(state: bool, event: InputEvent) -> void:
	if state: add_keys(event, sequence.aggregate(event))

func _lock() -> bool:
	sequence.input.locked = true
	return true

func _all(event: InputEvent) -> void:
	if sequence.input.got_hotkey(event): return
	if sequence.input.hotkeys(event.keycode): return
	
	var state: bool = not sequence.input.store.present(event.keycode, true)
	_alt(state, event, "hold", "key_mask", "delete_last")

func alternate(event: InputEvent) -> void:
	_alt(sequence.input.store.unique(event), event, "alt")

func hot(event: InputEvent) -> void:
	if event.is_pressed():
		_alt(not sequence.input.store.present(event.keycode), event, "press")
	else:
		sequence.input.finish()

func aggregate(event: InputEvent) -> void:
	match event.keycode:
		KEY_COMMA: sequence.add(event)
		_: _agg(sequence.input.store.unique(event, true), event)

func all(event: InputEvent) -> void:
	match event.keycode:
		KEY_BACKSPACE: if event.is_pressed(): sequence.input.remove_last()
		KEY_COMMA: if event.is_pressed(): sequence.all(event)
		KEY_ENTER: pass
		_: _all(event)



extends Node

@onready var button: Node = $button

func c(e: InputEvent) -> int: return e.button_index

func one_key(_d, event: InputEvent) -> void:
	if event is InputEventJoypadMotion:
		button.finish(button.from_axis(event))
	else:
		button.finish([c(event)])

func hot(_d, event: InputEvent) -> void:
	if event is InputEventJoypadButton:
		button.add_buttons(event.pressed, c(event))
	else:
		button.add_buttons(event.axis_value != 0, button.from_axis(event))
		
func aggregate(event: InputEvent) -> void:
	if event is InputEventJoypadMotion and button.all_axis(event): return
	if event.pressed: button.add_buttons(button.completed(), c(event))


extends Node

var manage: Node

enum { S = -1, E = 1, MAX = 4 }

func c(e: InputEvent) -> int: return e.axis

func completed() -> bool:
	return manage.next.size() < MAX

func finish(buttons: Array) -> void:
	manage.finish(buttons)

func add_buttons(state: bool, button: Variant) -> void:
	if state:
		manage.next.append(button)
	else:
		finish(manage.next)

func from_axis(event: InputEventJoypadMotion) -> Array:
	return [c(event), event.axis_value]

func add_ax(axis: int, value: int) -> Node:
	manage.next.append([axis, value])
	return self

func add_axs(x: int, y: int) -> void:
	add_ax(x, S).add_ax(y, S).add_ax(x, E).add_ax(y, E)

func auto_ax(event: InputEvent, ax: Array) -> void:
	for a in ax: if c(event) in ax:
		add_axs(a[0], a[1]); return

func all_axis(event: InputEvent) -> bool:
	manage.next.clear()
	auto_ax(event, [
		[JOY_AXIS_LEFT_X, JOY_AXIS_LEFT_Y],
		[JOY_AXIS_RIGHT_X, JOY_AXIS_RIGHT_Y]
	])
	manage.finish(manage.next)
	return true



extends Node

enum { MOUSE = 0, KEYBOARD = 1, GAMEPAD = 2 }

const names: Array[String] = ["mouse", "keyboard", "gamepad"]
const types: Array[int] = [MOUSE, KEYBOARD, GAMEPAD]

var device: int = KEYBOARD
var named: String:
	get: return names[device]

func set_as(machine: int) -> void: device = machine

func check(event: InputEvent) -> bool:
	match device:
		MOUSE: return not event is InputEventMouseButton and not event is InputEventMouseMotion
		GAMEPAD: return not event is InputEventMouseButton and not event is InputEventJoypadMotion
	return not event is InputEventKey



extends Node

var next: Array = []
var last: Variant:
	get: return next.back()
var agg: int:
	get: return next.size() - 1

enum { RESET = 0, SINGLE = 1, MAX = 3 } # SINGLE = 1, # const RESET: int = 0

func hardcoded() -> Array: # prevents users from binding keys
	return [KEY_ESCAPE, KEY_ENTER, KEY_BACKSPACE, KEY_COMMA, KEY_0, KEY_1, KEY_2,
		KEY_3, KEY_4, KEY_5, KEY_6, KEY_7, KEY_8, KEY_9]

func nullify_agg() -> void: last.fill(Def.INT)
func nullify() -> void: sets(next, RESET, Def.INT)
func sets(element: Array, no: int, code: int) -> void: element[no] = code

func present(code: int, deep: bool = false) -> bool: return code in (last if deep else next)
func defined() -> bool: return not undefined()
func undefined() -> bool: return Def.INT in last
func is_mask() -> bool: return last == Def.INT

func remove() -> void: next.pop_back()
func clear() -> void: next.clear()
func shorten() -> void: last.clear()

func add_last(unit: Variant) -> void: last.push_back(unit)
func add_next(unit: Variant) -> void:
	next.push_back(unit)
	agg = next.size() - 1

func compare(to: int) -> bool: return next.size() == to
func empty() -> bool: return compare(RESET)
func limit() -> bool: return compare(MAX)
func masked() -> bool: return next.size() > SINGLE

func is_hard(code: bool) -> bool: return code in hardcoded()
func key_hold(code: int) -> bool: return not is_hard(code) or not empty()
func key_alt(_code: int) -> bool: return not limit()
func key_press(code: int) -> bool: return key_hold(code) and key_alt(code)

func unique(e: InputEvent, deep: bool = false) -> bool:
	return e.is_pressed() and not present(e.keycode, deep)

func append(unit: Variant, mode: Node) -> void:
	if mode.input.link.is_deep(unit): # and not empty():
		add_next(unit)
	elif mode.type.deep():
		add_last(unit)
	else:
		add_next(unit)




extends Node

@onready var store: Node = $store
@onready var link: Node = $link

var key_mask: int = 1
var locked: bool = false
var place: int:
	get: return min(get_place(store.last, Def.INT), key_mask - 1)
var MAX: int:
	get: return store.MAX

const SINGLE: int = 1

func get_place(s: Array, n: int) -> int: return s.size() - s.count(n)
func next_key(state: String, op: Callable) -> void:
	if store.get(state).call():
		op.call()

func start_enter() -> void: next_key("defined", add_mask)
func enter_next(code: int) -> void: next_key("undefined", link.store_keys(code))

func clear() -> void: store.clear() ; enter()
func stop_operating() -> void: store.clear(); link.clear()

func _remove_unit() -> void: if not store.masked(): store.remove()
func _remove_after_mask() -> void: if not store.empty(): store.remove()
func remove_last() -> void:
	_remove_unit() ; store.shorten() ; enter()
	locked = false

func nullify() -> void: store.nullify()
func delete_last() -> void:
	store.remove() ; clear_last() ; enter()

func agg(type: Node) -> int:
	print("GROUP PLACE: ", place)
	return place if type.aggregated_mask() else store.agg

func _remove_deep() -> void:
	if link.is_shallow(store.last):
		store.shorten()
	else:
		_remove_after_mask()

func nullify_group() -> void:
	store.nullify_agg() ; enter()

func clear_last() -> void:
	if key_mask == SINGLE:
		_remove_deep()
	else:
		nullify_group()

func lock(state: bool) -> bool:
	locked = state
	return true

func add_key(code: int, maximum: String) -> void:
	append(code) ; get("finish" if store.compare(get(maximum)) else "enter").call()

func append(unit: Variant) -> void: store.append(unit, link.mode)
func add() -> void: append([])
func add_mask() -> void: append(link.form(key_mask))

func enter() -> void: link.enter(store.next)
func finish() -> void: link.finish(store.next) ; stop_operating()
func interrupt() -> void: link.interrupt() ; stop_operating()

func hotkeys(code: int) -> bool:
	return not locked or store.is_hard(code) and lock(true)

func got_hotkey(event: InputEvent, state: bool = true) -> bool:
	return not event.is_pressed() and lock(state)

func mask(keys: int, type: Node) -> void:
	key_mask = keys
	match type.selected:
		type.AGG: add_mask() # if keys != SINGLE
		type.ALL: add()
	enter()


extends Node

signal finish_combo(keys: Array[String])
signal enter_keys(keys: Array[String])
signal interrupt_input()

var option: String = ""
var mode: Node
var store: Node:
	get: return mode.input.store

func clear() -> void: mode.type.clear()
func interrupt() -> void:
	if option != "":
		interrupt_input.emit()

func form(count: int) -> Array:
	var unit: Array = []
	unit.resize(count)
	unit.fill(Def.INT)
	return unit

func store_code(element: Array, code: int) -> void:
	store.sets(element, mode.input.place, code)

func store_next(code: int) -> void:
	store.sets(store, store.next, code)

func store_last(code: int) -> void:
	store_code(store.last, code)
	enter(store.next)

func enter(codes: Array, input: Signal = enter_keys) -> void:
	input.emit(mode.translate(codes))

func finish(codes: Array) -> void: enter(codes, finish_combo)

func is_deep(unit: Variant) -> bool: return unit is Array # not empty() and last is Array and not  - PUT before

func store_keys(code: int) -> Callable:
	return func():
		if is_deep(store.last):
			store_last(code)
		else:
			store_next(code)




extends Node

@onready var device: Node = $device
@onready var input: Node = $input
@onready var type: Node = $type

var keys: Node
var buttons: Node:
	get: return keys.get(device.named)
var aggregate: Array = Def.ARRAY

func select(caption: String, mask: int = input.DEFAULT) -> void:
	mask = type.mask(caption, mask)
	type.select(type.get(caption))
	input.mask(mask, type)

func footer_status(footer: Button, text: String) -> void:
	if aggregate == Def.ARRAY:
		footer.input_button(text)
	else:
		footer.input_button(text, aggregate[input.agg(type)].text)

func manage(machine: Node, event: InputEvent) -> void:
	if not device.check(event):
		type.manage(machine, event)

func translate(sequence: Array) -> Array:
	return type.translate(keys.get(device.named), sequence)

func interrupts(set_finish_title: Callable) -> void:
	input.link.interrupt_input.connect(set_finish_title)

func connects(enter: Callable, controls: Callable) -> void:
	input.link.enter_keys.connect(enter)
	input.link.finish_combo.connect(controls)

func _ready() -> void: input.link.mode = self




extends Node

signal start_input()
signal interrupt_input()

enum { NONE = 0, KEY = 1, ALT = 2, HOT = 3, AGG = 4, ALL = 5 }

var selected: int = NONE
var separator: String:
	get: return " + " if selected == HOT else ", "

func mask(caption: String, keys: int) -> int:
	if get(caption) == AGG and keys == KEY: return AGG
	if get(caption) in [HOT, ALT]: return KEY
	return keys

func listen() -> bool: return selected != NONE

func clear() -> void:
	selected = NONE
	interrupt_input.emit()

func select(value: int) -> void:
	selected = value
	start_input.emit()

func aggregated_mask() -> bool: return selected == AGG
func deep() -> bool: return selected in [AGG, ALL]

func manage(type: Node, event: InputEvent) -> void:
	match selected:
		KEY: type.one_key(event)
		ALT: type.alternate(event)
		HOT: type.hot(event)
		AGG: type.aggregate(event)
		ALL: type.all(event)

func translate(device: Node, sequence: Array) -> Array:
	match selected:
		AGG: return device.translate_agg(sequence)
		ALL: return device.translate_all(sequence)
	return device.translate_alt(sequence)




## SOUND

extends Node

@onready var settings: Node = $settings
@onready var options: Node = $options
@onready var setup: Node = $setup

func set_soundtrack(detector: VBoxContainer) -> void:
	settings.set_info(detector.settings.info, setup)
	settings.set_tabs(detector.settings.tabs, options)
	setup.set_soundtrack(options, detector)



extends Node

@onready var importer: Node = $importer
@onready var exporter: Node = $exporter

func set_info(info: VBoxContainer, setup: Node) -> void:
	info.reset.pressed.connect(setup.reset)
	info.exporter.pressed.connect(exporter.exporting)
	info.importer.pressed.connect(importer.importing)
	importer.setup.connect(setup.reimport)

func set_tabs(tabs: VBoxContainer, options: Node) -> void:
	for o in [tabs.play, tabs.edit]: # TODO SET TABS
		o.pressed.connect(options.ost.switch_mode)


extends Node

@onready var operation: Node = $operation
@onready var drop: Node = $drop
@onready var add: Node = $add
@onready var search: Node = $search
@onready var play: Node = $play
@onready var ost: Node = $ost

var ui: Dictionary

func op(key: String, entry: Dictionary, leaf: Control) -> void:
	operation.get("set_" + key + "_theme").call(self, entry, leaf)

func set_leaf_theme(e: Dictionary, l: Control) -> void: op("leaf", e, l)
func set_ambient_theme(e: Dictionary, l: Control) -> void: op("ambient", e, l)
func set_named_theme(e: Dictionary, l: Control) -> void: op("named", e, l)
func set_standalone(e: Dictionary, l: Control) -> void: op("standalone", e, l)
func set_blend_theme(e: Dictionary, l: Control) -> void: op("blend", e, l)
func set_theme_context(theme: OpenThemeDialog) -> void:
	add.context = theme
	search.theme = theme

func set_operations(menu: VBoxContainer) -> void:
	set_theme_context($theme)
	ost.setup_modes(self, menu)
	# play.set_menu_context(menu) # TODO FIXME SET MENU CONTEXT

func setup() -> void:
	ost.setup(self)
	play.set_ost(ost)




extends Node

@onready var behavior: BehaviorTree = $behavior
@onready var board: BehaviorBlackboard = $blackboard
@onready var branch: Node = $branch

var _ui: VBoxContainer
var _options: Node

func selection(query: TreeOST) -> void:
	board.set_value("query", query)
	behavior.tick(self, board)

func enumerate(query: TreeOST) -> void:
	for key in query.context:
		selection(query.copy().select(key))

func setup() -> void:
	if SoundtrackSystem.is_valid("music"):
		var query: TreeOST = TreeOST.new()
		var user: Dictionary = SoundtrackSystem.user.music
		var copy: Dictionary = SoundtrackSystem.copy.music
		query.set_data(user, copy)
		query.set_ui(_ui.dropdown)
		query.set_ui_tree(_options.ui)
		enumerate(query)
		_options.setup()

func _reload() -> void:
	for leaf in _ui.dropdown.get_children():
		_ui.dropdown.remove_child(leaf)
		leaf.queue_free()
	setup()

func reset() -> void:
	SoundtrackSystem.reset()
	_reload()

func reimport() -> void:
	SoundtrackSystem.reimport()
	_reload()

func set_soundtrack(options: Node, ui: VBoxContainer) -> void:
	_options = options
	_ui = ui
	setup()
	if SoundtrackSystem.is_valid("music"):
		options.set_operations(_ui)


extends SountrackBranchBehavior

func condition(data: Variant) -> bool:
	return data is Array and data.size() > 0 and data[0] is bool

func branch(mark: Tick) -> int:
	var query = mark.blackboard.get_value("query")
	print("Alarm: ", query.caption)
	mark.actor.branch.set_alarm(query)
	return OK



extends BehaviorAction

func exist(mark: Tick) -> bool:
	var context: Variant = mark.blackboard.get_value("query").context
	return context.has("set")

func tick(mark: Tick) -> int:
	return OK if exist(mark) else FAILED




extends BehaviorAction

func tick(mark: Tick) -> int:
	var query = mark.blackboard.get_value("query")
	return OK if query.context.set is Array else FAILED




extends SountrackBranchBehavior

func condition(data: Variant) -> bool:
	return data.set.size() > 0 and data.set[0] is Dictionary

func branch(mark: Tick) -> int:
	var query = mark.blackboard.get_value("query")
	print("Combat: ", query.caption)
	mark.actor.branch.set_combat(query)
	return OK





extends BehaviorAction

func branch(mark: Tick) -> int:
	var query = mark.blackboard.get_value("query")
	print("Themes: ", query.caption)
	mark.actor.branch.set_themes(query)
	return OK

func tick(mark: Tick) -> int:
	return branch(mark)






extends SountrackBranchBehavior

func condition(data: Variant) -> bool:
	return data.set is Dictionary and data.mix is float

func branch(mark: Tick) -> int:
	var query = mark.blackboard.get_value("query")
	print("Blend: ", query.caption)
	mark.actor.branch.set_blend(query)
	return OK





extends SountrackBranchBehavior

func condition(data: Variant) -> bool:
	return data is Dictionary and data.values()[0] is String

func branch(mark: Tick) -> int:
	var query = mark.blackboard.get_value("query")
	print("Named: ", query.caption)
	mark.actor.branch.set_named(query)
	return OK





extends SountrackBranchBehavior

func condition(data: Variant) -> bool:
	return data.has("type") and data.has("name")

func branch(mark: Tick) -> int:
	var query = mark.blackboard.get_value("query")
	print("Trunk: ", query.caption)
	mark.actor.branch.set_trunks(mark.actor, query)
	return OK





extends BehaviorAction

func tick(mark: Tick) -> int:
	var query = mark.blackboard.get_value("query")
	print("Branch: ", query.caption)
	mark.actor.branch.set_branch(mark.actor, query)
	return OK





extends Node

@onready var leafs: Node = $leafs
@onready var ui: Node = $ui

func set_blend(query: TreeOST) -> void:
	leafs.set_blend(query, ui.blend)
	leafs.include(query, ui.named, leafs.set_titled, "set", {})

func set_trunks(setup: Node, query: TreeOST) -> void:
	leafs.set_child(query, ui.trunk)
	setup.selection(query.copy("right").nest_full().select("type"))
	setup.selection(query.copy("left").nest_body().select("name"))

func set_branch(setup: Node, query: TreeOST) -> void:
	leafs.set_child(query, ui.branch[query.pad])
	setup.enumerate(query.nest_body())

func set_alarm(query: TreeOST) -> void:
	leafs.set_alarm(query, ui.alarm)

func set_named(query: TreeOST) -> void:
	leafs.include(query, ui.named, leafs.set_titled, "", {})

func set_themes(query: TreeOST) -> void:
	leafs.set_mix(query, ui.mix)
	leafs.include(query.nest_body(), ui.theme, leafs.set_theme, "set", [])

func set_combat(query: TreeOST) -> void:
	leafs.set_mix(query, ui.mix)
	leafs.include(query.nest_body(), ui.fight, leafs.set_fight, "set", [])







extends Node

func append_child(query: TreeOST, child, recurse: bool = false) -> Control:
	var branch: Control = child.instantiate()
	query.add_child(branch, recurse)
	return branch

func set_child(query: TreeOST, child) -> Control:
	var caption: String = query.caption
	var branch: Control = append_child(query, child, true)
	branch.name = caption
	branch.caption = caption
	return branch

func set_theme(query, child, _tracks, track) -> void:
	var branch: Control = append_child(query, child)
	branch.set_metadata(track)
	query.ui_tree.set.push_back(branch)

func set_fight(query, child, _tracks, track) -> void:
	var branch: Control = append_child(query, child)
	for status in track:
		var theme: String = track[status].track if track[status] is Dictionary else track[status]
		branch.content[status].set_metadata(theme)
	query.ui_tree.set.push_back(branch)

func set_titled(query, child, tracks, track) -> void:
	var branch: Control = append_child(query, child)
	branch.set_metadata(tracks[track])
	branch.set_title(track)
	query.ui_tree.set[track] = branch

func set_mix(query, child) -> void:
	var branch: Control = set_child(query, child[query.pad])
	#branch.set_metadata(mix)
	branch.connect_mix(query.context)
	# query.set_ui(branch.content.themes.body)

func set_blend(query, child) -> void:
	var branch: Control = set_child(query, child[query.pad])
	#branch.set_metadata(mix)
	branch.connect_mix(query.context)
	query.set_ui(branch.content.themes.body)

func set_alarm(query: TreeOST, child) -> void:
	var branch: Control = append_child(query, child)
	branch.set_metadata(query.context)
	query.ui_tree.set = branch

func include(query, child, setter, list, init) -> void:
	var tracks: Variant = query.context if list == "" else query.decide(list)
	query.ui_tree.set = init
	for track in tracks:
		setter.call(query, child, tracks, track)




class_name SoundtrackUI extends RefCounted

var theme: PackedScene = preload("res://pre/ui/ost/leaf/leaf.tscn")
var fight: PackedScene = preload("res://pre/ui/ost/leaf/combat.tscn")
var alarm: PackedScene = preload("res://pre/ui/ost/leaf/alarm.tscn")
var named: PackedScene = preload("res://pre/ui/ost/leaf/named.tscn")

var trunk: PackedScene = preload("res://pre/ui/ost/trunk.tscn")
var branch: PackedScene = preload("res://pre/ui/ost/branch.tscn")
var blend: PackedScene = preload("res://pre/ui/ost/blend.tscn")
var mix: PackedScene = preload("res://pre/ui/ost/mix.tscn")





extends Node

signal no_manifest(file: String)
signal setup()

@onready var open: OpenPresetDialog = $open
@onready var _reader: ZIPReader = ZIPReader.new()

func _from_path(folder: DirAccess, file: String) -> String:
	return folder.get_current_dir().path_join(file)

func _set_one(folder: DirAccess, path: String) -> void:
	folder.make_dir_recursive(_from_path(folder, path).get_base_dir())
	var file: FileAccess = FileAccess.open(_from_path(folder, path), FileAccess.WRITE)
	file.store_buffer(_reader.read_file(path))

func _copy_files() -> void:
	var user: DirAccess = DirAccess.open("user://")
	for file in _reader.get_files():
		var path: String = file.replace("user://", "")
		if path.ends_with("/"):
			user.make_dir_recursive(path)
		else:
			_set_one(user, path)
	setup.emit()

func _extract(path: String) -> void:
	print("IMPORTING")
	var manifest: String = "music.json"
	
	_reader.open(path)
	if _reader.file_exists(manifest):
		_copy_files()
	else:
		print("NO MANIFEST!")
		no_manifest.emit(manifest)
	
	_reader.close()

func importing():
	open.show_dialog(_extract)



class_name ExportOST extends SoundtrackQuery

var result: Variant
var path: String

func set_user(user: Dictionary) -> void:
	_user = user

func set_path(file: String) -> void:
	path = file

func copy() -> ExportOST:
	var query = ExportOST.new()
	query.set_user(_user)#.duplicate())
	query.set_path(path)
	query.result = result# .duplicate()
	return query
	#return self

func get_path(track: String) -> String:
	return "user://" + path + track.substr(track.rfind("/") + 1) #  + "/"

func set_alarm() -> ExportOST:
	result[caption] = []
	result = result[caption]
	return self

func set_branch() -> ExportOST:
	result[caption] = {}
	result = result[caption]
	return self

func select(branch: String) -> ExportOST:
	_user = _user[branch]
	path += branch + "/"
	caption = branch
	return self

@onready var _writer: ZIPPacker = ZIPPacker.new()

func manifest(result: Dictionary) -> void:
	print("RESULT: ", result)
	var real: String = JSON.stringify(result, "\t")
	print("REAL: ", real)
	_writer.start_file("music.json")
	_writer.write_file(real.to_utf8_buffer())
	_writer.close_file()

func write(source: String, destination: String) -> void:
	print("WRITING: ", source, " + ", destination)
#	"""
	if FileAccess.file_exists(source):
		print("FILE EXISTS!!!")
		var file: FileAccess = FileAccess.open(source, FileAccess.READ)
		_writer.start_file(destination.replace("user://", ""))
		_writer.write_file(file.get_buffer(file.get_length()))
		_writer.close_file()
		file.close()

func start_write(path: String) -> int:
	return _writer.open(path)

func stop_write() -> void:
	_writer.close()

func append(query: ExportOST, from: Array, to: Array, i: int) -> void:
	to.push_back(query.get_path(from[i]))
	write(from[i], to[i])

func insert(query: ExportOST, from: Dictionary, to: Dictionary, key: String) -> void:
	to[key] = query.get_path(from[key])
	write(from[key], to[key])

func iterate(query: ExportOST, feedback: Callable) -> void:
	query.result.mix = query.context.mix
	query.result.set = []
	var i: int = 0
	while i < query.context.set.size():
		feedback.call(i)
		i += 1



func set_trunks(exporter: Node, query: ExportOST) -> void:
	exporter.selection(query.set_branch().copy().select("type"))#.set_branch())
	exporter.selection(query.copy().select("name"))#.set_branch())

func set_branch(exporter: Node, query: ExportOST) -> void:
	exporter.enumerate(query.set_branch())

func set_alarm(query: ExportOST) -> void:
	var i: int = 1
	query.set_alarm()
	query.result.push_back(query.context[0])
	query.result.push_back(query.get_path(query.context[i]))
	zip.write(query.context[i], query.result[i])

func set_blend(query: ExportOST) -> void:
	query.set_branch()
	query.result.mix = query.context.mix
	query.result.set = {}
	for key in query.context.set:
		zip.insert(query, query.context.set, query.result.set, key)

func set_named(query: ExportOST) -> void:
	query.set_branch()
	for key in query.context:
		zip.insert(query, query.context, query.result, key)

func set_themes(query: ExportOST) -> void:
	query.set_branch()
	zip.iterate(query, func(i: int):
		zip.append(query, query.context.set, query.result.set, i))

func set_combat(query: ExportOST) -> void:
	query.set_branch()
	zip.iterate(query, func(i: int):
		var from: Dictionary = query.context.set[i]
		var to: Dictionary = {}
		query.result.set.push_front(to)
		for status in from: zip.insert(query, from, to, status))



@onready var save: SavePresetDialog = $save
@onready var behavior: BehaviorTree = $behavior
@onready var board: BehaviorBlackboard = $board
@onready var branch: Node = $branch

func selection(query: ExportOST) -> void:
	board.set_value("query", query)
	behavior.tick(self, board)

func enumerate(query: ExportOST) -> void:
	for key in query.context:
		selection(query.copy().select(key))

func _export(path: String) -> void:
	if branch.zip.start_write(path) == OK:
		var query: ExportOST = ExportOST.new()
		query.result = {}
		query.set_user(SoundtrackSystem.user.music)
		query.set_path("")
		enumerate(query)
		branch.zip.manifest(query.result)
		branch.zip.stop_write()

func exporting() -> void:
	save.show_dialog(_export)



extends RefCounted

class_name SoundtrackQuery

var _user: Variant
var caption: String = "initial"

var context: Variant:
	get: return _user



class_name SountrackBranchBehavior

func condition(_data: Variant) -> bool: return true
func branch(_mark: Tick) -> int: return OK

func tick(mark: Tick) -> int:
	if condition(mark.blackboard.get_value("query").context):
		return branch(mark)
	return FAILED





extends SoundtrackQuery

class_name TreeOST

const PATH: String = "res://asset/resource/media/ost/manifest.json"

var _copy: Variant
var ui_tree: Dictionary
var _ui: Control
var pad: String = "left"

func decide(key: String) -> Variant:
	return _user[key] if _user.has(key) else _copy[key]

func set_ui(ui: Control) -> void: _ui = ui

func set_ui_tree(ui: Dictionary) -> void: ui_tree = ui

func set_data(user: Dictionary, original: Dictionary) -> void:
	_user = user
	_copy = original

func add_child(element: Control, recurse: bool = false) -> void:
	_ui.add_child(element)
	if recurse:
		set_ui(element)

func copy(branch: String = pad) -> TreeOST:
	var query = TreeOST.new()
	query.set_data(_user, _copy)
	query.set_ui(_ui)
	query.set_ui_tree(ui_tree)
	query.pad = branch
	return query

func nest_full() -> TreeOST:
	return nest_head().nest_body()

func nest_head() -> TreeOST:
	_ui = _ui.content.head
	return self

func nest_body() -> TreeOST:
	_ui = _ui.content.body
	return self

func select(branch: String) -> TreeOST:
	_user = decide(branch)
	_copy = _copy[branch]
	ui_tree[branch] = {}
	ui_tree = ui_tree[branch]
	caption = branch
	return self





extends Node

enum { DROP = 0, ADD = 1, SET = 2, PLAY = 3 }

var _type: int = -1
var type: int:
	get: return _type
	set(value): _type = value

func set_type(i: int) -> void: type = i

func set_leaf_theme(options: Node, entry: Dictionary, leaf: Control) -> void:
	leaf.pressed.connect(func():
		match type:
			DROP: options.drop.from_theme(entry, leaf)
			ADD: options.add.to_theme(options, entry, leaf)
			SET: options.search.for_theme(entry, leaf)
			PLAY: options.play.as_theme(entry, leaf)
	)

func set_ambient_theme(options: Node, entry: Dictionary, leaf: Control) -> void:
	for status in leaf.content:
		leaf.content[status].pressed.connect(func():
			match type:
				DROP: options.drop.from_theme(entry, leaf)
				ADD: options.add.to_ambient(options, entry, leaf)
				SET: options.search.for_ambient(entry, status, leaf)
				PLAY: options.play.as_ambient(entry, status, leaf)
		)

func set_named_theme(options: Node, entry: Dictionary, leaf: Control) -> void:
	leaf.set_feedback(func():
		match type:
			SET: options.search.for_named(entry, leaf)
			PLAY: options.play.as_named(entry, leaf)
	)

func set_standalone_theme(options: Node, entry: Dictionary, leaf: Control) -> void:
	leaf.set_feedback(func():
		match type:
			SET: options.search.for_standalone(entry, leaf)
			PLAY: options.play.as_named(entry, leaf)
	)

func set_blend_theme(options: Node, entry: Dictionary, leaf: Control) -> void:
	leaf.set_feedback(func():
		match type:
			SET: options.search.for_blend(entry, leaf)
			PLAY: options.play.as_blend(entry, leaf)
	)


var theme: OpenThemeDialog

func _theme_select(feedback: Callable) -> void:
	theme.show_dialog(func(track: String):
		SoundtrackSystem.save = true
		feedback.call(track)
	)

func for_theme(entry: Dictionary, ui: Control) -> void:
	_theme_select(func(track: String):
		entry.ui.set[ui.i].set_metadata(track)
		entry.theme.set[ui.i] = track
	)

func for_named(entry: Dictionary, ui: Control) -> void:
	_theme_select(func(track: String):
		var event: String = ui.event.name
		entry.ui.set[event].set_metadata(track)
		entry.theme[event] = track
	)

func for_standalone(entry: Dictionary, ui: Control) -> void:
	_theme_select(func(track: String):
		entry.ui.set.set_track_metadata(track)
		entry.theme[1] = track
	)

func for_blend(entry: Dictionary, ui: Control) -> void:
	_theme_select(func(track: String):
		var event: String = ui.event.name
		entry.ui.set[event].set_metadata(track)
		entry.theme.set[event] = track
	)

func for_ambient(entry: Dictionary, status: String, ui: Control) -> void:
	_theme_select(func(track: String):
		entry.ui.set[ui.i].content[status].set_metadata(track)
		entry.theme.set[ui.i][status] = track
	)


func from_theme(entry: Dictionary, ui: Control) -> void:
	SoundtrackSystem.save = true
	var themes: Array = entry.theme.set
	if themes.size() > 1:
		var i: int = ui.i
		var branch: Control = ui.get_parent()
		entry.ui.set.remove_at(i)
		themes.remove_at(i)
		var j: int = themes.size()
		while j > i:
			j -= 1
			entry.ui.set[j].i = j
		branch.remove_child(ui)



var context: OpenThemeDialog

func _add_leaf(entry: Dictionary, kind: Resource, ui: Control) -> Control:
	SoundtrackSystem.save = true
	var list: Array = entry.ui.set
	var leaf: Control = kind.instantiate()
	var i: int = ui.i + 1
	ui.add_sibling(leaf)
	list.insert(i, leaf)
	leaf.i = i
	i = list.size()
	while i > leaf.i:
		i -= 1
		list[i].i = i
	return leaf

func _get_ambient() -> Dictionary:
	var track: String = context.result_file
	return { "ambient": track, "heating": track, "rampage": track }

func to_theme(options: Node, entry: Dictionary, ui: Control) -> void:
	var leaf: Control = _add_leaf(entry, HUD.ost.ui.theme, ui)
	entry.theme.set.insert(leaf.i, context.result_file)
	options.set_leaf_theme(entry, leaf)

func to_ambient(options: Node, entry: Dictionary, ui: Control) -> void:
	var leaf: Control = _add_leaf(entry, HUD.ost.ui.fight, ui)
	entry.theme.set.insert(leaf.i, _get_ambient())
	options.set_ambient_theme(entry, leaf)







extends BehaviorBlackboard

signal progress(value: int)

enum { START = 0, RAMPAGE = 6 } #var _rampage: int = 0 #const LEVEL: int = 4

func reset() -> void:
	s("level", true).s("level_type", START).s("level_name", START)
	s("level_rampage", START).s("rampage", START).s("event", START)
	# set_value("level_event", Vector2i(0, 0)) - TODO level events support
	# x = store first event * LEVEL, y = + rest events
	update_progress()

func update_progress() -> void:
	var event: int = g("event") * RAMPAGE
	var value: int = event + g("rampage") + g("level_rampage")
	progress.emit(value)


signal playback(status: String)

@onready var player: AudioStreamPlayer = $player
@onready var behavior: BehaviorTree = $behavior
@onready var board: BehaviorBlackboard = $blackboard
@onready var change: Node = $change

var started = false

func set_playback(status: String) -> void: playback.emit(status)

func set_menu_context(menu: VBoxContainer) -> void:
	menu.options.back.pressed.connect(save_changes(menu))
	playback.connect(func(status): menu.playback.text = status)
	board.progress.connect(func(value): menu.progress.value = value)

func save_changes(menu: VBoxContainer) -> Callable:
	return func():
		started = false ; player.stop() ; board.reset()
		menu.playback.reset()
		SoundtrackSystem.save_changes()

func pause() -> void: player.stream_paused = true

func play_progress() -> void:
	behavior.tick(self, board)
	board.update_progress()

func start_play() -> void:
	if started:
		player.stream_paused = false #player.play()
	else:
		play_progress()
		started = true

func set_ost(ost: Node) -> void:
	behavior.set_ost(ost)
	board.reset()

func as_theme(entry: Dictionary, ui: Control) -> void: change.as_theme(entry, ui)
func as_named(entry: Dictionary, ui: Control) -> void: change.as_named(entry, ui)
func as_blend(entry: Dictionary, ui: Control) -> void: change.as_blend(entry, ui)
func as_ambient(entry: Dictionary, status: String, ui: Control) -> void: change.as_ambient(entry, ui, status)




var _track: String = ""
var _method: Callable

func _load_data(path: String) -> PackedByteArray:
	var file = FileAccess.open(path, FileAccess.READ)
	return file.get_buffer(file.get_length())

func _load_mp3() -> void:
	var sound: AudioStreamMP3 = AudioStreamMP3.new()
	sound.data = _load_data(_track)
	stream = sound

func _load_ogg() -> void:
	stream = AudioStreamOggVorbis.load_from_file(_track)

func _load_music() -> void:
	# print("LOAD MUSIC")
	_method.call()
	play()

func _get_extension(track: String) -> String:
	var period: int = track.rfind(".")
	return track.substr(period + 1)

func stop_timing() -> void: stop()
func start_timing() -> void: pass

func load_music(track: String) -> int:
	_track = track
	stop_timing()
	match _get_extension(track).to_lower():
		"mp3": _method = _load_mp3
		"ogg": _method = _load_ogg
		_: return ERR_BUSY
	if not FileAccess.file_exists(track):
		return FAILED
	start_timing()
	return OK



extends OSTPlayer

@onready var timing: Timer = $timer

func stop_timing() -> void:
	timing.stop()
	super.stop_timing()

func start_timing() -> void: timing.start()




var play: Node

@onready var resolve: Node = $resolve

func set_play_status(metadata: Dictionary) -> void:
	var status: String = resolve.a_status(metadata) ; print("PLAYING!")
	var track: String = resolve.an_ost(metadata.track)
	play.set_playback(resolve.get_status(track, status))

func form_ost(entry: Dictionary, ui: Control, theme: String, get_key: String) -> Dictionary:
	var key: Variant = get("_" + get_key).call(ui)
	var track: Variant = get("_from_" + theme).call(entry, key)
	return resolve.form(ui.caption, key, track)

func form_ambient(entry: Dictionary, ui: Control, status: String) -> Dictionary:
	var caption: String = ui.content[status].caption
	var track: Variant = resolve.from_set(entry, ui.i)[status]
	return resolve.form(caption, status, track)

func _theme(op: String, entry: Dictionary, ui: Control, theme: String, get_key: String) -> void:
	resolve.an_entry(op, entry, ui)
	set_play_status(form_ost(entry, ui, theme, get_key))

func _ambient(entry: Dictionary, ui: Control, status: String) -> void:
	resolve.set_rampage(play.board, status)
	resolve.select_entry(entry, ui)
	set_play_status(form_ambient(entry, ui, status))

func as_theme(entry: Dictionary, ui: Control) -> void: _theme("select", entry, ui, "set", "no")
func as_named(entry: Dictionary, ui: Control) -> void: _theme("play", entry, ui, "theme", "name")
func as_blend(entry: Dictionary, ui: Control) -> void: _theme("play", entry, ui, "set", "name")
func as_ambient(entry: Dictionary, status: String, ui: Control) -> void: _ambient(entry, ui, status)




const COMBAT: Dictionary = { "ambient": 0, "heating": 1, "rampage": 2, "absent": 3 }

func from_set(entry: Dictionary, key: Variant) -> Variant: return entry.theme.set[key]
func from_theme(entry: Dictionary, key: Variant) -> Variant: return entry.theme[key]

func no(ui) -> int: return ui.i
func name(ui) -> String: return ui.event.name

func form(status: String, key: Variant, track: String) -> Dictionary:
	var form: Dictionary = { "caption": status, "track": track }
	if key is String: form.name = key
	return key

func play_entry(board: BehaviorBlackboard, entry: Dictionary, ui: Control) -> void:
	entry.play.call(board, ui)

func select_entry(board: BehaviorBlackboard, entry: Dictionary, ui: Control) -> void:
	entry.theme.at = ui.i
	play_entry(board, entry, ui)

func an_entry(op: String, entry: Dictionary, ui: Control) -> void:
	get(op + "entry").call(entry, ui)

func an_ost(ost: Variant) -> String:
	return ost.track if ost is Dictionary else ost

func a_status(metadata: Dictionary) -> String:
	if not metadata.has("name"): return metadata.caption
	else: return metadata.name + " - " + metadata.caption

func get_status(player: AudioStreamPlayer, track: String, status: String) -> String:
	match player.load_music(track):
		OK: return status
		FAILED: return track + "? " + tr("MISS") + ": " + status
	return track + " ≠ .mp3, .ogg: " + status

func set_rampage(board: BehaviorBlackboard, status: String) -> void:
	var rampage: int = COMBAT.absent
	if COMBAT.has(status): rampage = COMBAT[status]
	board.set_value("level_rampage", rampage)




extends Node

@onready var level: Node = $level
@onready var world: Node = $world

var menu: VBoxContainer

func switch_mode() -> void: menu.switch_mode()

func setup(options: Node) -> void:
	level.setup(options)
	world.setup(options)

func _feedback(options: Node, type: int, select: Array[String]) -> Callable:
	return func():
		options.operation.set_type(type)
		options.play.get(select.front()).call()
		menu.options.get(select.back()).call()

func feedback_edit(options: Node, type: int) -> Callable:
	return _feedback(options, type, ["pause", "switch_skip"])
	
func feedback_play(options: Node) -> Callable:
	return _feedback(options, options.operation.PLAY, ["start_play", "switch_play"])

func setup_edit_mode(options: Node) -> void:
	var group: Array[Button] = menu.options.mode.edit.options
	for i in len(group):
		group[i].pressed.connect(feedback_edit(options, i))

func set_playback(options: Node, ui: HBoxContainer) -> void:
	ui.play.pressed.connect(feedback_play(options))
	ui.forward.pressed.connect(options.play.play_progress)

func setup_play_mode(options: Node) -> void:
	menu.options.play.restart.pressed.connect(options.play.board.reset)
	set_playback(options, menu.options.mode.play)

func setup_modes(options: Node, ui: VBoxContainer) -> void:
	menu = ui
	setup_edit_mode(options)
	setup_play_mode(options)



extends Node

class_name AmbientOST

@onready var typed: Node = $typed
@onready var named: Node = $named

static func get_ambient() -> Array[String]:
	return ["ambient", "heating", "rampage"]

static func get_level_types() -> Array[String]:
	return ["caves", "temple"]

static func get_level_names() -> Dictionary:
	return {
		"caves": ["origin", "smoke", "sparkling", "ghost"],
		"temple": ["mother"]
	}

func setup(options: Node) -> void:
	typed.set_ost(options)
	named.set_ost(options)



extends OSTLeaf

@onready var _types: Array[String] = AmbientOST.get_level_types()

func set_types(options: Node, theme: String, i: int, play: Callable) -> void:
	var type: String = _types[i]
	ost[theme][i] = {
		"ui": options.ui.level[type].type[theme],
		"theme": SoundtrackSystem.user.music.level[type].type[theme],
		"play": play
	}
	set_leaf(options, ost[theme][i])

func set_theme(options: Node, theme: String, play: Callable) -> void:
	ost[theme] = {}
	var i: int = _types.size()
	while i > 0:
		i -= 1
		set_types(options, theme, i, func(b, _u):
			play.call(b, i)
			b.set_value("level", true)
			b.update_progress())

func set_ost(options: Node) -> void:
	ost = {}
	var play: Callable = func(board, i):
		board.set_value("level_type", i)
	set_theme(options, "theme", play)
	play = func(board, i):
		board.set_value("level_type", i)
		board.set_value("level_rampage", 4)
	set_theme(options, "boss", play)



extends OSTLeaf

func get_playback(type: int, level: int) -> Callable:
	return func(board: BehaviorBlackboard, _ui):
		board.set_value("level", true)
		board.set_value("level_type", type)
		board.set_value("level_name", level)
		board.update_progress()

func set_names(options: Node, types: Array[String], i: int) -> void:
	var locations: Dictionary = AmbientOST.get_level_names()
	var type: String = types[i]
	var j: int = locations[type].size()
	while j > 0:
		j -= 1
		var level: String = locations[type][j]
		ost[i][j] = {
			"ui": options.ui.level[type].name[level],
			"theme": SoundtrackSystem.user.music.level[type].name[level],
			"play": get_playback(i, j)
		}
		#print("LOCATION: ", j, " & ", locations[type][j])
		set_leaf(options, ost[i][j])

func set_ost(options: Node) -> void:
	ost = {}
	var types: Array[String] = AmbientOST.get_level_types()
	var i: int = types.size()
	while i > 0:
		i -= 1
		ost[i] = {}
		set_names(options, types, i)




extends Node

@onready var typed: Node = $typed
@onready var named: Node = $named
@onready var weak: Node = $weak

func setup(options: Node) -> void:
	typed.set_ost(options)
	named.set_ost(options)
	weak.set_ost(options)


extends OSTLeaf

func set_types(options: Node, themes: Array[String], i: int) -> void:
	var theme: String = themes[i]
	ost[theme] = {
		"ui": options.ui.world[theme].type,
		"theme": SoundtrackSystem.user.music.world[theme].type,
		"play": func(board: BehaviorBlackboard, _ui):
			board.set_value("level", false)
			board.set_value("rampage", i)
			board.update_progress()
	}
	set_leaf(options, ost[theme])

func set_ost(options: Node) -> void:
	ost = {}
	var themes: Array[String] = ["ambient", "rampage", "boss"]
	var i: int = themes.size()
	while i > 0:
		i -= 1
		ost[themes[i]] = {}
		set_types(options, themes, i)
		
		

extends Node # OSTLeaf

@onready var ambient: Node = $ambient

var ost: Dictionary
var feedback: Dictionary = {
	"rampage": func(ui, options, context):
		options.set_blend_theme(context, ui),
	"boss": func(ui, options, context):
		ui.set_options(options, context)
}

func set_leaf(options: Node, context: Dictionary, theme: String) -> void:
	var ui: Dictionary = context.ui
	for event in ui.set:
		ui.set[event].event.name = event
		feedback[theme].call(ui.set[event], options, context)

func set_types(options: Node, theme: String) -> void:
	ost[theme] = {
		"ui": options.ui.world[theme].name,
		"theme": SoundtrackSystem.user.music.world[theme].name,
		"play": func(board: BehaviorBlackboard, _ui):
			board.set_value("level", false)
			board.update_progress()
	}
	set_leaf(options, ost[theme], theme)

func set_ost(options: Node) -> void:
	ambient.set_ost(options)
	ost = {}
	for theme in feedback:
		ost[theme] = {}
		set_types(options, theme)



extends Node

@onready var typed: Node = $typed
@onready var named: Node = $named

func set_ost(options: Node) -> void:
	var events: Array[String] = ["town", "scene"]
	typed.set_ost(events, options)
	named.set_ost(events, options)

extends OSTLeaf

func set_types(options: Node, event: String) -> void:
	ost[event] = {
		"ui": options.ui.world.ambient.name[event].type,
		"theme": SoundtrackSystem.user.music.world.ambient.name[event].type,
		"play": func(board: BehaviorBlackboard, _ui):
			board.set_value("level", false)
			board.update_progress()
	}
	set_leaf(options, ost[event])

func set_ost(events: Array, options: Node) -> void:
	ost = {}
	for event in events:
		ost[event] = {}
		set_types(options, event)


extends Node # OSTLeaf

var ost: Dictionary

func set_leaf(options: Node, context: Dictionary) -> void:
	var ui: Dictionary = context.ui
#	var i: int = ui.set.size()
	for event in ui.set:
#	while i > 0:
#		i -= 1
#		ui.set[i].i = i
		ui.set[event].event.name = event
		ui.set[event].set_options(options, context)

func set_types(options: Node, event: String) -> void:
	ost[event] = {
		"ui": options.ui.world.ambient.name[event].name,
		"theme": SoundtrackSystem.user.music.world.ambient.name[event].name,
		"play": func(board: BehaviorBlackboard, ui: Control):
			board.set_value("level", false)
			board.set_value("rampage", 0)
			board.set_value("event", ui.event.id)
			board.update_progress()
	}
	set_leaf(options, ost[event])

func set_ost(events: Array, options: Node) -> void:
	ost = {}
	for event in events:
		ost[event] = {}
		set_types(options, event)



extends OSTLeaf

func set_leaf(options: Node, context: Dictionary) -> void:
	var ui: Dictionary = context.ui
	# ui.set.event.name = "weak"
	ui.set.set_options(options, context)

func set_ost(options: Node) -> void:
	ost = { 
		"ui": options.ui.world.weak,
		"theme": SoundtrackSystem.user.music.world.weak,
		"play": func(_b, _u): pass
	}
	set_leaf(options, ost)




extends Node

class_name OSTLeaf

var ost: Dictionary

func set_leaf(options: Node, context: Dictionary) -> void:
	var ui: Dictionary = context.ui
	var i: int = ui.set.size()
	while i > 0:
		i -= 1
		ui.set[i].i = i
		ui.set[i].set_options(options, context)





extends BehaviorAction

func tick(mark: Tick) -> int:
	return OK if mark.blackboard.get_value("level") else FAILED

extends BehaviorSelector

func set_ost(music: Node) -> void:
	for dungeon in get_children():
		dungeon.set_ost(music)


extends BehaviorSequence

@onready var dungeon: BehaviorSelector = $dungeon

func set_ost(music: Node) -> void:
	dungeon.set_ost(music)





extends BehaviorSelector

func set_dungeons(feedback: Callable) -> void:
	for dungeon in get_children():
		feedback.call(dungeon)


extends BehaviorSequence

@onready var check: BehaviorAction = $assert
@onready var levels: BehaviorSelector = $levels

@export var type: int = 0

func _ready() -> void:
	check.type = type
	levels.set_dungeons(func(l): l.type = type)

func set_ost(music: Node) -> void:
	levels.set_dungeons(func(l): l.set_ost(music))


extends BehaviorAction

var type: int = 0

func tick(mark: Tick) -> int:
	var value = mark.blackboard.get_value("level_type")
	return OK if value == type else FAILED




extends BehaviorAction

var caption: int = 0

func tick(mark: Tick) -> int:
	var key: String = "level_name"
	return OK  if mark.blackboard.compare(key, caption) else FAILED



extends BehaviorAction

func tick(mark: Tick) -> int:
	mark.blackboard.set_value("level", false)
	mark.blackboard.set_value("rampage", 0)
	mark.actor.behavior.tick(mark.actor, mark.blackboard)
	return OK


extends BehaviorSequence

@onready var theme: BehaviorSelector = $theme

@export_category("Level")
@export var caption: int = 0
@export var boss_fight: String = ""

var type: int:
	set(value): theme.ambient.type = value

func _ready() -> void:
	$assert.caption = caption
	theme.ambient.caption = caption
	theme.boss.level_boss = boss_fight

func set_ost(music: Node) -> void:
	theme.set_ost(music)



extends BehaviorSelector

@onready var ambient: BehaviorSelector = $ambient
@onready var boss: BehaviorSequence = $boss

var boss_fight: String:
	set(value): boss.level_boss = value

func set_ost(music: Node) -> void:
	ambient.set_ost(music)
	boss.set_ost(music)



extends AmbientPlaybackAssert

var has_boss: bool = false

func compare(board: BehaviorBlackboard) -> bool:
	return has_boss and board.compare(key, rampage)

extends BehaviorSequence

class_name BossSoundtrack

const RAMPAGE: int = 3

@onready var check: BehaviorAction = $assert
@onready var theme: BehaviorSelector = $theme

var _caption: String

var level_boss: String:
	set(value):
		_caption = value
		$assert.has_boss = value != ""
		$assert.rampage = RAMPAGE

func set_ost(music: Node) -> void:
	theme.set_ost(music, _caption)

func _ready() -> void:
	theme.connect_rampage(check)




extends BehaviorSelector

@onready var named: BehaviorAction = $named
@onready var typed: BehaviorSelector = $typed

func set_ost(music: Node, caption: String) -> void:
	named.set_ost(music, caption)
	typed.set_ost(music)

func connect_rampage(check: Node) -> void:
	for action in [named, typed.level, typed.world]:
		action.progress.connect(check.add_rampage)


extends BehaviorActionPlayback

signal progress(mark: Tick)

var _caption: String

func set_ost(music: Node, caption: String) -> void:
	_caption = caption
	_ost = music.world.named.ost.boss

func set_track(mark: Tick) -> void:
	mark.actor.as_named(_ost, _ost.ui.set[_caption])

func tick(mark: Tick) -> int:
	if _caption != "" and _ost.theme.has(_caption) and _ost.theme[_caption] != "":
		set_track(mark)
		progress.emit(mark)
		# mark.actor.player.load_music(_ost[_caption])
		return OK
	return FAILED




extends BehaviorSelector

@onready var level: BehaviorAction = $level
@onready var world: BehaviorAction = $world

func set_ost(music: Node) -> void:
	level.set_ost(music)
	world.set_ost(music)


extends BehaviorActionPlayback

signal progress(mark: Tick)

var type: int = 0

func set_ost(music: Node) -> void:
	_ost = music.level.typed.ost.boss[type]

func tick(mark: Tick) -> int:
	if _ost.theme.set.size() > 0:
		var result = super.tick(mark)
		progress.emit(mark)
		#mark.actor.player.load_music(track)
		return result
	return FAILED


extends BehaviorActionPlayback

signal progress(mark: Tick)

func set_ost(music: Node) -> void:
	_ost = music.world.typed.ost.boss

func tick(mark: Tick) -> int:
	super.tick(mark)
	progress.emit(mark)
	return OK





extends BehaviorSequence

@onready var check: BehaviorAction = $assert
@onready var theme: BehaviorSelector = $theme

@export var rampage: int = 0

var type: int:
	set(value): theme.named.type = value
var caption: int:
	set(value): theme.named.caption = value

func _ready() -> void:
	theme.status = name
	check.rampage = rampage
	theme.connect_rampage(check)

func set_ost(music: Node) -> void:
	theme.set_ost(music)



extends BehaviorActionPlayback

signal progress(mark: Tick)

var type: int = 0
var caption: int = 0
var status: String

func set_ost(music: Node) -> void:
	_ost = music.level.named.ost[type][caption]
	#_ost.ui.set[0].get_node("../../head/mix").safe_connect(_ost)

func _set_track(mark: Tick) -> void:
	mark.actor.as_ambient(_ost, status, get_track())
	progress.emit(mark)

func tick(mark: Tick) -> int:
	var key: String = "level_name"
	if _ost.theme.has("mix") and _ost.theme.mix and mark.blackboard.compare(key, caption):
		# mark.actor.player.load_music(get_track(status))
		mark.blackboard.set_value(key, caption + 1)
		return super.tick(mark)
	return FAILED


extends BehaviorActionPlayback

signal progress(mark: Tick)

var type: int = 0
var status: String

func set_ost(music: Node) -> void:
	_ost = music.level.typed.ost.theme[type]
	#_ost.ui.set[0].get_node("../../head/mix").safe_connect(_ost)

func _set_track(mark: Tick) -> void:
	mark.actor.as_ambient(_ost, status, get_track())
	progress.emit(mark)


extends BehaviorActionPlayback

const MAX: int = 100

func probable(mix: int) -> bool:
	return mix != 0 and (mix == MAX or randi_range(_ost.mix, MAX) == MAX)

func _set_track(mark: Tick) -> void:
	mark.actor.player.load_music(_ost.set.ray)

func get_ost(options: Node, _progress: Dictionary) -> Dictionary:
	return {
		"ui": options.ui.world.rampage.name,
		"ost": SoundtrackSystem.user.world.rampage.name
	}

func tick(mark: Tick) -> int:
	if probable(_ost.mix):
		_set_track(mark)
		return OK
	return FAILED




extends BehaviorAction

class_name BehaviorActionPlayback

var _ost: Variant

static func get_default_progress() -> Dictionary:
	return {
		"level": { "active": false, "name": 0, "type": 0 },
		"rampage": 0, "event": 0
	}

func get_track() -> Control:
	var at: int = 0
	if _ost.theme.has("at"):
		at = _ost.theme.at
	var size: int = _ost.theme.set.size()
	if _ost.theme.mix:
		var next: int = randi_range(at, at + size - 1)
		at = (next + 1) % size
	else:
		at = (at + 1) % size
	_ost.theme.at = at
	return _ost.ui.set[at]

func _set_track(mark: Tick) -> void:
	mark.actor.as_theme(_ost, get_track())
	# mark.actor.player.load_music(get_track())

func tick(mark: Tick) -> int:
	_set_track(mark)
	return OK



extends BehaviorSelector

@onready var named: BehaviorAction = $named
@onready var typed: BehaviorAction = $typed

var status: String:
	set(value):
		named.status = value
		typed.status = value

func connect_rampage(check: BehaviorAction) -> void:
	for action in [named, typed]:
		action.progress.connect(check.add_rampage)

func set_ost(music: Node) -> void:
	named.set_ost(music)
	typed.set_ost(music)



extends BehaviorAction

class_name AmbientPlaybackAssert

var rampage: int = 0
var key: String = "level_rampage"

func compare(board: BehaviorBlackboard) -> bool:
	return board.compare(key, rampage)

func add_rampage(mark: Tick) -> void:
	mark.blackboard.set_value(key, rampage + 1)

func tick(mark: Tick) -> int:
	if compare(mark.blackboard):
		# mark.blackboard.set_value(key, rampage + 1)
		return OK
	return FAILED





extends BehaviorSelector

@onready var rampage: Array[BehaviorSequence] = [$ambient, $heating, $rampage]

var caption: int:
	set(value): set_ambient(func(a): a.caption = value)
var type: int:
	set(value): set_ambient(func(a): a.type = value)

func set_ambient(feedback: Callable) -> void:
	for status in rampage:
		feedback.call(status)

func set_ost(music: Node) -> void:
	set_ambient(func(a): a.set_ost(music))




@tool
extends BehaviorTree

@onready var level: BehaviorSequence = $location/level
@onready var world: BehaviorSelector = $location/world

func set_ost(music: Node) -> void:
	level.set_ost(music)
	world.set_ost(music)




extends BehaviorAction

const RAMPAGE: int = 1
var key: String = "rampage"

func add_rampage(mark: Tick) -> void:
	mark.blackboard.set_value(key, RAMPAGE + 1)

func tick(mark: Tick) -> int:
	return OK if mark.blackboard.compare(key, RAMPAGE) else FAILED



extends BehaviorSelector

@onready var hero: BehaviorAction = $hero
@onready var typed: BehaviorAction = $typed

func set_for(feedback: Callable) -> void:
	for action in [hero, typed]:
		feedback.call(action)

func set_ost(music: Node) -> void:
	set_for(func(a): a.set_ost(music))

func connect_rampage(check: Node) -> void:
	set_for(func(a): a.progress.connect(check.add_rampage))



extends BehaviorActionPlayback

class_name HeroBattleTheme

signal progress(mark: Tick)

enum { MIN = 0, MAX = 100 }

func set_ost(music: Node) -> void:
	_ost = music.world.named.ost.rampage

func _compare(mix: int) -> bool:
	var value: int = randi_range(MIN, MAX)
	return MIN <= value and value < mix

func probable(mix: int) -> bool:
	return mix != MIN and (mix == MAX or _compare(mix))

func tick(mark: Tick) -> int:
	if probable(_ost.theme.mix):
		#mark.actor.player.load_music(_ost.set.values().pick_random())
		#var result = super.tick(mark)
		#progress.emit(mark)
		var hero: String = ["ray", "rock"].pick_random()
		mark.actor.as_blend(_ost, _ost.ui.set[hero])
		progress.emit(mark)
		return OK
	return FAILED



extends BehaviorActionPlayback

signal progress(mark: Tick)

func set_ost(music: Node) -> void:
	_ost = music.world.typed.ost.rampage

func set_track(mark: Tick) -> void:
	mark.actor.as_theme(_ost, get_track())
	progress.emit(mark)
	#mark.actor.player.load_music(get_track())

func tick(mark: Tick) -> int:
	set_track(mark)
	return OK



extends BehaviorSequence

@onready var check: BehaviorAction = $assert
@onready var theme: BehaviorSelector = $theme

func set_ost(music: Node) -> void:
	theme.set_ost(music)

func _ready() -> void:
	theme.connect_rampage(check)




extends BehaviorSelector

func set_ost(music: Node) -> void:
	var events: Array[Node] = get_children()
	var i: int = events.size() - 1
	while i > 0:
		i -= 1
		events[i].set_ost(music, i)


class_name BehaviorLevelProgress extends BehaviorAction

static func get_dungeons() -> Array[Vector2i]:
	return [
		Vector2i(0, 0), Vector2i(0, 1), Vector2i(0, 2),
		Vector2i(0, 3), Vector2i(1, 0)
	]

func set_dungeon(board: BehaviorBlackboard, dungeon: Vector2i) -> void:
	board.set_value("level_type", dungeon.x)
	board.set_value("level_name", dungeon.y)

func set_progress(board: BehaviorBlackboard) -> void:
	var dungeons: Array[Vector2i] = get_dungeons()
	var progress: int = (board.get_value("event") + 1) % dungeons.size()
	
	set_dungeon(board, dungeons[progress])
	board.set_value("level", true)
	board.set_value("event", progress)
	board.set_value("rampage", 0)
	board.set_value("level_rampage", 0)


extends BehaviorLevelProgress

const EVENT: int = 0

func tick(mark: Tick) -> int:
	set_progress(mark.blackboard)
	mark.blackboard.set_value("event", EVENT)
	mark.actor.behavior.tick(mark.actor, mark.blackboard)
	return OK





extends BehaviorAction

func tick(mark: Tick) -> int:
	mark.blackboard.add_value("event", 1)
	return OK



extends BehaviorAction

@export var event: int = 0

func tick(mark: Tick) -> int:
	return OK if mark.blackboard.compare("event", event) else FAILED



extends BehaviorAction

signal progress(mark: Tick)

var caption: String
var _ost: Dictionary

func set_ost(music: Node, event: int) -> void:
	_ost = music.world.named.ambient.named.ost.scene
	_ost.ui.set[caption].event.id = event

func set_track(mark: Tick) -> void:
	mark.actor.as_named(_ost, _ost.ui.set[caption])

func _has_access(track: String) -> bool:
	return track != "" and FileAccess.file_exists(track)

func tick(mark: Tick) -> int:
	if _ost.theme.has(caption) and _has_access(_ost.theme[caption]):
		set_track(mark)
		progress.emit(mark)
		return OK
	return FAILED



extends BehaviorAction

signal progress(mark: Tick)

var caption: String
var _ost: Dictionary

func set_ost(music: Node, event: int) -> void:
	_ost = music.world.named.ost.boss
	_ost.ui.set[caption].event.id = event

func set_track(mark: Tick) -> void:
	mark.actor.as_named(_ost, _ost.ui.set[caption])

func _has_access(track: String) -> bool:
	return track != "" and FileAccess.file_exists(track)

func tick(mark: Tick) -> int:
	if _ost.theme.has(caption) and _has_access(_ost.theme[caption]):
		set_track(mark)
		progress.emit(mark)
		return OK
	return FAILED


extends BehaviorActionPlayback

signal progress(mark: Tick)

func set_ost(music: Node) -> void:
	_ost = music.world.typed.ost.boss

func tick(mark: Tick) -> int:
	mark.actor.as_theme(_ost, get_track())
	progress.emit(mark)
	# mark.actor.player.load_music(get_track())
	return OK




extends BehaviorActionPlayback

signal progress(mark: Tick)

func set_ost(music: Node) -> void:
	_ost = music.world.named.ambient.typed.ost.scene

func tick(mark: Tick) -> int:
	mark.actor.as_theme(_ost, get_track())
	progress.emit(mark)
	# mark.actor.player.load_music(get_track())
	return OK



extends BehaviorAction

var caption: String
var _ost: Dictionary

func set_ost(music: Node, event: int) -> void:
	var town: Dictionary = music.world.named.ambient.named.town
	town.ui.set[caption].event.id = event
	_ost = town.theme

func set_track(player: AudioStreamPlayer) -> void:
	player.load_music(_ost[caption])

func _has_access(track: String) -> bool:
	return track != "" and FileAccess.file_exists(track)

func tick(mark: Tick) -> int:
	if _ost.has(caption) and _has_access(_ost[caption]):
		set_track(mark.actor.player)
		return OK
	return FAILED




extends BehaviorActionPlayback

func set_ost(music: Node) -> void:
	_ost = music.world.named.ambient.typed.town

func tick(mark: Tick) -> int:
	mark.actor.as_theme(_ost, get_track())
	# mark.actor.player.load_music(get_track())
	return FAILED




extends BehaviorSelector

@onready var named: BehaviorAction = $named
@onready var typed: BehaviorAction = $typed

func set_ost(music: Node, event: int, caption: String) -> void:
	named.caption = caption
	named.set_ost(music, event)
	typed.set_ost(music)

func connect_rampage(check) -> void:
	for action in [named, typed]:
		action.progress.connect(check.add_rampage)



extends BehaviorSequence

@onready var check: BehaviorAction = $assert
@onready var theme: BehaviorSelector = $theme

@export var event: int = 0

func set_ost(music: Node, _event: int) -> void:
	theme.set_ost(music, _event, name)

func _ready() -> void:
	check.event = event
	theme.connect_rampage(check)




extends BehaviorLevelProgress

class_name BehaviorActionEvent

var event: int = 0
var key: String = "event"

func add_rampage(mark: Tick) -> void:
	set_progress(mark.blackboard)

func tick(mark: Tick) -> int:
	print("EVENT: ", get_parent().name)
	if mark.blackboard.compare(key, event):
		return OK
	return FAILED


extends BehaviorActionPlayback

const RAMPAGE: int = 0

func set_ost(music: Node) -> void:
	_ost = music.world.typed.ost.ambient

func tick(mark: Tick) -> int:
	var key: String = "rampage"
	if mark.blackboard.compare(key, RAMPAGE):
		mark.actor.as_theme(_ost, get_track())
		# mark.actor.player.load_music(get_track())
		mark.blackboard.set_value(key, RAMPAGE + 1)
		return OK
	return FAILED




extends BehaviorSelector

func set_ost(music: Node) -> void:
	for dungeon in get_children():
		dungeon.set_ost(music)





extends RichTextLabel

var _placeholder: String

func _ready() -> void:
	_placeholder = text

func reset() -> void:
	text = _placeholder

@onready var settings: Control = $ost/settings
@onready var options: Control = $options
@onready var playback: RichTextLabel = $playback/status
@onready var dropdown: HFlowContainer = $ost/scroll/margin/dropdown
@onready var progress: ProgressBar = $progress
@onready var soundtrack: VBoxContainer = $margin/soundtrack

func switch_mode() -> void:
	settings.tabs.switch_mode()
	options.switch_mode()


class_name OpenPresetDialog

var _feedback: Callable
var result_file: String = ""

func _ready() -> void:
	file_selected.connect(selected)

func selected(file: String) -> void:
	if FileAccess.file_exists(file):
		result_file = file
		_feedback.call(file)
	else:
		result_file = ""

func show_dialog(feedback: Callable) -> void:
	_feedback = feedback
	show()

class_name SavePresetDialog

func selected(file: String) -> void:
	result_file = file
	_feedback.call(file)



extends VBoxContainer

# @onready var music: Button = $music
# @onready var sound: Button = $sound
@onready var play: Button = $play
@onready var edit: Button = $edit

func _toggle(state: bool) -> void:
	edit.visible = !state
	play.visible = state

func switch_mode() -> void: _toggle(edit.visible)


extends VBoxContainer

@onready var reset: Button = $reset
@onready var importer: Button = $importer
@onready var exporter: Button = $exporter


extends Control

@onready var info: VBoxContainer = $info
@onready var tabs: VBoxContainer = $tabs







extends HBoxContainer

@onready var copy: Button = $copy
@onready var restart: Button = $restart

func _toggle(state: bool) -> void:
	copy.visible = !state
	restart.visible = state

func switch_mode() -> void: _toggle(copy.visible)


extends HBoxContainer

@onready var backward: Button = $backward
@onready var play: Button = $play
@onready var pause: Button = $play
@onready var forward: Button = $forward

var options: Array[Button]:
	get: return [backward, play, pause, forward]

func _toggle(state: bool) -> void:
	pause.visible = state
	play.visible = !state

func switch_skip() -> void:
	if !play.visible: _toggle(false)

func switch_play() -> void: _toggle(true)


extends HBoxContainer

@onready var edit: HBoxContainer = $edit
@onready var play: HBoxContainer = $play

func _toggle(state: bool) -> void:
	edit.visible = !state
	play.visible = state

func switch_mode() -> void: _toggle(edit.visible)



extends HBoxContainer

@onready var drop: Button = $drop
@onready var add: Button = $add
@onready var search: Button = $search

var options: Array[Button]:
	get: return [drop, add, search]



extends HBoxContainer

@onready var back: Button = $back
@onready var restart: Button = $restart



extends Control

@onready var home: HBoxContainer = $home
@onready var mode: HBoxContainer = $mode
@onready var play: HBoxContainer = $play

func switch_skip() -> void: mode.play.switch_skip()
func switch_play() -> void: mode.play.switch_play()
func switch_mode() -> void:
	mode.switch_mode()
	play.switch_mode()





@onready var short: Control = $caption/short
@onready var description: Label = $caption/margin/description

@export var path: String = "../../.."

var _ui_caption: String

var pad: Control
var content: Control

var caption: String:
	set(value):
		_ui_caption = value
		description.text = _ui_caption

func _ready() -> void:
	var title: Control = get_node(path)
	pad = title.get_node("pad")
	content = get_node("../../body")

func _toggled(toggled_on: bool) -> void:
	pad.visible = toggled_on
	content.visible = toggled_on



@onready var open: Control = $open
@onready var close: Control = $close

func set_active(expanded: bool) -> void:
	open.visible = !expanded
	close.visible = expanded




extends Button

@onready var short: Control = $caption/short
@onready var description: Label = $caption/margin/description

var _ui_caption: String

var title: Control
var pad: Control
var content: Control

var caption: String:
	set(value):
		_ui_caption = value
		description.text = value

func _ready() -> void:
	title = get_node("../../../..")
	pad = title.get_node("../pad")
	content = title.get_node("body")

func _toggled(toggled_on: bool) -> void:
	# short.set_active(toggled_on)
	pad.visible = toggled_on
	content.visible = toggled_on



class_name SoundtrackLeaf extends Button

@onready var metadata: Label = $metadata

var i: int
var caption: String = ""

func set_metadata(track: String) -> void:
	var slash: int = track.rfind("/") + 1
	var path: String = track.replace("\\", "/").substr(slash)
	var dot: int = path.rfind(".")
	caption = path.substr(0, dot)
	metadata.text = track
	text = caption

func set_track_authority(ui_track: String) -> void:
	metadata.text = ui_track
	text = ui_track + "_metadata"

func set_options(options: Node, context: Dictionary) -> void:
	options.set_leaf_theme(context, self)



extends HBoxContainer

@onready var content: Dictionary = {
	"ambient": $content/ambient,
	"heating": $content/heating,
	"rampage": $content/rampage
}

var i: int
var event: int

func set_options(options: Node, context: Dictionary) -> void:
	options.set_ambient_theme(context, self)



extends Button

@onready var caption: Label = $margin/caption

func _toggled(toggled_on: bool) -> void:
	set_metadata(toggled_on)

func set_metadata(status: bool) -> void:
	caption.text = "📢" if status else "🔇"


extends HBoxContainer

@onready var content: BoxContainer = $content

var caption: String:
	set(value): content.caption = value

func positioning(right: bool) -> void:
	if right:
		var pad: ColorRect = $pad
		pad.color = Color("85b0f7")

func connect_mix(ost: Dictionary) -> void:
	content.head.mix.safe_connect(ost)


extends VBoxContainer

@onready var head: HBoxContainer = $head
@onready var body: VBoxContainer = $body

var caption: String:
	set(value):
		head.caption = value


extends HBoxContainer

@onready var named: Button = $named

var caption: String:
	set(value):
		named.caption = value



extends Node

@onready var themes: VBoxContainer = $themes
@onready var slider: VSlider = $mix

var caption: String:
	set(value):
		themes.head.caption = value

func set_metadata(mix: int) -> void:
	slider.value = mix
	themes.head.set_metadata(mix)

func safe_connect(ost: Dictionary) -> void:
	#if not _connected:
	slider.value_changed.connect(func(s): ost.mix = s)
	slider.value = clampi(ost.mix, 0, 100)
		#button_pressed = ost.mix
		#set_metadata(ost.theme.mix)
	#	_connected = true




extends HBoxContainer

@onready var content: BoxContainer = $content

var caption: String:
	set(value): content.caption = value

func positioning(right: bool) -> void:
	if right:
		var pad: ColorRect = $pad
		pad.color = Color("85b0f7")

#func set_metadata(mix: int) -> void:
#	content.set_metadata(mix)

func connect_mix(ost: Dictionary) -> void:
	content.safe_connect(ost)



extends Button

@onready var caption: VBoxContainer = $margin/caption
@onready var slider: VSlider = get_node("../../../mix")

func _ready() -> void:
	slider.value_changed.connect(set_metadata)
	
func _toggled(toggled_on: bool) -> void:
	slider.visible = toggled_on

func set_metadata(mix: int) -> void:
	caption.status.text = str(mix)


extends VBoxContainer

@onready var status: Label = $status
@onready var mix: Label = $mix




extends HBoxContainer

@onready var named: Button = $named
@onready var mix: Button = $mix

var caption: String:
	set(value):
		named.caption = value

func set_metadata(value: int) -> void:
	mix.set_metadata(value)



extends HBoxContainer

@onready var named: Button = $named
@onready var mix: Button = $mix

var caption: String:
	set(value):
		named.caption = value

func set_metadata(value: bool) -> void:
	mix.set_metadata(value)


extends HBoxContainer

@onready var content: BoxContainer = $content

var caption: String:
	set(value):
		content.caption = value

func positioning(right: bool) -> void:
	if right:
		var pad: ColorRect = $pad
		pad.color = Color("85b0f7")

#func set_metadata(mix: bool) -> void:
#	content.set_metadata(mix)

func connect_mix(ost: Dictionary) -> void:
	content.head.mix.safe_connect(ost)


extends Node

@onready var head: BoxContainer = $head
@onready var body: BoxContainer = $body

var caption: String:
	set(value):
		head.caption = value

#func set_metadata(mix: bool) -> void:
#	head.set_metadata(mix)



extends VBoxContainer

@onready var status: Label = $status
@onready var mix: Label = $mix



extends Button

@onready var caption: VBoxContainer = $margin/caption

#var _connected: bool = false

func _toggled(toggled_on: bool) -> void:
	print("TOGGLE")
	set_metadata(toggled_on)

func safe_connect(ost: Dictionary) -> void:
	#if not _connected:
	toggled.connect(func(s): ost.mix = s)
	button_pressed = ost.mix
	#set_metadata(ost.theme.mix)
	#_connected = true

func set_metadata(status: bool) -> void:
	caption.status.text = "V" if status else "X"




extends HBoxContainer

@onready var leaf: Button = $leaf
@onready var active: Button = $active

var event: Dictionary = { "id": 0, "name": "" }

func set_track_metadata(track: String) -> void:
	leaf.set_metadata(track)

func set_metadata(track: Array) -> void:
	active.set_metadata(track[0])
	set_track_metadata(track[1])

func set_track_authority(ui_track: String) -> void:
	leaf.set_track_authority(ui_track)

func set_options(options: Node, context: Dictionary) -> void:
	options.set_standalone(context, self)

func set_feedback(feedback: Callable) -> void:
	leaf.pressed.connect(feedback)




extends SoundtrackLeaf

@onready var title: Label = $title/caption

var event: Dictionary = { "id": 0, "name": "" } # var event: String

func set_title(entity: String) -> void:
	title.text = entity

func set_options(options: Node, context: Dictionary) -> void:
	options.set_named_theme(context, self)

func set_feedback(feedback: Callable) -> void:
	pressed.connect(feedback)



extends Button

@onready var short: Control = $short

var pad: Control
var content: Control

func _ready() -> void:
	var title: Control = get_node("../../..")
	pad = title.get_node("pad")
	content = get_node("../../body")

func _toggled(toggled_on: bool) -> void:
	short.set_active(toggled_on)
	pad.visible = toggled_on
	content.visible = toggled_on
