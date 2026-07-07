class_name LevelRoot extends Node2D

@onready var group: Camera2D = $group
@onready var border: TileDecorator = $border

var execute: TileDecorator ; var _conductor: FlowConductor ; var _cluster: TileCluster
var _pillar: PillarChains ; var _deploy: HeroDeploy ; var _boxes: LevelBoxes
var fire: GPUParticles2D ; var rain: GPUParticles2D

var entity: Array[CharacterBody2D] = [null, null]
var tile: PackedInt32Array = [0, 0, 0, 0]

func add_chip(box: CharacterBody2D) -> void:
	add_child(box)
	box.position = HUD.level.border.get_position()

var deploy: HeroDeploy:
	get: return Def.ref(self, _deploy, &"_deploy", new_hero_deploy)
var boxes: LevelBoxes:
	get: return Def.refn(self, _boxes, &"_boxes", new_boxes)
var cluster: TileCluster:
	get: return Def.ref(self, _cluster, &"_cluster", new_cluster)
var conductor: FlowConductor:
	get: return Def.ref(self, _conductor, &"_conductor", new_conductor)
var pillar: PillarChains:
	get: return Def.ref(self, _pillar, &"_pillar", new_pillar_chains)

func plate_encounter(body: Variant) -> void: HUD.interact.plate_encounter(body)
func plate_disappear(body: Variant) -> void: HUD.interact.plate_disappear(body)
func lever_encounter(body: Variant) -> void: HUD.interact.trigger_encounter(body)
func lever_disappear(body: Variant) -> void: HUD.interact.trigger_disappear(body)

func new_pillar_chains() -> PillarChains: return PillarChains.new()
func new_conductor() -> FlowConductor: return FlowConductor.new()
func new_boxes() -> LevelBoxes: return LevelBoxes.new()
func new_cluster() -> TileCluster: return TileCluster.new()
func new_hero_deploy() -> HeroDeploy: return HeroDeploy.new()
func new_hero(no: int) -> CharacterBody2D:
	if entity[no] == null:
		var hero: CharacterBody2D = load(Def.ray if no == Def.RAY else Def.rock).instantiate()
		hero.name = &"ray" if no == Def.RAY else &"rock"
		hero.no = no
		add_child(hero)
		return hero
	return entity[no]

func load_hero(that: int) -> void:
	if entity[that] == null:
		entity[that] = new_hero(that)

func load_level() -> void:
	HUD.level = self
	if has_node(^"execute"):
		execute = get_node(^"execute")
		cluster.resize_clusters()
	# HUD.state = Bit.to1(HUD.state, Def.TRANSIT)

func _ready() -> void:
	load_level()
	load_hero(HUD.hero)
	entity[HUD.hero].position = group.position
	group.reparent(entity[HUD.hero])
	group.position = Vector2.ZERO
