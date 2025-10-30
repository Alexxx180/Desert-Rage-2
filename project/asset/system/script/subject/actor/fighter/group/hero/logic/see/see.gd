extends Node2D

@onready var world: Node2D = $world
@onready var levels: Node2D = $levels
@onready var fight: Node2D = $fight

var dir: Vector2i = Vector2i(0, 1)

func set_direction(direction: Vector2i) -> void:
	if direction != Vector2i.ZERO:
		dir = direction
	for area in [world, levels, fight]:
		area.set_direction(direction)
