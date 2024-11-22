extends Node

class_name SurfaceTracker

var entity: CharacterBody2D
var contact_zone: Area2D

var _contact: Vector2 = Vector2.ZERO
var contact: Vector2:
	get: return _contact

static func get_var(map: TileMapLayer, target: Vector2, data: String, none: Variant) -> Variant:
	var cell: Vector2i = map.local_to_map(target)
	var tile: TileData = map.get_cell_tile_data(cell)
	return none if tile == null else tile.get_custom_data(data)

func set_contact(pos: Vector2) -> void:
	"""
	print("POS: ", entity.center)
	print("ZONE - X: ",  pos.x, " - Y: ", pos.y)
	print("ALL: ", entity.center + pos)
	# """
	"""
	var marker: Marker2D = Marker2D.new()
	marker.name = "1234"
	marker.position = entity.center + contact_zone.center
	entity.get_node("../..").add_child(marker)
	#"""
	_contact = entity.center + pos# entity.get_contact(dir) + pos

func track(ground: Node2D) -> Vector2:
	return entity.position + ground.position
