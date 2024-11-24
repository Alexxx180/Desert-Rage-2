extends Node

var size: int = 0
var data: Dictionary = {} # int, Area2D

var _current: Area2D
var current: Area2D:
	get: return _current

func append(ledge: Area2D) -> void:
	var id: int = ledge.get_instance_id()
	data[id] = ledge
	size = size + 1

func remove(ledge: Area2D) -> void:
	var id: int = ledge.get_instance_id()
	data.erase(id)
	size = size - 1

func around(overview: Node, feet: Node) -> bool:
	var jump: bool = false
	var platforms: Array = data.values()
	var i: int = size
	while i > 0 and not jump:
		i = i - 1
		_current = platforms[i]
		print("check ledge: ", _current.name)
		jump = overview.reach(_current, feet)
	return jump
