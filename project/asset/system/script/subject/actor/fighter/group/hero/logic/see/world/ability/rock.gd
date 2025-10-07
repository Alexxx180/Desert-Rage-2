extends Node2D

@onready var rain: Node2D = $rain
@onready var spark: Node2D = $spark

func set_direction(direction: Vector2i) -> void:
	rain.set_direction(direction)
	spark.set_direction(direction)
