extends Node

@onready var border: TileDecorator = TileDecorator.new(get_node("../../border"))
@onready var execute: TileDecorator = TileDecorator.new(get_node("../../execute"))
@onready var tags: TileDecorator = TileDecorator.new(get_parent())

func atlas(layer: String, map_coords: Vector2i) -> Vector2i:
	return get(layer).from_coords(map_coords).context.atlas
