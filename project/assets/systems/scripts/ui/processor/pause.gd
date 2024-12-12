extends Node

@onready var tree = get_tree()

var game: Control
var pause: Control

func _toggle_pause(paused: bool) -> void:
	game.visible = !paused
	pause.visible = paused

	tree.paused = paused
