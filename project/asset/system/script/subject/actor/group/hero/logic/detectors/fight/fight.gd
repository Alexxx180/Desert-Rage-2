extends Node2D

@onready var close: Area2D = $close
@onready var music: Node2D = $music

func set_direction(direction: Vector2i) -> void:
	close.set_direction(direction)
