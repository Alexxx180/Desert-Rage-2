extends Node2D

@onready var axis_a: ShapeCast2D = $axis_a
@onready var axis_b: ShapeCast2D = $axis_b

func is_colliding() -> bool:
	return axis_a.is_colliding() and axis_b.is_colliding()
