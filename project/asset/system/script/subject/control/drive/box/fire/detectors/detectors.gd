extends Node2D

@onready var press: Area2D = $press
@onready var fire: Area2D = $fire
@onready var slide: ShapeCast2D = $slide

func set_direction(direction: Vector2i) -> void:
	fire.set_direction(direction)
