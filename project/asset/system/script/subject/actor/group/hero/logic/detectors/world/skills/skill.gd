extends Area2D

@export var distance: Vector2i = Vector2i(24, 20)

func set_direction(direction: Vector2i) -> void:
	if not Input.is_action_pressed("action") and direction != Vector2i.ZERO:
		position = direction * distance
