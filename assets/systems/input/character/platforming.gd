extends Node

@onready var hero: CharacterBody2D = get_parent()

var platform: Area2D
var ground: bool = false
var directions: Array[String]
var far: int

func active(): return process_mode == Node.PROCESS_MODE_INHERIT

func coordinate(allowed: Array[String], distance: int = 128):
	directions = allowed
	far = distance

func jump():
	var x: float = Input.get_axis("left", "right")
	var y: float = Input.get_axis("forward", "backward")
	hero.position += Vector2(x, y) * far

func available_place(direction: String) -> bool:
	var jumped: bool = false
	var size: int = directions.size()
	while not jumped and size > 0:
		size -= 1
		direction = directions[size]
		jumped = Input.is_action_just_pressed(direction) or Input.is_action_pressed(direction)
	print(directions)
	print(direction, ", ", jumped)
	return jumped

func _input(_event):
	var direction: String
	if available_place(direction): jump()
