extends Node

@onready var mech: Node = $mech
@onready var atlas: Node = $atlas

var border: TileDecorator
var storage: Node

func setup(layer: TileDecorator, store: Node) -> void:
	storage = store
	border = layer
	mech.search = self
	atlas.search = self

func activate(map_coords: Vector2i) -> void:
	var activator: Dictionary = storage.logic.trigger[map_coords]
	var tag: Vector2i = activator.connector
	mech.set_tile(activator, Vector2i(1, 0))
	mech.set_mechs(tag)
