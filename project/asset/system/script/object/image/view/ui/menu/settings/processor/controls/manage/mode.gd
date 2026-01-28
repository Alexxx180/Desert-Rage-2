extends Node

signal interrupt_input()
signal start_input(count: int)

enum { NONE = 0, KEY = 1, ALT = 2, HOT = 3, AGG = 4 }
enum { MOUSE = 0, KEYBOARD = 1, GAMEPAD = 2 }

const device_types: Array[String] = ["mouse", "keyboard", "gamepad"]

var key_mask: int = KEY
var selected: int = NONE
var device: int = KEYBOARD

func as_keyboard() -> void: device = KEYBOARD
func as_mouse() -> void: device = MOUSE
func as_gamepad() -> void: device = GAMEPAD

func select_type(value: int) -> void:
	selected = value
	start_input.emit(key_mask)

func clear() -> bool:
	selected = NONE
	interrupt_input.emit()
	return true

func one_key() -> void: select_type(KEY)
func alternate() -> void: select_type(ALT)
func hot() -> void: select_type(HOT)
func aggregate() -> void:
	key_mask = AGG
	select_type(AGG)
	key_mask = KEY

func check(event: InputEvent) -> bool:
	match device:
		KEYBOARD: return not event is InputEventKey
		GAMEPAD: return not (event is InputEventMouseButton or event is InputEventJoypadMotion)
	return not (event is InputEventMouseButton or event is InputEventMouseMotion)

func manage(type: Node, event: InputEvent) -> void:
	if check(event) and clear(): return
	
	var d: String = device_types[device]
	match selected:
		NONE: pass
		KEY: type.one_key(d, event)
		ALT: type.alternate(d, event)
		HOT: type.one_key(d, event)
		AGG: type.aggregate(d, event)
