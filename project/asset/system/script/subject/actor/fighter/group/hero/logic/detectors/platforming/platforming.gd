extends Node2D

@onready var platforms: Node2D = $platforms
@onready var floors: Area2D = $floors
@onready var stand: Area2D = $stand
@onready var chains: Node2D = $chains
@onready var pillar: Area2D = $pillar

enum { CELL = 64, CELLS = 5 }

var direction: Vector2i

func set_direction(direct: Vector2i) -> void:
	floors.set_direction(direct)
	if direct != Vector2i.ZERO:
		direction = direct
		pillar.position = CELL * CELLS * direction
