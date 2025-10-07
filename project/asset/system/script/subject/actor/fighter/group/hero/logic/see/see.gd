extends Node2D

@onready var world: Node2D = $world
@onready var levels: Node2D = $levels
@onready var fight: Node2D = $fight

func set_direction(direction: Vector2i) -> void:
	for area in [world, levels, fight]:
		area.set_direction(direction)
