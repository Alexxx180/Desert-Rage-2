extends Node

var size: int = 0
var data: Dictionary = {} # int, Area2D

var _current: Area2D
var current: Area2D:
	get: return _current

func append(ledge: Area2D) -> void:
	data[ledge.get_instance_id()] = ledge
	size += 1

func remove(ledge: Area2D) -> void:
	data.erase(ledge.get_instance_id())
	size -= 1

func _search(overview: Node, i: int, platforms: Array) -> bool:
	var jump: bool = false
	while i > 0 and not jump:
		i = i - 1
		_current = platforms[i]
		jump = overview.reach(_current)
	return jump

func around(overview: Node, feet: Node) -> bool:
	return _search(overview, size, data.values())
