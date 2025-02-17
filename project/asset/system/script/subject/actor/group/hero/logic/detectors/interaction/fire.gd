extends Area2D

@export var distance: Vector2i = Vector2i(24, 20)

func set_direction(direction: Vector2i) -> void:
	if not Input.is_action_pressed("skill_one") and direction != Vector2i.ZERO:
		position = direction * distance
		#print("DISTANCE: ", position)
