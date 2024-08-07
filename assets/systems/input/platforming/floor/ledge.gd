extends StaticBody2D

@export_range(0, 2) var height: int = 1

@onready var size: Node = get_node("../../base/size")

var pos: Vector2:
	get:
		return size.basis + position

var floors: Array[int] = [0]
var GF: int:
	get: return floors[-1]

var F: int:
	get: return GF + height

func _is_same(body: Node2D) -> bool:
	return body.get_instance_id() == get_instance_id()

func _at_old_floor(body: Node2D):
	if not _is_same(body): floors.pop_back()

func _at_new_floor(body: Node2D):
	if not _is_same(body): floors.push_back(body.F)
	print(body.name, " AT FLOOR: ", F)
