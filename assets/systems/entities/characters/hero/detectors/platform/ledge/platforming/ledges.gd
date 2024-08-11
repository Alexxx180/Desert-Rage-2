extends Node

const will: ProcessMode = Node.PROCESS_MODE_INHERIT
const wont: ProcessMode = Node.PROCESS_MODE_DISABLED

var platforming: Node
var data: Dictionary = {}
var size: int = 0

func _update(next: int, mode: ProcessMode, surface: Callable):
	size = next
	if surface.call(): platforming.process_mode = mode

func append(ledge: Node2D):
	data[ledge.get_instance_id()] = ledge
	_update(size + 1, will, func(): return size >= 1)

func remove(ledge: Node2D):
	data.erase(ledge.get_instance_id())
	_update(size - 1, wont, func(): return size == 0)
