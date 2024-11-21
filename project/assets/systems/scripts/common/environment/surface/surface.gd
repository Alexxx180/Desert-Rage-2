extends Node

class_name SurfaceTracker

var entity: CharacterBody2D
var contact_zone: Area2D

var contact: Vector2:
	get: return contact_zone.center

static func get_var(map: TileMapLayer, target: Vector2, data: String, none: Variant) -> Variant:
	var cell: Vector2i = map.local_to_map(target)
	var tile: TileData = map.get_cell_tile_data(cell)
	return none if tile == null else tile.get_custom_data(data)

func track(ground: Node2D) -> Vector2:
	return entity.position + ground.position
