extends Node

var close: FightRange = FightRange.new()
var zone: FightRange = FightRange.new()
# var all: FightRange = FightRange.new() - simply enemies list

func reveal_aims() -> void:
	print("REVEAL AIMS!")
	for entity in zone.area.values():
		if entity.is_in_group("enemy"):
			entity.logic.detector.fight.reveal_aim()

func hide_aims() -> void:
	for entity in zone.area.values():
		if entity.is_in_group("enemy"):
			entity.logic.detector.fight.hide_aim()
