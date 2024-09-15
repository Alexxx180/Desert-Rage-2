extends Node2D

@onready var stats: Node = $stats
@onready var detectors: Node2D = $detectors
@onready var processors: Node = $processors

func set_control_entity(hero: CharacterBody2D):
	stats.set_control_entity(hero)
	detectors.set_control_entity(hero)
	processors.set_control_entity(hero)

func run(delta) -> Vector2:
	return stats.run(processors.input) * delta
