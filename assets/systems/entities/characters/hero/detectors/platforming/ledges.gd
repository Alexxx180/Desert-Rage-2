extends Node

const will: ProcessMode = Node.PROCESS_MODE_INHERIT
const wont: ProcessMode = Node.PROCESS_MODE_DISABLED

var hero: CharacterBody2D
var ledges: Dictionary = {}
var size: int = 0

func _update(next: int, mode: ProcessMode, surface: Callable):
	size = next
	if surface.call():
		hero.processing.platforming.process_mode = mode

func _last_surface() -> Node2D: return ledges.values()[0]

func _on_floor():
	return size == 1 and _last_surface().name != "ledge"

func append(ledge: Node2D):
	ledges[ledge.get_instance_id()] = ledge
	_update(size + 1, will, func(): return size >= 2)

func remove(ledge: Node2D):
	ledges.erase(ledge.get_instance_id())
	_update(size - 1, wont, _on_floor)
