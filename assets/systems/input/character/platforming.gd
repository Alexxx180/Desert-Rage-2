extends Node

@onready var hero: CharacterBody2D = get_parent()

var directions: Array[String]
var far: int

func coordinate(allowed: Array[String], distance: int = 128):
	directions = allowed
	print("SET, ", distance)
	far = distance

func jump():
	var x: float = Input.get_axis("left", "right")
	var y: float = Input.get_axis("forward", "backward")
	print("POSITION: ", far)
	hero.position += Vector2(x, y) * far
	print("JUMPED!")

func _input(_event):
	for direction in directions:
		print("JUMPED? ", direction)
		if Input.is_action_just_pressed(direction): jump()
