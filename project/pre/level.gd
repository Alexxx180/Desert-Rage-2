class_name LevelRoot extends Node2D

@onready var group: Camera2D = $group
@onready var border: TileDecorator = $border

var execute: TileDecorator ; var _conductor: FlowConductor ; var _cluster: TileCluster
var _pillar: PillarChains ; var _deploy: HeroDeploy ; var _boxes: LevelBoxes
var fire: GPUParticles2D ; var _cloud: RainParticle

var entity: Array[CharacterBody2D] = [null, null]
var tile: PackedInt32Array = [0, 0, 0, 0]

func get_tile(no: int) -> int: return tile[Def.offset(HUD.hero, no)]
func set_tile(no: int) -> void: tile[Def.offset(HUD.hero, no)] = Def.ofmap(border.local_to_map(HUD.level.entity[HUD.hero].position))
func no_tile(no: int) -> void: tile[Def.offset(HUD.hero, no)] = 0

func on_tile(pos: Vector2) -> PackedInt32Array: return HUD.level.border.pos(pos).id().atlas().type().tile
func tile_plate() -> Vector2: return HUD.level.entity[HUD.hero].position
func tile_lever() -> Vector2: return HUD.level.entity[HUD.hero].position + HUD.level.entity[HUD.hero].lever.position

var deploy: HeroDeploy:
	get: return Def.ref(self, _deploy, &"_deploy", new_hero_deploy)
var boxes: LevelBoxes:
	get: return Def.ref(self, _boxes, &"boxes", new_boxes)
var cluster: TileCluster:
	get: return Def.ref(self, _cluster, &"tile", new_cluster)
var conductor: FlowConductor:
	get: return Def.ref(self, _conductor, &"_conductor", new_conductor)
var pillar: PillarChains:
	get: return Def.ref(self, _pillar, &"_pillar", new_pillar_chains)

func plate_encounter() -> void:
	var h: CharacterBody2D = HUD.level.entity[HUD.hero]
	tile[Def.offset(HUD.hero, Def.PLATE)] = Def.ofmap(border.local_to_map(h.position))
	HUD.level.cluster.tile_walk(h, true)
func plate_diverge() -> void:
	HUD.level.cluster.tile_walk(HUD.level.entity[HUD.hero], false)
	tile[Def.offset(HUD.hero, Def.PLATE)] = 0
func lever_encounter(_t: TileMapLayer) -> void: pass
func lever_diverge(_t: TileMapLayer) -> void: pass

func new_pillar_chains() -> PillarChains: return PillarChains.new()
func new_conductor() -> FlowConductor: return FlowConductor.new()
func new_boxes() -> LevelBoxes: return LevelBoxes.new()
func new_cluster() -> TileCluster: return TileCluster.new()
func new_hero_deploy() -> HeroDeploy: return HeroDeploy.new()
func new_hero(no: int) -> CharacterBody2D:
	if entity[no] == null:
		var hero: CharacterBody2D
		if no == Def.RAY:
			hero = load(Def.ray).instantiate()
			hero.name = &"ray"
		else:
			hero = load(Def.rock).instantiate()
			hero.name = &"rock"
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
