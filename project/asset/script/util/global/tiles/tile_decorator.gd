class_name TileDecorator extends TileMapLayer

var _context: Dictionary
var context: Dictionary:
	get: return _context
	set(value):
		_context.id = value.id
		_context.coords = value.coords
		_context.atlas = value.atlas
var logic_no: int:
	get: return Tile.logic_no(context.atlas)
var tatlas: Vector2i:
	get: return context.atlas
var tcoords: Vector2i:
	get: return context.coords

func tile(coords: Vector2) -> Vector2i: return from_coords(coords).tatlas
func tpos(pos: Vector2) -> Vector2i: return from_pos(pos).tatlas

func add_prop(key: String, value: Variant) -> TileDecorator:
	_context[key] = value
	return self

func add_chip(node: Node2D, path = '.') -> TileDecorator:
	node.position = context.pos
	get_node(path).add_child(node)
	return self

func _init(id: int = -1, coords: Vector2i = Vector2i.ZERO, atlas: Vector2i = Vector2i.ZERO) -> void:
	if is_enabled: _context = { "id": id, "coords": coords, "atlas": atlas }

func get_pos(map_coords: Vector2i) -> Vector2:
	return Tile.get_pos(self, map_coords)

func find(pos: Vector2) -> Vector2i:
	return Tile.find(self, pos)

func busy(atlas: Vector2i = _context.atlas, id: int = _context.id) -> Array[Vector2i]:
	return Tile.used_cells(self, atlas, id)

func atlas_coords(map_coords: Vector2i) -> Vector2i:
	return Tile.atlas_coords(self, map_coords)

func select(atlas: Vector2i, id: int = context.id) -> TileDecorator:
	_context.atlas = atlas
	_context.id = id
	return self

func target(map_coords: Vector2i) -> TileDecorator:
	_context.coords = map_coords
	return self

func offset(value: Vector2i) -> TileDecorator:
	_context.atlas += value
	return self

func paint(cell: Dictionary = context) -> TileDecorator:
	Tile.paint(self, cell)
	return self

func erase(map_coords: Vector2i = context.coords) -> TileDecorator:
	erase_cell(map_coords)
	return self

func basis(map_coords: Vector2i) -> Dictionary:
	return Tile.basis(self, map_coords)

func from_coords(map_coords: Vector2i, id: int = context.id) -> TileDecorator:
	context = Tile.from_coords(self, map_coords, id) # print("EXTRACT! CONTEXT: ", context.coords, " - ATLAS: ", context.atlas)
	return self

func from_pos(pos: Vector2) -> TileDecorator:
	context = Tile.from_pos(self, pos)
	_context.pos = pos
	return self

func extract(number: int, map_coords: Vector2i = context.coords) -> Variant:
	return Tile.extract(self, map_coords, number)

func extract_at_pos(pos: Vector2, number: int) -> Variant:
	return extract(number, find(pos))

func switch(to: Vector2i) -> TileDecorator:
	Tile.switch(context, to, self)
	return self
