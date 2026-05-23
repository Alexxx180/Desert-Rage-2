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
var skills: SkillManager:
	get: return Works.loads("skills", REF, new_skill_manager)
var ability: Node:
	get: return Works.uploads(self, Def.input % ["named", "ability/ability"], "ability", REF)
var inventory: Node:
	get: return update_world("inventory")
var fight: Node:
	get: return update_world("fight")
var input: WorldInput:
	get: return Works.loads("input", REF, new_world_input)
var boxes: Boxes:
	get: return Works.loads("boxes", REF, new_boxes)
var tile: TileCluster:
	get: return Works.loads("tile", REF, new_cluster)

func new_boxes() -> Boxes: return Boxes.new()
func new_world_input() -> WorldInput: return WorldInput.new()
func new_cluster() -> TileCluster: return TileCluster.new()
func new_skill_manager() -> SkillManager: return SkillManager.new()

func setup() -> void:
	tile.set_types({
		"lever": border.layer.get_used_cells_by_id(Def.EXECUTE, Def.to8(Def.LEVER_OFF)),
		"button": border.layer.get_used_cells_by_id(Def.EXECUTE, Def.to8(Def.PLATE_OFF)),
		"source": border.layer.get_used_cells_by_id(Def.EXECUTE, Def.to8(Def.SOURCE_OFF))
	})
	# BOX PLACEMENT
	for tag in Def.MAX8: if not tile.resize_cluster(self, tag): break
	# CHEST PLACEMENT
