extends Node2D

@onready var stats: Node = $stats
@onready var detectors: Node2D = $detectors
@onready var processors: Node = $processors

func set_control_entity(hero: CharacterBody2D) -> void:
	stats.size.set_control_entity(hero)
	processors.set_control_entity(hero)
