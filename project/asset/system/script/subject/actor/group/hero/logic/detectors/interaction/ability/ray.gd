extends Node2D

@onready var fire: Node2D = $fire

func set_direction(direction: Vector2i) -> void:
	fire.set_direction(direction)
