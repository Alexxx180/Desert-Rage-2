extends Node2D

@export var distance: Vector2i = Vector2i(48, 40)

@onready var press: Area2D = $press
@onready var transition: Area2D = $transition
@onready var pull: Node2D = $pull
@onready var act: Area2D = $act
@onready var chest: Area2D = $chest

func set_direction(direction: Vector2i) -> void:
	pull.set_direction(direction)
	act.set_direction(direction)
	if direction != Vector2i.ZERO:
		chest.position = direction * distance
