extends Node

var locks: Dictionary = { "trigger": {}, "machine": {}, "connector": {} }

func setup_plate(tile: Dictionary) -> void:
	locks.trigger[tile.coords] = tile
	locks.trigger[tile.coords].count = tile.atlas.x

func setup_trigger(tile: Dictionary) -> void:
	locks.trigger[tile.coords] = tile

func setup_lock(tile: Dictionary) -> void:
	locks.machine[tile.coords] = tile
