extends Node

@onready var movement: Node = $movement

func set_control_entity(box: StaticBody2D) -> void:
	movement.set_control(box, box.logic.processors.movement)
	box.logic.stats.size.set_control_entity(box)
