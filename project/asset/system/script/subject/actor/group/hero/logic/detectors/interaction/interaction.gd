extends Node2D

@onready var pull: Area2D = $pull

func set_direction(direction: Vector2i) -> void:
	pull.set_direction(direction)
