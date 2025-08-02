extends Node2D

@onready var top: Node2D = $top
@onready var left: Node2D = $left
@onready var right: Node2D = $right
@onready var bottom: Node2D = $bottom
@onready var caution: ShapeCast2D = $caution

func get_directions() -> Array:
	return [
		[top, Vector2(0, -1)], [bottom, Vector2(0, 1)],
		[left, Vector2(-1, 0)], [right, Vector2(1, 0)]
	]

func sync_traps() -> bool:
	var open: bool = false
	for direction in [top, left, right, bottom]:
		open = open or direction.sync_trap()
	return open

func move() -> Vector2:
	var directions: Array = get_directions()
	for motion in directions:
		if motion[0].move() and motion[0].rail():
			return motion[1]
	return Vector2.ZERO
