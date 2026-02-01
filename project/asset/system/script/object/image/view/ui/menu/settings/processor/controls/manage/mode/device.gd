extends Node

enum { MOUSE = 0, KEYBOARD = 1, GAMEPAD = 2 }

const types: Array[String] = ["mouse", "keyboard", "gamepad"]

var device: int = KEYBOARD
var named: String:
	get: return types[device]

func set_as(machine: int) -> void: device = machine

func check(event: InputEvent) -> bool:
	match device:
		MOUSE: return not event in [InputEventMouseButton, InputEventMouseMotion]
		GAMEPAD: return not event in [InputEventMouseButton, InputEventJoypadMotion]
	return not event is InputEventKey
