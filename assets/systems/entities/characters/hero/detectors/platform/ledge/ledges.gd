extends Node

var data: Dictionary = {}
var size: int = 0

var ledge: Node2D
var platforming: Node
var decisions: Node

func _update(next: int, _mode: ProcessMode, _surface: Callable) -> void:
	size = next
	# if surface.call(): platforming.process_mode = mode

func append(next: Node2D) -> void:
	data[next.floors.get_instance_id()] = next.floors
	#_update(size + 1, decisions.will, func(): return size >= 1 and platforming.jump.feet.stable)
	_update(size + 1, decisions.will, func(): return size >= 1 and platforming.jump.feet.stable)

func remove(previous: Node2D) -> void:
	data.erase(previous.floors.get_instance_id())
	_update(size - 1, decisions.wont, func(): return size == 0)

func set_control_entity(hero: CharacterBody2D) -> void:
	platforming = hero.processing.platforming
	decisions = hero.processing.decisions

func around(overview: Node) -> bool:
	var jump: bool = false
	var platforms: Array = data.values()
	var i: int = size
	while i > 0 and not jump:
		i = i - 1
		ledge = platforms[i]
		jump = overview.reach(ledge)
	return jump
