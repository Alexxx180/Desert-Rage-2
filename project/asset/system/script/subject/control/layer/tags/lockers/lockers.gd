extends Node

class_name Lockers

const SOURCE: int = 2
const EMPTY: Vector2i = Vector2i(-1, -1)

@onready var location: Node = $location
@onready var ability: Node = $ability

func set_atlas_tile(tags: TileDecorator, x: int) -> void:
	for y in range(5):
		var atlas: Vector2i = Vector2i(x, y)
		location.set_lockers(atlas, tags.busy(atlas, SOURCE))

func setup(lay: Node) -> void:
	location.setup(lay.border)
	ability.setup(lay, location.activator.trigger)

	for x in range(5): set_atlas_tile(lay.tags, x)
