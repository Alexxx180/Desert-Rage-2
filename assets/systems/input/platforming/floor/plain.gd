extends Node

var floors: Array[int] = [0]
var F: int:
	get: return floors[-1]

func _at_old_floor(_body: Node2D):
	floors.pop_back()

func _at_new_floor(body: Node2D):
	floors.push_back(body.F)
	print("HERO AT FLOOR: ", F)
