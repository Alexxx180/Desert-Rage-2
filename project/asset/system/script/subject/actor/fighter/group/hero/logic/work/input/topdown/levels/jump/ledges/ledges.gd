extends Node

@onready var space: Node = $space
@onready var place: Node = $place

var size: int = 0
var data: Dictionary = {} # int, StaticBody2D

var _current: StaticBody2D
var pos: Vector2:
	get: return _current.get_ledge_position()
var box: CharacterBody2D:
	get: return _current.box

func _ready() -> void: space.place = place

func append(ledge: StaticBody2D) -> void:
	data[ledge.get_instance_id()] = ledge
	size += 1

func remove(ledge: StaticBody2D) -> void:
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
	print("ledges size: ", size)
	return _search(size, data.values())
