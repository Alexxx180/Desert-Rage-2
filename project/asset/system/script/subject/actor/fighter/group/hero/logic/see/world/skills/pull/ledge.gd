extends RayCast2D

@onready var left: RayCast2D = $left
@onready var right: RayCast2D = $right

@onready var ledges: Dictionary = {
	Vector2(0, -1): self, Vector2(-1, -1): left,
	Vector2(-1, 0): left, Vector2(-1, 1): left,
	Vector2(1, 1): right, Vector2(1, -1): right,
	Vector2(1, 0): right, Vector2(0, 1): $bottom,
}

var _direction: Vector2 = Vector2(0, -1)

func are_colliding() -> bool:
	return ledges[_direction].is_colliding()

func set_direction(direction: Vector2i) -> void:
	_direction = direction
