extends Node2D

@onready var ledges: Dictionary = {
	Vector2(0, -1): $top,
	Vector2(-1, 0): $left,
	Vector2(1, 0): $right,
	Vector2(0, 1): $bottom,
}

var _direction: Vector2 = Vector2(0, -1)

func is_colliding() -> bool:
	return ledges[_direction].is_colliding()

func set_direction(direction: Vector2i) -> void:
	_direction = direction
