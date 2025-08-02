extends Node

var logic: Dictionary = { "trigger": {}, "connector": {}, "machine": {} }

func has_trigger(map_coords: Vector2i) -> bool:
	return logic.trigger.has(map_coords)

func setup_plate(tile: Dictionary) -> void:
	logic.trigger[tile.coords] = tile
	logic.trigger[tile.coords].count = tile.atlas.x

func setup_trigger(tile: Dictionary) -> void:
	logic.trigger[tile.coords] = tile

func _setup_machine(data: Dictionary, type: String) -> void:
	data.type = type
	logic.machine[data.coords] = data

func setup_lock(data: Dictionary) -> void:
	_setup_machine(data, "tile")

func setup_mech(data: Dictionary) -> void:
	_setup_machine(data, "mech")
