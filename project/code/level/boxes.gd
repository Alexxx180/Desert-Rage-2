class_name LevelBoxes extends Node

enum { BORDERS, WORLD, ENTITY, GROUND, SLIDE = 2, POWER = 40000 } # , JUMP = 200000, GRAVITY = 700000 # CHARACTER = 3, BOX = 5
"""
const small: PackedScene = preload("res://pre/box/small.tscn")
const large: PackedScene = preload("res://pre/box/large.tscn")
const fire: PackedScene = preload("res://pre/box/fire.tscn")
"""
var velocity: PackedVector2Array = []
var assets: Array[AnimatableBody2D] = []
var height: PackedByteArray = []
var weight: PackedByteArray = []

var state: PackedByteArray = []
var grab: PackedByteArray = []

const weight_d: PackedFloat32Array = [0, 1, 0.5, 0.33, 0.25]

func is_sliding(no: int) -> bool: return Bit.of(state[SLIDE], no)

func _physics_process(_delta: float) -> void:
	for i in range(0, len(assets)):
		assets[i].move_and_collide(velocity[i])

func toggle_slide(no: int, next: bool) -> void:
	state[SLIDE] = Bit.to(state[SLIDE], no, next)

func slide_the_box(box: CharacterBody2D) -> void:
	box.make_velocity(Vector2(box.velocity.x, Def.GRAVITY)) # * delta

func set_box(asset: PackedScene, data: PackedByteArray) -> void:
	assets.append(asset.instantiate())
	height.append(data[0])
	weight.append(data[1])
	velocity.append(Vector2.ZERO)
"""
func add_box(box_type: int, position: Vector2) -> void:
	var no: int = assets.size()
	match box_type:
		Def.SMALL_BOX: set_box(small, [1, 2])
		Def.LARGE_BOX: set_box(large, [2, 4])
		Def.FIRE_BOX: set_box(fire, [0, 2])
	print("LEVEL: ", Def.SMALL_BOX, " - B: ", box_type)
	HUD.level.call_deferred(&"add_child", assets[no])
	assets[no].set_meta(&"no", no)
	assets[no].position = position + Vector2(0, 28)
	assets[no].name = str(assets[no].name, '_', no)
	controls(assets[no])
"""
func get_box(no: int) -> AnimatableBody2D: return assets[no]

func throw(box: int, motion: Vector2i) -> void: # THROW
	velocity[box] = POWER * motion

func pushes(box: int, motion: Vector2) -> void: # for i in range(0, count.size()) # if Bit.of(state[hero.no], i):
	velocity[box] = motion * weight_d[weight[box]]

func fixate_box(hero: int, box: int, _add: int) -> void:
	state[hero] = Bit.to1(state[hero], box)

func encounter() -> void: pass
func diverge() -> void: pass

func controls(box: AnimatableBody2D) -> void:
	var see: Area2D = box.get_node("press")
	see.body_entered.connect(encounter)
	see.body_exited.connect(diverge)
	var fov: VisibleOnScreenNotifier2D = box.get_node(^"fov")
	fov.screen_entered.connect(box.show)
	fov.screen_exited.connect(box.hide)
