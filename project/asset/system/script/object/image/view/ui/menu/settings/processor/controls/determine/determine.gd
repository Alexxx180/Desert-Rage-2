extends Node

signal hints()

var type: String = "keyboard"
var keys: Node
var selected: Node:
	get: return keys[type]

@onready var gamepad: Node = $gamepad

func sync_hints(event: InputEvent) -> String:
	if gamepad.determine(event): return "gamepad"
	elif event is InputEventMouseButton: return "mouse"
	return "keyboard"

func _input(event: InputEvent) -> void:
	var prev: String = type
	type = sync_hints(event)
	if type != prev: hints.emit()
