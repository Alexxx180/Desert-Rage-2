extends Node2D

@onready var movement: Node2D = $movement

func set_control_entity(box: StaticBody2D):
	box.directing.connect(movement.platforming.tracking.set_direction)
