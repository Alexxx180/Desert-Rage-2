extends Node2D

@onready var world: Node2D = $world
@onready var platforming: Node2D = $platforming
@onready var fight: Node2D = $fight

func set_direction(direction: Vector2i) -> void:
	for area in [world, platforming, fight]:
		area.set_direction(direction)
