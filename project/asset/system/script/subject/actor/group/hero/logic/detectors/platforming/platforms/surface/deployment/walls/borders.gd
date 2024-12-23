extends RayCast2D

const distance: int = 114

func set_direction(direction: Vector2) -> void:
	# direction * 
	target_position = direction * distance
	#if direction.x != direction.y:
	#	target_position = direction * distance
		#target_position = Vector2(sin(direction.x), sin(direction.y)) * distance
	#else:
	#	target_position = Vector2(sin(direction.x), sin(direction.y)) * distance
