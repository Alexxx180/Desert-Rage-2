extends Node

# signal update_floor(f: int)
# @onready var tracker: SurfaceTracker = $tracker
@onready var entity: CharacterBody2D = Defaults.ENTITY

var border: TileMapLayer
var hero: CharacterBody2D # var freeze: bool = false
var F: int: get = get_floor

func get_floor() -> int:
	if entity == Defaults.ENTITY:
		return Tile.extract_at_pos(border, hero.position, Tile.FLOOR)

	return Tile.extract_at_pos(border, entity.position, Tile.FLOOR) + entity.height
