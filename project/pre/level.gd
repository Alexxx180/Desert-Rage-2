class_name LevelRoot extends Node2D

@onready var border: TileDecorator = $border
@onready var execute: TileDecorator = $execute
@onready var group: Camera2D = $group

var progress: PackedByteArray
var state: PackedInt32Array = [0, 0]
var entity: Array[CharacterBody2D] = [null, null]
var tile: PackedInt32Array = [0, 0, 0, 0]

var path: PackedVector2Array = []
var maximum: PackedByteArray = [0, 0, 0, 0]
var heroes: PackedStringArray = [Def.ray, &"ray", Def.rock, &"rock"]

func _hero(hero: int, no: int) -> int: return hero * 2 + no
func get_tile(no: int) -> int: return tile[_hero(HUD.hero, no)]
func set_tile(no: int) -> void: tile[_hero(HUD.hero, no)] = Def.ofmap(border.local_to_map(HUD.level.entity[HUD.hero].position))
func no_tile(no: int) -> void: tile[_hero(HUD.hero, no)] = 0

var skills: SkillManager:
	get: return Def.ref(self, _skills, &"_skills", new_skill_manager)
var inventory: HeroInventory:
	get: return Def.ref(self, _inventory, &"_inventory", new_hero_inventory)
var move: HeroMovement:
	get: return Def.ref(self, _move, &"move", new_hero_movement)
var deploy: HeroDeploy:
	get: return Def.ref(self, _deploy, &"_deploy", new_hero_deploy)
var boxes: Boxes:
	get: return Def.ref(self, _boxes, &"boxes", new_boxes)
var cluster: TileCluster:
	get: return Def.ref(self, _cluster, &"tile", new_cluster)
var conductor: FlowConductor:
	get: return Def.ref(self, _conductor, &"_conductor", new_conductor)

var _conductor: FlowConductor ; var _cluster: TileCluster ; var _boxes: Boxes
var _inventory: HeroInventory ; var _deploy: HeroDeploy ; var _move: HeroMovement ; var _skills: SkillManager

func new_hero_deploy() -> HeroDeploy: return HeroDeploy.new()
func new_conductor() -> FlowConductor: return FlowConductor.new()
func new_boxes() -> Boxes: return Boxes.new()
func new_cluster() -> TileCluster: return TileCluster.new()
func new_skill_manager() -> SkillManager: return SkillManager.new()
func new_hero_movement() -> HeroMovement: return HeroMovement.new()
func new_hero_inventory() -> HeroInventory: return HeroInventory.new()
func new_hero(no: int) -> CharacterBody2D:
	if entity[no] == null:
		entity[no] = load(heroes[_hero(no, 0)]).instantiate()
		entity[no].name = heroes[_hero(no, 1)]
		add_child(entity[no])
	return entity[no]

func _ready() -> void:
	HUD.level = self
	deploy.load_hero(HUD.hero)
	if execute != null: cluster.resize_clusters()
	HUD.state = Bit.to1(HUD.state, HUD.TRANSIT)
