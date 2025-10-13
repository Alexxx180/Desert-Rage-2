extends Node

var seat: Node
var engine: Node
var igniting: Timer

func ignite_engine() -> void:
	engine.ignite()
	igniting.start()

func compare_height(hero: CharacterBody2D) -> bool:
	return seat.compare(hero)

func check() -> void:
	engine.push()
	engine.set_ledge()
	"""
	match engine.state:
		engine.IGNITING: engine.push()
		engine.BUSY:
			engine.push()
			engine.set_ledge()
	"""
