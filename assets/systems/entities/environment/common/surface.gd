extends Node

var floors: Array[int] = [0]

var F: int:
	get: return floors[-1]

func _is_same(body: Node2D) -> bool:
	return body.get_instance_id() == get_instance_id()

func at_old_floor(body: Node2D):
	if not _is_same(body): floors.pop_back()

func at_new_floor(body: Node2D):
	#print(body.name)
	if not _is_same(body): floors.push_back(body.F)
