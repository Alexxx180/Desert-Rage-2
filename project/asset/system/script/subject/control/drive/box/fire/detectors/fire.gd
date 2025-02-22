extends Node2D

@export var distance: Vector2i = Vector2i(32, 20)

func set_direction(direction: Vector2i) -> void:
	if direction != Vector2i.ZERO:
		position = direction * distance
