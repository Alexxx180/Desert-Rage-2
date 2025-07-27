extends Node

signal close_damage(points: int)

var moves: Node

func set_damage(points: int = 5) -> void:
	close_damage.emit(points)

func set_position(proportion: float) -> void:
	moves.hero.logic.processors.ui.input.movement.type.move.move(proportion)
