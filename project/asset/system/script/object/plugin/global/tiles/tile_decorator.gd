extends RefCounted

class_name TileDecorator

var _layer: TileMapLayer
var _context: Dictionary
var context: Dictionary:
	get: return _context

func add_chip(node: Node, path = '.') -> TileDecorator:
	_layer.get_node(path).add_child(node)
	return self

func _init(layer: TileMapLayer) -> void:
	var no: Vector2i = Vector2i.ZERO
	_layer = layer
	_context = { "id": -1, "coords": no, "atlas": no }

func find(position: Vector2) -> Vector2i:
	return Tile.find(_layer, position)

func busy(atlas_cell: Vector2i, id: int = -1) -> Array[Vector2i]:
	return Tile.used_cells(_layer, atlas_cell, id)

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
	return self

func extract(no: int, map_coords: Vector2i = context.coords) -> Variant:
	return Tile.extract(_layer, map_coords, no)
