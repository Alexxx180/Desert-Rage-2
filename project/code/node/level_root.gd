class_name LevelRoot extends Node2D

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
@onready var camera: Array[Camera2D] = [$camera_ray, $camera_rock]
var map: Node2D
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
var outs: Array[VisibleOnScreenNotifier2D] = [null, null]
var remotes: Array[RemoteTransform2D] = [null, null]
var parallax: Array[ParallaxLayer] = []
var overworld: bool = false
var ready_to_process: bool = false
var eye: Control; var magnifier: Camera2D
var out_shape: CollisionShape2D; var out_zone: Area2D

var lever_tile: PackedInt32Array = [0, 0, 0, 0, 0,  0, 0, 0, 0, 0]
var plate_tile: PackedInt32Array = [0, 0, 0, 0, 0,  0, 0, 0, 0, 0]

func input_skip(_event: InputEvent) -> void:
	pass

func _physics_process(_delta: float) -> void:
	if ready_to_process:
		for i in range(0, len(entity)):
			if entity[i] != null:
				entity[i].move_and_collide(HUD.action.velocity[i])
		if overworld:
			magnifier.position = entity[HUD.hero].position
			eye.global_position = entity[HUD.hero].get_global_transform_with_canvas().get_origin() - get_canvas_transform().origin # + Vector2(0, 96)

func add_chip(box: CharacterBody2D) -> void:
	add_child(box)
	box.position = HUD.level.border.get_position()

var heroes: Node2D

func bind_remote(hero: int, view: Camera2D) -> void:
	remotes[hero] = RemoteTransform2D.new()
	remotes[hero].name = &"view"
	remotes[hero].remote_path = view.get_path()
	entity[hero].add_child(remotes[hero])

func bind_remotes() -> void:
	ready_to_process = true
	bind_remote(Def.ROCK, camera[Def.ROCK])

func enter_group_view(_b: Node2D) -> void: if _b.is_in_group(&"player"): on_camera += 1; update_group_view()
func exit_group_view(_b: Node2D) -> void: if _b.is_in_group(&"player"): on_camera -= 1; update_group_view()
func update_group_view() -> void:
	if on_camera >= 2:
		HUD.coop_viewports.columns = 1
		HUD.rock_view.hide()
		HUD.level.camera[Def.ROCK].hide()
	else:
		HUD.coop_control()
		HUD.coop_viewports.columns = 2
		HUD.rock_view.show()
		HUD.level.camera[Def.ROCK].show()
	HUD.set_ports_size(HUD.ui.size)

var on_camera: int = 0

func _ready() -> void:
	HUD.level = self
	var e: Array[CharacterBody2D] = [$ray, $rock]
	heroes = Node2D.new()
	heroes.name = "heroes"
	heroes.y_sort_enabled = true
	map = get_node(^"..")
	map.call_deferred(&"add_child", heroes)
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
		outs[i] = hero.get_node(^"out")
		remove_child(hero)
		heroes.add_child(hero)
		hero.position = position
		entity.append(hero)
	out_zone = camera[Def.RAY].get_node(^"zone")
	out_zone.body_entered.connect(enter_group_view)
	out_zone.body_exited.connect(exit_group_view)
	out_shape = camera[Def.RAY].get_node(^"zone/shape")
	call_deferred(&"bind_remotes")
	HUD.coop_control()
	bind_remote(Def.RAY, camera[Def.RAY])
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
