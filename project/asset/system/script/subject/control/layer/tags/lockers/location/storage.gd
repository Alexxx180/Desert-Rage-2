extends Node

const STAND_ID: int = 3

var logic: Dictionary = { "trigger": {}, "connector": {}, "machine": {} }

func has_trigger(map_coords: Vector2i) -> bool: return logic.trigger.has(map_coords)

func unique(map_coords: Array, i: int) -> void: map_coords.remove_at(i)

func add_plate(tile: Dictionary) -> Node:
	logic.trigger[tile.coords] = tile
	logic.trigger[tile.coords].count = 0# tile.atlas.x
	return self

func add_trigger(tile: Dictionary) -> Node:
	logic.trigger[tile.coords] = tile
	return self

func _setup_machine(data: Dictionary, type: String) -> void:
	data.type = type
	logic.machine[data.coords] = data

func setup_mech(data: Dictionary) -> void: _setup_machine(data, "mech")

func add_stand(data: Dictionary) -> void:
	data.id = STAND_ID
	_setup_machine(data, "tile")

func add_gate(data: Dictionary) -> void:
	data.eraser = { "erase": false, "tile": data.atlas, "id": STAND_ID }
	add_stand(data)
