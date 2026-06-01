class_name LevelRoot extends Node2D

@onready var border: TileDecorator = $border
@onready var execute: TileDecorator = $execute
@onready var group: Camera2D = $group

var completed: PackedByteArray
var progress: PackedByteArray
var cluster: PackedVector2Array
var entity: Array[CharacterBody2D] = []
var REF: Dictionary = {}

var points: PackedVector2Array = []
var maximum: PackedByteArray = []

func update_act(caption: String) -> Node: return Works.uploads(self, Def.health % caption, caption, REF)
func upload_act(caption: String) -> Node: return Works.uploads(self, Def.input % [caption, "input/" + caption], caption, REF)
func update_world(caption: String, path: String = caption) -> Node:
	return Works.uploads(self, Def.world % path, caption, REF)

var skills: SkillManager:
	get: return Works.loads("skills", REF, new_skill_manager)
var ability: Node:
	get: return Works.uploads(self, Def.input % ["named", "ability/ability"], "ability", REF)
var inventory: Node:
	get: return update_world("inventory")
var fight: Node:
	get: return update_world("fight")
var move: HeroMovement:
	get: return Works.loads("move", REF, new_hero_movement)
var deploy: HeroDeploy:
	get: return Works.loads("boxes", REF, new_boxes)
var boxes: Boxes:
	get: return Works.loads("boxes", REF, new_boxes)
var tile: TileCluster:
	get: return Works.loads("tile", REF, new_cluster)

func new_boxes() -> Boxes: return Boxes.new()
func new_cluster() -> TileCluster: return TileCluster.new()
func new_skill_manager() -> SkillManager: return SkillManager.new()
func new_hero_movement() -> HeroMovement: return HeroMovement.new()

func _ready() -> void:
	if execute != null:
		tile.resize_clusters()
