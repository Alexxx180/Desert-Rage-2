extends Node2D

@onready var pull: Area2D = $pull
@onready var press: Area2D = $press
@onready var act: Area2D = $act
@onready var transition: Area2D = $transition
@onready var fire: Area2D = $fire

func set_direction(direction: Vector2i) -> void:
	pull.set_direction(direction)
	act.set_direction(direction)
	fire.set_direction(direction)
