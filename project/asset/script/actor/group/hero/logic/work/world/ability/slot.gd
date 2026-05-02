extends Node

class_name AbilitySlot

var aura: Node
var _act: Area2D

@export_range(0, 10, 1) var cost: int = 1

func near_map(_execute: TileMapLayer) -> void:
	_last_position = _hero.position + _act.position
	# print("HERO USING: ", _last_position)
