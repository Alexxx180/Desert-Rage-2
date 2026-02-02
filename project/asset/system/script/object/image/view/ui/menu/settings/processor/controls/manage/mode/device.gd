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
