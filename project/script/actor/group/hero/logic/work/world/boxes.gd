class_name LevelBoxes extends RefCounted

enum { BORDERS, WORLD, ENTITY, GROUND, SLIDE = 2, POWER = 40000 } # , JUMP = 200000, GRAVITY = 700000 # CHARACTER = 3, BOX = 5

const small: PackedScene = preload("res://pre/box/small.tscn")
const large: PackedScene = preload("res://pre/box/large.tscn")
const fire: PackedScene = preload("res://pre/box/fire.tscn")

var boxes: Array[AnimatableBody2D] = []
var height: PackedByteArray = []
var state: PackedByteArray = []
var grab: PackedByteArray = []

func is_sliding(no: int) -> bool: return Bit.of(state[SLIDE], no)

func toggle_slide(no: int, next: bool) -> void:
	state[SLIDE] = Bit.to(state[SLIDE], no, next)

func slide_the_box(box: CharacterBody2D) -> void:
	box.make_velocity(Vector2(box.velocity.x, Def.GRAVITY)) # * delta

func add_box(box_type: int, position: Vector2) -> void:
	var no: int = boxes.size()
	match box_type:
		Def.SMALL_BOX:
			boxes.append(small.instantiate())
			height.append(1)
		Def.LARGE_BOX:
			boxes.append(large.instantiate())
			height.append(2)
		Def.FIRE_BOX:
			boxes.append(fire.instantiate())
			height.append(0)
	print("LEVEL: ", Def.SMALL_BOX, " - B: ", box_type)
	HUD.level.call_deferred(&"add_child", boxes[no])
	boxes[no].set_meta(&"no", no)
	boxes[no].position = position + Vector2(0, 28)
	boxes[no].name = str(boxes[no].name, '_', no)
	controls(boxes[no])
	# box.show()
# LINKING

func get_box(no: int) -> AnimatableBody2D: return boxes[no]

func throw(box: int, motion: Vector2i) -> void: # THROW
	boxes[box].velocity = POWER * motion

func pushes(box: int, velocity: Vector2) -> void: # for i in range(0, count.size()) # if Bit.of(state[hero.no], i):
	boxes[box].make_velocity(velocity)

func fixate_box(hero: int, box: int, _add: int) -> void:
	state[hero] = Bit.to1(state[hero], box)

func controls(box: AnimatableBody2D) -> void:
	# var see: Area2D = box.get_node("press")
	# see.body_entered.connect(encounter)
	# see.body_exited.connect(diverge)
	var fov: VisibleOnScreenNotifier2D = box.get_node(^"fov")
	fov.screen_entered.connect(box.show)
	fov.screen_exited.connect(box.hide)
