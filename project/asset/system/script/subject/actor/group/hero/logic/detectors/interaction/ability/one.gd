extends Area2D

@export var act: String = "skill_one"
@export var distance: Vector2i = Vector2i(24, 20)

var direction: Vector2i = Vector2i.ZERO

func set_direction(dir: Vector2i) -> void:
	if not Input.is_action_pressed(act) and dir != Vector2i.ZERO:
		position = dir * distance
		direction = dir
		#print("DISTANCE: ", position)
