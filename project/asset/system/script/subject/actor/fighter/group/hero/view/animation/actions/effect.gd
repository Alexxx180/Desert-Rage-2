extends Node

signal close_damage(points: int)

enum { POWER = 0, INFLUENCE = 1, VITALITY = 2, REACTION = 3 }

var moves: Node
var stats: Array

func set_stats(next: Array) -> void: stats = next

func set_damage(multiplier: float = 1) -> void:
	close_damage.emit(stats[POWER])# * multiplier)

func set_position(proportion: float) -> void:
	moves.hero.logic.processors.ui.input.movement.type.move.move(proportion)
