extends Node2D

@onready var x: ShapeCast2D = $x
@onready var y: ShapeCast2D = $y

func is_colliding():
	return x.is_colliding() or y.is_colliding()
