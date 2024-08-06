extends Node

var hero: CharacterBody2D
var ledges: Dictionary = {}
var size: int = 0

func update(next: int, ledge: Node2D, mode: ProcessMode):
	size = next
	if ledge.name == "ledge":
		hero.processing.platforming = mode

func append(ledge: Node2D):
	ledges[ledge.get_instance_id()] = ledge
	update(size + 1, ledge, Node.PROCESS_MODE_INHERIT)

	if size > 2:
		hero.processing.platforming = Node.PROCESS_MODE_INHERIT

	if ledge.name != "ledge" and size > 0:
		hero.processing.movement = Node.PROCESS_MODE_INHERIT

func remove(ledge: Node2D):
	ledges.erase(ledge.get_instance_id())
	update(size - 1, ledge, Node.PROCESS_MODE_DISABLED)

	if size == 0:
		hero.processing.platforming = Node.PROCESS_MODE_DISABLED

	if ledge.name != "ledge" and size > 0:
		hero.processing.movement = Node.PROCESS_MODE_DISABLED
