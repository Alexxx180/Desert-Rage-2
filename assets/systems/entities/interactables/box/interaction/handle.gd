extends Area2D

@onready var push: Node2D = $push

func set_control_entity(box: Node2D) -> void:
	push.set_control_entity(box)
