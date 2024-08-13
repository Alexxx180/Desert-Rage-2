extends Node

var hero: CharacterBody2D
var data: Dictionary = {}
var size: int = 0
var platforming: Node:
	get:
		return hero.processing.platforming

func _update(next: int, mode: ProcessMode, surface: Callable):
	size = next
	if surface.call(): platforming.process_mode = mode

func append(ledge: Node2D):
	data[ledge.get_instance_id()] = ledge
	_update(size + 1, hero.will, func(): return (size >= 1 and 
		hero.detectors.platform.floor.stance.from_floor))

func remove(ledge: Node2D):
	data.erase(ledge.get_instance_id())
	_update(size - 1, hero.wont, func(): return size == 0)
