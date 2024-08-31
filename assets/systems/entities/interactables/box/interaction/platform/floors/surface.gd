extends Node

@export_range(0, 2) var height: int = 1

var seat: Node
var ground: Node

var F: int:
	get: return ground.F + height

func append(surface: TileMap):
	ground.at_new_floor(surface)
	print("SET HERO FLOOR: ", F)
	seat.set_floor(F)

func remove(surface: TileMap):
	ground.at_old_floor(surface)
	seat.set_floor(F)
