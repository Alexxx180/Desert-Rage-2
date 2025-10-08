extends Node2D

@onready var directions: Dictionary = {
	Vector2i(-1, -1): $top_left, Vector2i(0, -1): $top_center,
	Vector2i(1, -1): $top_right, Vector2i(-1, 0): $left_center,
	Vector2i(1, 0): $right_center, Vector2i(-1, 1): $bottom_left,
	Vector2i(0, 1): $bottom_center, Vector2i(1, 1): $bottom_right
}
@onready var jump_zone: Node2D = directions[Vector2i(0, -1)]

func _set_jumpzone(direction: Vector2i) -> void:
	if directions.has(direction):
		jump_zone = directions[direction]

func set_direction(direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		direction.y = clampf(direction.y, -1, 1)
		_set_jumpzone(Vector2i(direction))
