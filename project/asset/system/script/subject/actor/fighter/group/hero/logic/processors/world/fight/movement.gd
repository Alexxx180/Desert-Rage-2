extends Node

var hero: CharacterBody2D
var targets: Array[CharacterBody2D] = []
var selection: int = 0

func set_target(enemy: CharacterBody2D) -> void:
	targets.append(enemy)
	# hero.enemy = enemy # targets[selection].position
	hero.logic.processors.ui.input.movement.mode.enemy = enemy
