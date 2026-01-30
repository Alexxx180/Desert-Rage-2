extends Node

signal finish_combo(keys: Array[String])
signal input_a_key(keys: Array[String])
signal interrupt_input()
signal start_input(count: int)

enum { NONE = 0, KEY = 1, ALT = 2, HOT = 3, AGG = 4 }
enum { MOUSE = 0, KEYBOARD = 1, GAMEPAD = 2 }

const device_types: Array[String] = ["mouse", "keyboard", "gamepad"]

var keys: Node
var selected: int = NONE
var device: int = KEYBOARD
var device_name: String:
	get: return device_types[device]
var separator: String:
	get: return " + " if selected == HOT else ", "

func as_device(machine: int) -> void: device = machine
func is_setting() -> bool: return selected != NONE

func select_type(value: int, key_mask = KEY) -> void:
	selected = value
	start_input.emit(key_mask)

func clear() -> void:
	selected = NONE
	interrupt_input.emit()

func one_key() -> void: select_type(KEY)
func alternate() -> void: select_type(ALT)
func hot() -> void: select_type(HOT)
func aggregate() -> void: select_type(AGG, AGG)

func check(event: InputEvent) -> bool:
	match device:
		KEYBOARD: return not event is InputEventKey
		GAMEPAD: return not (event is InputEventMouseButton or event is InputEventJoypadMotion)
	return not (event is InputEventMouseButton or event is InputEventMouseMotion)

func manage(type: Node, event: InputEvent) -> void:
	if check(event): return
	match selected:
		KEY: type.one_key(event)
		ALT: type.alternate(event)
		HOT: type.hot(event)
		AGG: type.aggregate(event)

func translate(sequence: Array) -> void:
	var d: Node = keys.get(device_name)
	match selected:
		AGG: return d.translate_agg(sequence)
	return d.translate_alt(sequence)
