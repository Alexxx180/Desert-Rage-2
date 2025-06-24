extends Node2D

@onready var close: Area2D = $close

func set_direction(direction: Vector2i) -> void:
	close.set_direction(direction)
