extends Node2D

var monitoring: bool = true
@onready var edges: Array[Node2D] = [$mid, $right, $left]

func is_colliding(motion: Vector2i) -> bool:
	return monitoring and edges[motion.y].vertices[motion.x].is_colliding()

func turn_monitoring(state: bool) -> void:
	monitoring = state
