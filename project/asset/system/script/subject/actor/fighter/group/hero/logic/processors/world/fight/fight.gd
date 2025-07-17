extends Node

var close: FightRange = FightRange.new()

func reveal_aims() -> void:
	for enemy in close.area.values(): enemy.reveal_aim()
