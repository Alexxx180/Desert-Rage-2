extends Node2D

@onready var pull: Node2D = $pull
@onready var press: Area2D = $press
@onready var act: Area2D = $act
@onready var transition: Area2D = $transition

func set_direction(direction: Vector2i) -> void:
	pull.set_direction(direction)
	act.set_direction(direction)
