extends Area2D

var direction: String
@export_range(0, 9) var floor: int = 0
@export_range(1, 2) var height: int = 1

func _ready(): direction = name

func compare(ledge: int) -> bool: return floor + height == ledge

func _on_step(body: Node2D):
	if body is CharacterBody2D:
		for direction in ["left", "right", "forward", "backward"]:
			if Input.is_action_just_pressed(direction): body.jump(direction)
