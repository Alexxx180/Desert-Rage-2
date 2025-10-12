extends Node

@onready var storage: Node = $storage
@onready var search: Node = $search
@onready var activator: Node = $activator

var PLATE: Dictionary = { "OFF": Vector2i(4, 1), "ON": Vector2i(5, 1) }
var LEVER: Dictionary = { "OFF": Vector2i(4, 3), "ON": Vector2i(5, 3) }
var STAND: Dictionary = { "OFF": Vector2i(0, 2), "ON": Vector2i(1, 2) }
var GATE: Dictionary = { "A": Vector2i(3, 0), "B": Vector2i(3, 1) }

func setup(border: TileDecorator) -> void:
	search.setup(border, storage)
	activator.set_location(self)

func set_lockers(tag: Vector2i, map_coords: Array[Vector2i]) -> void:
	var i: int = map_coords.size() ; print("TAG: ", tag)
	while i > 0:
		i -= 1
		var tile: Dictionary = search.atlas.get_atlas(map_coords[i], tag)
		tile.offset = Vector2i(1, 0)
		match tile.atlas:
			PLATE.OFF, PLATE.ON: storage.add_plate(tile).unique(map_coords, i)
			LEVER.OFF, LEVER.ON, FlowConductor.TILE.SOURCE.OFF:
				if tile.atlas == FlowConductor.TILE.SOURCE.OFF:
					print("tile: ", tile, " - coords: ", map_coords[i])
				storage.add_trigger(tile).unique(map_coords, i)
			STAND.OFF, STAND.ON: storage.add_stand(tile)
			GATE.A, GATE.B: storage.add_gate(tile)
	storage.logic.connector[tag] = map_coords
