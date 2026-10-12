class_name LevelRoot extends Camera2D

@export_flags_2d_physics var result: PackedInt32Array = [0, 0]
@export_flags_2d_physics var chests: PackedInt32Array = [0, 0]
@export_flags_2d_physics var pages: PackedInt32Array = [0, 0]
@export_flags_2d_physics var books: PackedInt32Array = [0, 0]
@export_flags_3d_navigation var enemy_navigation: PackedInt32Array = [  ## AI strategy. Move | C = to, F = from
	0, 0]
@export var speed: float = 0.5
@export var enemy_proportion: PackedFloat32Array = []
@export_flags_3d_physics var enemy: int
@export_flags_3d_render var mode: int
@onready var border: TileDecorator = get_node(^"../border"); var execute: TileDecorator
@onready var entity: Array[CharacterBody2D] = []
var boxes: Array[AnimatableBody2D] = []
var distraction_body: Array[StaticBody2D] = [null, null]
var entity_status: Array[Array] = [[],  []] # Sprite2D

var lever: Array[Area2D] = [null, null]
var lever_body: Array[CollisionShape2D] = [null, null]
var plate: Array[Area2D] = [null, null]
var plate_body: Array[CollisionShape2D] = [null, null]
var profile: Array[AnimatedSprite2D] = [null, null]
var shadow: Array[Sprite2D] = [null, null]
var mirror: Array[AnimatedSprite2D] = [null, null]
var parallax: Array[ParallaxLayer] = []
var overworld: bool = false
var eye: Control; var magnifier: Camera2D

var lever_tile: PackedInt32Array = [0, 0, 0, 0, 0,  0, 0, 0, 0, 0]
var plate_tile: PackedInt32Array = [0, 0, 0, 0, 0,  0, 0, 0, 0, 0]

func input_skip(_event: InputEvent) -> void:
	pass

#func _process(_delta: float) -> void:
#	position = entity[HUD.hero].global_position

func _physics_process(_delta: float) -> void:
	for i in range(0, len(entity)):
		entity[i].move_and_collide(HUD.action.velocity[i])
	if overworld:
		magnifier.position = entity[HUD.hero].position
		eye.global_position = entity[HUD.hero].get_global_transform_with_canvas().get_origin() - get_canvas_transform().origin # + Vector2(0, 96)

func add_chip(box: CharacterBody2D) -> void:
	add_child(box)
	box.position = HUD.level.border.get_position()

var heroes: Node2D

func _ready() -> void:
	HUD.level = self
	var e: Array[CharacterBody2D] = [$ray, $rock]
	# var level: Node2D = get_parent() #entity[Def.RAY].reparent(level)
	heroes = Node2D.new()
	heroes.name = "heroes"
	heroes.y_sort_enabled = true
	#print(get_node(^"..").name, " NODE: ", get_node(^"..") == null, " AR: ", heroes == null)
	
	get_node(^"..").call_deferred(&"add_child", heroes)
	for i in range(0, len(e)):
		var hero: CharacterBody2D = e[i]
		hero.set_meta(&"no", i)
		lever[i] = hero.get_node(^"lever")
		lever_body[i] = hero.get_node(^"lever/shape")
		plate[i] = hero.get_node(^"plate")
		plate_body[i] = hero.get_node(^"plate/shape")
		profile[i] = hero.get_node(^"profile")
		shadow[i] = hero.get_node(^"shadow")
		mirror[i] = hero.get_node(^"mirror")
		remove_child(hero)
		heroes.add_child(hero) # border
		hero.position = position
		entity.append(hero)
	call_deferred(&"reparent", entity[Def.RAY])
	lever[Def.RAY].body_entered.connect(HUD.action.lever_inner_ray)
	lever[Def.RAY].body_exited.connect(HUD.action.lever_outer_ray)
	lever[Def.ROCK].body_entered.connect(HUD.action.lever_inner_rock)
	lever[Def.ROCK].body_exited.connect(HUD.action.lever_outer_rock)
	plate[Def.RAY].body_entered.connect(HUD.action.plate_inner_ray)
	plate[Def.RAY].body_exited.connect(HUD.action.plate_outer_ray)
	plate[Def.ROCK].body_entered.connect(HUD.action.plate_inner_rock)
	plate[Def.ROCK].body_exited.connect(HUD.action.plate_outer_rock)
	if has_node(^"eye"):
		eye = get_node(^"eye")
		eye.reparent(HUD)
		var subview: SubViewport = eye.get_node(^"contains/subview")
		subview.world_2d = get_tree().root.world_2d
		magnifier = subview.get_node(^"camera")
		overworld = true
	if has_node(^"execute"):
		execute = get_node(^"execute")
		HUD.action.resize_clusters() # HUD.action.help_hint(WorldInteraction.HELP, WorldInteraction.HINT, cluster.hint)
	if has_node(^"parallax"):
		for node in get_node(^"parallax").get_children(): parallax.append(node)
