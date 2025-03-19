extends Node

class_name Lockers

const SOURCE: int = 2
const EMPTY: Vector2i = Vector2i(-1, -1)

@onready var location: Node = $location
@onready var behavior: Node = $behavior

func set_atlas_tile(tags: TileDecorator, x: int) -> void:
	for y in range(5):
		var atlas: Vector2i = Vector2i(x, y)
		location.set_lockers(atlas, tags.busy(atlas))

func setup(tags: TileMapLayer, execute: TileMapLayer) -> void:
	var _tags: TileDecorator = TileDecorator.new(tags)
	location.setup(execute)
	behavior.setup(location, execute)

	for x in range(5): set_atlas_tile(_tags, x)
