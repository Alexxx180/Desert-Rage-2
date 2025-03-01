extends Node2D

signal flow(pos: Vector2, tile: int)

const NONE: int = -1

var execute: TileMapLayer

@onready var detector: Array[RayCast2D] = [$forward, $left, $right, $backward]

func set_pos(pos: Vector2) -> void:
	position = pos
	# var found: bool = false
	var cell: int = NONE
	
	var tile: Dictionary
	var i: int = detector.size()
	while i > 0 and cell == NONE:
		i -= 1
		# found = detector[i].is_colliding()
		print("FLOW CHECK: ", position + detector[i].position)
		tile = Tile.from_pos(execute, position + detector[i].position)
		match tile.atlas:
			Vector2i(0, 2): cell = 0
			Vector2i(0, 3): cell = 1
	
	if cell > NONE:
		print("A CONTACT!")
		flow.emit(position + detector[i].position, cell)
	else:
		print("NOT FOUND...")
