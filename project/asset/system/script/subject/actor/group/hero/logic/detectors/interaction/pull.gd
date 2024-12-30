extends Area2D

@onready var shape: RectangleShape2D = $geometry.shape
@onready var size: Vector2 = shape.size

const DISTANCE: Vector2i = Vector2i(24, 20)

func set_direction(direction: Vector2i) -> void:
	if not Input.is_action_pressed("action") and direction != Vector2i.ZERO:
		position = direction * DISTANCE
