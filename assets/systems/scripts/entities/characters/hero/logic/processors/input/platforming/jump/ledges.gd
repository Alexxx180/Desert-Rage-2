extends Node

var size: int = 0
var data: Dictionary = {} # int, Node2D
var ledge: Node2D

func surface(box: Node2D) -> int:
	return box.floors.get_instance_id()

func append(next: Node2D) -> void:
	print("APPEND BOX: ", next.name)
	data[surface(next)] = next.floors
	size = size + 1

func remove(previous: Node2D) -> void:
	data.erase(surface(previous))
	size = size - 1

func around(overview: Node) -> bool:
	var jump: bool = false
	var platforms: Array = data.values()
	var i: int = size
	while i > 0 and not jump:
		i = i - 1
		ledge = platforms[i]
		jump = overview.reach(ledge)
	return jump
