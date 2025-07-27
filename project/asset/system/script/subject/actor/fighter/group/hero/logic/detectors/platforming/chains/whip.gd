extends Node2D

@onready var directions: Dictionary = {
	Vector2i(0, -1): $top_center, Vector2i(0, 1): $bottom_center
}
@onready var jump_zone: Node2D = directions[Vector2i(0, -1)]

func set_direction(direction: Vector2) -> void:
	if direction.x == 0 and direction.y != 0:
		direction.y = clampf(direction.y, -1, 1)
		jump_zone = directions[Vector2i(direction)]
