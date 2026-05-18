class_name LevelRoot extends Node2D # LEVEL CONTROL 
# enum { BOOKS = 2, HOOKUPS = 4, CHATS = 6, LOGIC = 7, TRANSITION = 8, CHESTS = 9, ENEMY = 10 }
@onready var border: TileDecorator = TileDecorator.new($border)
@onready var execute: TileDecorator = TileDecorator.new($execute)
@onready var group: Node2D = $group
@onready var transition: CanvasLayer = $transition

var completed: PackedByteArray
var progress: PackedByteArray
var cluster: PackedVector2Array
var REF: Dictionary = {}
# static func items() -> Array: return [["books", BOOKS], ["chests", CHESTS], ["transition", TRANSITION], ["logic", LOGIC], ["chats", CHATS]] # func atlas(layer: String, map_coords: Vector2i) -> Vector2i: return get(layer).from_coords(map_coords).context.atlas
func _ready() -> void: group.controls(self)
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

func set_tile(coords: Vector2i, cursor: Vector2i) -> void:
	var atlas: Vector2i = border.tile(coords)
	var id: int = border.context.id
	if id == Def.EXECUTE and atlas in [Def.LEVER_OFF, Def.LEVER_ON, Def.PLATE_OFF,
		Def.PLATE_ON, Def.SOURCE_OFF, Def.SOURCE_ON, Def.PLACE]:
		progress[cursor.x] = border.context.coords
	elif id == Def.EXECUTE and atlas in [Def.U_WALL, Def.D_WALL, Def.STAND_OFF, Def.STAND_ON]:
		progress[cursor.x + cursor.y] = border.context.coords

func resize_cluster(tiles: Array[Vector2i], count: int) -> void:
	var cursor: Vector2i = Vector2i.ZERO
	for x in progress: cursor.x += x
	progress.append(count)
	for tile in tiles:
		set_tile(tile, cursor)
		cursor.y += 1

func add_tile_cluster(tag: int) -> bool:
	var tiles: Array[Vector2i] = execute.layer.get_used_cells_by_id(Def.LOGIC, Def.to8(tag))
	var count: int = tiles.size()
	if count > 0:
		resize_cluster(tiles, count)
		return true
	return false

func setup() -> void:
	# BOX PLACEMENT
	for tag in Def.MAX8: if not add_tile_cluster(tag): break
	# CHEST PLACEMENT

func switch_cluster() -> void:
	pass
