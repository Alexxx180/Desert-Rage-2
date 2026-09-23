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

var entity: Array[CharacterBody2D] = [$ray, $rock]
var boxes: Array[AnimatableBody2D] = []
var distraction_body: Array[StaticBody2D] = [null, null]

var lever: Array[Area2D] = []
var lever_body: Array[CollisionShape2D] = []
var plate: Array[Area2D] = []
var plate_body: Array[CollisionShape2D] = []
var profile: Array[AnimatedSprite2D] = []
var shadow: Array[Sprite2D] = []
var mirror: Array[AnimatedSprite2D] = [null, null]
var parallax: Array[ParallaxLayer] = []
var overworld: bool = false
var eye: Control; var magnifier: Camera2D

var lever_tile: PackedInt32Array = [0, 0, 0, 0, 0,  0, 0, 0, 0, 0]
var plate_tile: PackedInt32Array = [0, 0, 0, 0, 0,  0, 0, 0, 0, 0]

func _process(_delta: float) -> void:
	for lay in parallax: lay.motion_offset = entity[HUD.hero].position * speed

func _physics_process(_delta: float) -> void:
	for i in range(0, len(entity)):
		if entity[i] != null:
			entity[i].move_and_collide(HUD.interact.velocity[i])
	if overworld:
		magnifier.position = HUD.level.entity[HUD.hero].position
		eye.global_position = HUD.level.entity[HUD.hero].get_global_transform_with_canvas().get_origin() - get_canvas_transform().origin # + Vector2(0, 96)

func add_chip(box: CharacterBody2D) -> void:
	add_child(box)
	box.position = HUD.level.border.get_position()

func _ready() -> void:
	HUD.level = self
	if has_node(^"eye"):
		eye = get_node(^"eye")
		eye.reparent(HUD)
		var subview: SubViewport = eye.get_node(^"contains/subview")
		subview.world_2d = get_tree().root.world_2d
		magnifier = subview.get_node(^"camera")
		overworld = true
	if has_node(^"execute"):
		execute = get_node(^"execute")
		HUD.interact.resize_clusters() # HUD.interact.help_hint(WorldInteraction.HELP, WorldInteraction.HINT, cluster.hint)
	if has_node(^"parallax"):
		for node in get_node(^"parallax").get_children(): parallax.append(node)
	# HUD.state = Bit.to1(HUD.state, Def.TRANSIT)
