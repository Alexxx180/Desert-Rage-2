extends Node

@onready var tree = get_tree()

var paused: bool = false

var short: Array[Control] = []

var game: Control
var pause: Control

func _input(event: InputEvent):
	for hint in short:
		hint.sync_control_hint(event)

func toggle_pause() -> void:
	paused = !paused

	print("PAUSED: ", paused)

	game.visible = !paused
	pause.visible = paused

	tree.paused = paused
