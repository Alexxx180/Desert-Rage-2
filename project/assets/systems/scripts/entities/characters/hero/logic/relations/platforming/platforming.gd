extends Node

@onready var detector: Node = $detector
@onready var processor: Node = $processor

func set_control(hero: CharacterBody2D) -> void:
	var detectors: Node2D = hero.logic.detectors
	var processors: Node = hero.logic.processors

	detector.set_control(detectors.platforming, processors)
	processor.set_control(hero, processors)
