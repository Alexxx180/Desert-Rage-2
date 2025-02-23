extends Area2D

@export var act: String = "skill_one"
@export var distance: Vector2i = Vector2i(24, 20)

func set_direction(direction: Vector2i) -> void:
	if not Input.is_action_pressed(act) and direction != Vector2i.ZERO:
		position = direction * distance
		#print("DISTANCE: ", position)
