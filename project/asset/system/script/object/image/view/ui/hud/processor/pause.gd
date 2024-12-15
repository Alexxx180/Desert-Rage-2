extends Node

@onready var tree = get_tree()

var paused: bool = false

var game: Control
var pause: Control

func toggle_pause() -> void:
	game.visible = !paused
	pause.visible = paused

	tree.paused = paused
