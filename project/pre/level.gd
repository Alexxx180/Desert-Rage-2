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

var REF: Dictionary = {}

func update_act(caption: String) -> Node: return Works.uploads(self, Def.health % caption, caption, REF)
func upload_act(caption: String) -> Node: return Works.uploads(self, Def.input % [caption, "input/" + caption], caption, REF)

func update_world(caption: String, path: String = caption) -> Node:
	return Works.uploads(self, Def.world % path, caption, REF)

var topdown: Node:
	get: return upload_act("topdown")
var platformer: Node:
	get: return upload_act("platformer")
var aura: Node:
	get: return update_act("aura")
var resource: Node:
	get: return update_act("resource")
var skills: Node:
	get: return update_world("skills", "skills/skills")
var ability: Node:
	get: return Works.uploads(self, Def.input % ["named", "ability/ability"], "ability", REF)
var inventory: Node:
	get: return update_world("inventory")
var fight: Node:
	get: return update_world("fight")
