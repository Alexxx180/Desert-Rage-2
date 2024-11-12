extends Node

@onready var movement: Node = $movement
@onready var detectors: Node = $detectors

func set_control_entity(box: CharacterBody2D) -> void:
	movement.set_control(box, box.logic.processors.movement)
	detectors.set_control(box, box.logic.detectors)
	box.logic.stats.size.set_control_entity(box)
