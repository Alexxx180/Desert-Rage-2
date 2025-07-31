extends Node2D

@onready var top: Node2D = $top
@onready var left: Node2D = $left
@onready var right: Node2D = $right
@onready var bottom: Node2D = $bottom

func get_directions() -> Array:
	return [
		[top, Vector2(0, -1)], [bottom, Vector2(0, 1)],
		[left, Vector2(-1, 0)], [right, Vector2(1, 0)]
	]

func sync_traps() -> void:
	for direction in [top, left, right, bottom]:
		direction.sync_trap()

func move() -> Vector2:
	var directions: Array = get_directions()
	for motion in directions:
		if motion[0].move() and motion[0].rail():
			return motion[1]
	return Vector2.ZERO

# 004500 - 006101
