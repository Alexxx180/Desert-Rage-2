extends Node2D

@onready var chains: Node2D = $chains
@onready var spring: Node2D = $spring
@onready var pillar: Node2D = $pillar

func set_direction(direction: Vector2i) -> void:
	pillar.set_direction(direction)
	chains.whip.set_direction(direction)
	# pillar.position = CELL * CELLS * direction
