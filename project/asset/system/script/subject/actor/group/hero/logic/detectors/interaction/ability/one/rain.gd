extends Node2D

@onready var fire: Area2D = $fire
@onready var puddle: Area2D = $puddle

func set_direction(direction: Vector2i) -> void:
	fire.set_direction(direction)
	puddle.set_direction(direction)
