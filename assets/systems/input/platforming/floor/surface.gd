extends Node

var hero: CharacterBody2D

var floors: Array[int] = [0]
var F: int:
	get: return floors[-1]

func _at_old_floor(_body: Node2D):
	floors.pop_back()

func _at_new_floor(body: Node2D):
	floors.push_back(body.F)
	hero.processing.movement = _should_stand_at(body)

func _should_stand_at(surface: StaticBody2D) -> ProcessMode:
	if surface.name == "ledge":
		return Node.PROCESS_MODE_DISABLED
	else:
		return Node.PROCESS_MODE_INHERIT
