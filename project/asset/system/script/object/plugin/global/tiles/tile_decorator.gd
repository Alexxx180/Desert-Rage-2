extends RefCounted

class_name TileDecorator

var _layer: TileMapLayer
var _context: Dictionary
var context: Dictionary:
	get: return _context
	set(value):
		_context.id = value.id
		_context.coords = value.coords
		_context.atlas = value.atlas
var no: Vector2i:
	get: return Vector2i.ZERO

func add_chip(node: Node, path = '.') -> TileDecorator:
	_layer.get_node(path).add_child(node)
	return self

func _init(layer: TileMapLayer, coords: Vector2i = no, atlas: Vector2i = no, id: int = -1) -> void:
	_layer = layer
	_context = { "id": id, "coords": coords, "atlas": atlas }

func get_pos(map_coords: Vector2i) -> Vector2:
	return Tile.get_pos(_layer, map_coords)

func find(position: Vector2) -> Vector2i:
	return Tile.find(_layer, position)

func busy(tile: Vector2i = _context.atlas, id: int = _context.id) -> Array[Vector2i]:
	return Tile.used_cells(_layer, tile, id)

func atlas_coords(map_coords: Vector2i) -> Vector2i:
	return Tile.atlas_coords(_layer, map_coords)

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
	Tile.paint(_layer, cell)
	return self

func erase(map_coords: Vector2i = context.coords) -> TileDecorator:
	_layer.erase_cell(map_coords)
	return self

func basis(map_coords: Vector2i) -> Dictionary:
	return Tile.basis(_layer, map_coords)

func from_coords(map_coords: Vector2i) -> TileDecorator:
	context = Tile.from_coords(_layer, map_coords)
	return self

func from_pos(pos: Vector2) -> TileDecorator:
	context = Tile.from_pos(_layer, pos)
	_context.pos = pos
	return self

func extract(number: int, map_coords: Vector2i = context.coords) -> Variant:
	return Tile.extract(_layer, map_coords, number)
