extends Node

@onready var space: Node = $space
@onready var place: Node = $place

var size: int = 0
var data: Dictionary = {} # int, Area2D

var _current: Area2D
var pos: Area2D:
	get: return _current.get_ledge_position()

func _ready() -> void:
	space.place_decide = place.decide

func append(ledge: Area2D) -> void:
	data[ledge.get_instance_id()] = ledge
	size += 1

func remove(ledge: Area2D) -> void:
	data.erase(ledge.get_instance_id())
	size -= 1

func _search(count: int, platforms: Array) -> bool:
	var jump: bool = false
	while count > 0 and not jump:
		count -= 1
		_current = platforms[count]
		jump = space.reach(_current)
	return jump

func around() -> bool:
	return _search(size, data.values())
