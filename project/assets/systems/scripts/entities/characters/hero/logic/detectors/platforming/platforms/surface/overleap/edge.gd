extends Area2D

const positions: Vector2 = Vector2(16, 10)

@onready var size: Vector2 = $shape.shape.size
@onready var half: Vector2 = size / 2

func set_direction(direction: Vector2):
	position = positions * direction
