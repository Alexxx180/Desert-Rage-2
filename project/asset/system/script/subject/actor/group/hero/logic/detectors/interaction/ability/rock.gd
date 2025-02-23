extends Node2D

@onready var rain: Node2D = $rain

func set_direction(direction: Vector2i) -> void:
	rain.set_direction(direction)
