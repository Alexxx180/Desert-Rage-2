extends Node

signal action()
signal moving(velocity: Vector2)

@onready var movement: Node = $movement
@onready var platforming: Node = $platforming

var motion: Vector2:
	get: return Input.get_vector("left", "right", "forward", "backward")

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("action"):
		action.emit()
	moving.emit(motion)
