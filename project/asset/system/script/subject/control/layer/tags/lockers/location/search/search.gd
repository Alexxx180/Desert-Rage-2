extends Node

@onready var mech: Node = $mech
@onready var atlas: Node = $atlas

var execute: TileMapLayer
var storage: Node

func setup(layer: TileMapLayer, store: Node) -> void:
	storage = store
	execute = layer
	mech.search = self
	atlas.search = self

func activate(map_coords: Vector2i) -> void:
	var activator: Dictionary = storage.logic.trigger[map_coords]
	var tag: Vector2i = activator.connector
	mech.set_tile(activator)
	mech.set_mechs(tag)
