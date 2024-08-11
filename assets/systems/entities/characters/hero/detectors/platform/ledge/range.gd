extends Node2D

var ray: RayCast2D

@onready var rays: Array[Array] = [
	[null, $center/bottom, $center/top],
	[$right/center, $right/bottom, $right/top],
	[$left/center, $left/bottom, $left/top],
]

func detect_floor(direction: Vector2i) -> bool:
	assert(direction != Vector2i.ZERO)
	
	ray = rays[direction.x][direction.y]
	
	return ray.is_colliding()
