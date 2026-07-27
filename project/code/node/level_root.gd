class_name LevelRoot extends Node2D

@onready var group: Camera2D = $group
@onready var border: TileDecorator = $border ; var execute: TileDecorator

var entity: Array[CharacterBody2D] = [null, null]
var tile: PackedInt32Array = [0, 0, 0, 0]

var cluster: PackedInt32Array = []
var access: PackedInt32Array = []
var sizes: PackedByteArray = [0, 0, 0, 0]
var buttons: Dictionary[int, int] = {}
var hint: PackedInt32Array = []

var lever: Array[Area2D] = []
var lever_body: Array[CollisionShape2D] = []
var plate: Array[Area2D] = []
var plate_body: Array[CollisionShape2D] = []
var profile: Array[AnimatedSprite2D] = []
var shadow: Array[Sprite2D] = []
var mirror: Array[AnimatedSprite2D] = [null, null]
var weight: PackedFloat32Array = [1.0]
var ride: PackedByteArray = [-1]
var boxes: Array[PackedByteArray] = []
var velocity: PackedVector2Array = []

func _physics_process(_delta: float) -> void:
	for i in range(0, len(entity)):
		entity[i].move_and_collide(velocity[i])

func add_chip(box: CharacterBody2D) -> void:
	add_child(box)
	box.position = HUD.level.border.get_position()

func _ready() -> void:
	HUD.level = self
	if has_node(^"execute"):
		execute = get_node(^"execute")
		cluster.help_hint(Def.HELP, Def.HINT, cluster.hint)
		#cluster.resize_clusters()
	# HUD.state = Bit.to1(HUD.state, Def.TRANSIT)
