class_name LockersStorage extends RefCounted

const STAND_ID: int = 3

var logic: Dictionary = { "trigger": {}, "connector": {}, "machine": {} }
var act: Dictionary = TilesTape.new(4, 1).next(0, 2).add("PLATE").add("LEVER").from(0, 2).next(3, -2).add("STAND").on(0, 1).add("GATE").result()

func unique(map_coords: Array, i: int) -> void: map_coords.remove_at(i)
func builder(_empty: Object) -> LockersStorage: return self
func has_trigger(map_coords: Vector2i) -> bool: return logic.trigger.has(map_coords)
func set_trigger(tile: Dictionary): logic.trigger[tile.coords] = tile
func get_trigger(map_coords: Vector2i) -> Dictionary: return logic.trigger[map_coords]

func add_plate(tile: Dictionary) -> LockersStorage:
	tile.count = 0 # tile.atlas.x
	return builder(set_trigger(tile))

func add_trigger(tile: Dictionary) -> LockersStorage:
	return builder(set_trigger(tile))

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

func get_atlas(border: TileDecorator, map_coords: Vector2i, tag: Vector2i) -> Dictionary:
	var tile: Dictionary = border.from_coords(map_coords).context.duplicate()
	tile.connector = tag ; return tile

func setup(border: TileDecorator, tag: Vector2i, map_coords: Array[Vector2i]) -> void:
	for i in range(map_coords.size(), -1, -1): # print("TAG: ", tag)
		var tile: Dictionary = get_atlas(border, map_coords[i], tag)
		tile.offset = Vector2i(1, 0)
		match tile.atlas:
			act.OFF.LEVER, act.ON.LEVER, FlowConductor.SOURCE_OFF:
				add_trigger(tile).unique(map_coords, i)
			act.OFF.PLATE, act.ON.PLATE: add_plate(tile).unique(map_coords, i)
			act.OFF.STAND, act.ON.STAND: add_stand(tile)
			act.OFF.GATE, act.ON.GATE: add_gate(tile)
	logic.connector[tag] = map_coords
