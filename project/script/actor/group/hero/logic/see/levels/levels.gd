extends Node2D

@onready var platform: Node2D = $platform
@onready var tools = $tools
# enum { CELL = 64, CELLS = 5 }
func set_direction(direct: Vector2i) -> void:
	if direct != Vector2i.ZERO:
		platform.direction = direct
		tools.set_direction(direct)
