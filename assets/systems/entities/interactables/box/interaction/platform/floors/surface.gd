extends Node

@export_range(0, 2) var height: int = 1

var seat: Node
var ground: Node

var F: int:
	get: return ground.F + height

func append(surface: StaticBody2D):
	ground.at_new_floor(surface)
	seat.set_floor(F)

func remove(surface: StaticBody2D):
	ground.at_old_floor(surface)
	seat.set_floor(F)
