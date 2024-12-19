extends Node

var short: Array[Control] = []

@onready var shortcut: Node = $shortcut

func _input(event: InputEvent):
	for hint in short:
		hint.sync_control_hint(event)

func exit_the_game() -> void: get_tree().quit()
