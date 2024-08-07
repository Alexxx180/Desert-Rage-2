extends Node

const will: ProcessMode = Node.PROCESS_MODE_INHERIT
const wont: ProcessMode = Node.PROCESS_MODE_DISABLED

var hero: CharacterBody2D
var ledges: Dictionary = {}
var size: int = 0

func update(next: int, ledge: Node2D, mode: ProcessMode, compare: Callable):
	size = next

	if compare.call(size):
		hero.processing.platforming = mode

	if ledge.name != "ledge" and size > 0:
		hero.processing.movement = mode

func append(ledge: Node2D):
	# print("APPEND, ID: ", ledge.get_instance_id(), ", NAME: ", ledge.name)
	ledges[ledge.get_instance_id()] = ledge
	update(size + 1, ledge, will, func(x): return x > 2)

func remove(ledge: Node2D):
	# print("REMOVE, ID: ", ledge.get_instance_id(), ", NAME: ", ledge.name)
	ledges.erase(ledge.get_instance_id())
	update(size - 1, ledge, wont, func(x): return x == 0)
