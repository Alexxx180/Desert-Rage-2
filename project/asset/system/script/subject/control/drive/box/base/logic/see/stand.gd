extends StaticBody2D

var box: CharacterBody2D

func get_ledge_position() -> Vector2:
	return box.position + position
