extends Node

@onready var hero: CharacterBody2D = get_node("../..")

var platform
var direction: String

func active(): return process_mode == Node.PROCESS_MODE_INHERIT
func at(next):
	print("IS: ", "_ready" in next)
	platform = next

func _input(_event):
	for axis in ["left", "right", "forward", "backward"]:
		if Input.is_action_just_pressed(axis) and platform != null:
			print("PLATFORM? ", platform != null, " ", platform.name)
			direction = axis
			print("JUMPED")
			platform.jump(hero)
