extends Node2D

@onready var platforms: Node2D = $platforms
@onready var floors: Area2D = $floors
@onready var stand: Area2D = $stand
@onready var chains: Node2D = $chains
@onready var pillar: Node2D = $pillar
@onready var spring: Node2D = $spring

var direction: Vector2i # enum { CELL = 64, CELLS = 5 }

func set_direction(direct: Vector2i) -> void:
	floors.set_direction(direct)
	if direct != Vector2i.ZERO:
		direction = direct
		pillar.set_direction(direction)
		chains.whip.set_direction(direction)
		# pillar.position = CELL * CELLS * direction
