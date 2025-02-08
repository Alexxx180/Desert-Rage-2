extends Node2D

@onready var pull: Area2D = $pull
@onready var act: Area2D = $act
@onready var transition: Area2D = $transition

func set_direction(direction: Vector2i) -> void:
	pull.set_direction(direction)
	act.set_direction(direction)
