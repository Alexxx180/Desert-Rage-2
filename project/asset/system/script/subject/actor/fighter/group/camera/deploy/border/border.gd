extends Node2D

@onready var edges: Array[Node2D] = [$mid, $right, $left]

func is_colliding(motion: Vector2i) -> bool:
	return edges[motion.y].vertices[motion.x].is_colliding()
