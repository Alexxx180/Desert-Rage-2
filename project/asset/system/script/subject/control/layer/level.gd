class_name LevelRoot extends Node2D # LEVEL CONTROL 

enum { BOOKS = 2, HOOKUPS = 4, CHATS = 6, LOGIC = 7, TRANSITION = 8, CHESTS = 9, ENEMY = 10 }

@onready var border: TileDecorator = TileDecorator.new($border)
@onready var execute: TileDecorator = TileDecorator.new($execute)
@onready var group: Node2D = $group
@onready var transition: CanvasLayer = $transition

static func items() -> Array:
	return [["books", BOOKS], ["chests", CHESTS], ["transition", TRANSITION],
		["logic", LOGIC], ["chats", CHATS]]

func atlas(layer: String, map_coords: Vector2i) -> Vector2i:
	return get(layer).from_coords(map_coords).context.atlas

func _ready() -> void: group.controls(self)
