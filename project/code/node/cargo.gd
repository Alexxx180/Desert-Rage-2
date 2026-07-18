extends CharacterBody2D

@onready var see: Node2D = $see
@onready var work: Node = $work
@onready var link: Node = $link

func _ready() -> void: link.controls(self)



extends Node

@onready var timer: Timer = $timer

func controls(platform: CharacterBody2D) -> void:
	var stand: Area2D = platform.see.stand
	var work: Node = platform.work

	work.cargo.platform = platform
	stand.body_entered.connect(work.cargo.load_cargo)
	stand.body_exited.connect(work.cargo.free_cargo)

	timer.timeout.connect(platform.see.ledge.sync_traps)
	timer.start()


extends Node

@onready var timer: Timer = $timer
var tags: TileMapLayer = null
var _platform: CharacterBody2D

func bind_lever() -> void:
	var location: Node = tags.lockers.location
	var pos: Vector2 = _platform.position + _platform.see.position
	var data: Dictionary = location.search.atlas.get_mech_atlas(tags.lay.tags, pos)
	data.processor = _platform.work
	location.storage.setup_mech(data)

func controls(platform: CharacterBody2D) -> void:
	#TODOT CARGO CONNECT
	var stand: Area2D = platform.see.stand
	var work: Node = platform.work
	#bind_lever(platform)
	_platform = platform
	if tags == null: tags = platform.get_node("../tags")

	work.cargo.platform = platform
	stand.body_entered.connect(work.cargo.load_cargo)
	stand.body_exited.connect(work.cargo.free_cargo)

	timer.timeout.connect(platform.see.ledge.sync_traps)
	timer.timeout.connect(bind_lever)
	timer.start()
	work.timer.timeout.connect(work.enable_control)





extends Node

var platform: CharacterBody2D
var weight: Dictionary = {}

func load_cargo(cargo: AnimatableBody2D) -> void:
	if platform.see.ledge.sync_traps():
		weight[cargo.get_instance_id()] = cargo
		toggle(cargo, false)

func free_cargo(cargo: CharacterBody2D) -> void:
	if platform.see.ledge.sync_traps():
		weight.erase(cargo.get_instance_id())
		toggle(cargo, true)

func toggle_platforming(hero: CharacterBody2D, state: bool) -> void:
	hero.to.platform.surface.border.turn_monitoring(state)

func toggle_mask(gravity, state: bool) -> Lay:
	return gravity.context(state).collide_main().collide(Lay.BORDERS)

func is_weight_box(entity: AnimatableBody2D) -> bool:
	return entity is PlatformingBox

func toggle(cargo: AnimatableBody2D, state: bool) -> void:
	if is_weight_box(cargo):
		toggle_mask(cargo.logic.work.move.gravity, state)
	else:
		toggle_mask(cargo.to.layers, state).hero_collide(true)
		toggle_platforming(cargo, state)

func _move_certain(box: CharacterBody2D, motion: Vector2) -> void:
	box.velocity = motion

func _move_objects(motion: Vector2) -> void:
	_move_certain(platform, motion)
	for cargo in weight.values():
		_move_certain(cargo, motion)

func move_cargo(motion: Vector2) -> void:
	if platform.see.ledge.caution.is_colliding():
		_move_certain(platform, Vector2.ZERO) #_move_objects(Vector2.ZERO)
	else:
		_move_objects(motion)




extends Node

@export var direction: Vector2 = Vector2(250, 0)

@onready var timer: Timer = $timer
@onready var cargo: Node = $cargo

const INVERSE: Vector2 = Vector2(-1, -1)
var enabled: bool = false

func control_cargo() -> void:
	if enabled or not cargo.platform.see.ledge.sync_traps():
		cargo.move_cargo(direction) #move_cargo()

func enable_control() -> void:
	enabled = false

func toggle_logic() -> void:
	direction *= INVERSE
	enabled = true
	timer.start()

func _physics_process(_delta: float) -> void:
	#if cargo.weight.size() >= 1:
	control_cargo()
	cargo.platform.move_and_slide()




extends Node

const POWER: int = 250

@onready var cargo: Node = $cargo

func control_cargo() -> void:
	var motion: Vector2 = cargo.platform.see.ledge.move()
	if motion != Vector2.ZERO:
		print("MOVING CARGO: ", motion)
		cargo.move_cargo(motion * POWER)

func _physics_process(_delta: float) -> void:
	if cargo.weight.size() >= 1:
		control_cargo()
	cargo.platform.move_and_slide()




extends Node2D

@onready var axis_a: ShapeCast2D = $axis_a
@onready var axis_b: ShapeCast2D = $axis_b

func is_colliding() -> bool:
	return axis_a.is_colliding() and axis_b.is_colliding()


extends Node2D

@onready var trap: Sprite2D = $trap
@onready var wall: StaticBody2D = $wall
@onready var plane: Node2D = $plane
@onready var hero: ShapeCast2D = $hero
@onready var current: ShapeCast2D = $current

var open: bool

func sync_trap() -> bool:
	open = plane.is_colliding() # wall.visible = not open
	Works.turn(wall, not open)
	trap.visible = open
	return open

func move() -> bool:
	#sync_trap() #not sync_trap() and  
	return not sync_trap() and hero.is_colliding()

func rail() -> bool:
	return current.is_colliding()




extends Node2D

@onready var stand: Area2D = $stand
@onready var ledge: Node2D = $ledge


extends Node2D

@onready var top: Node2D = $top
@onready var left: Node2D = $left
@onready var right: Node2D = $right
@onready var bottom: Node2D = $bottom
@onready var caution: ShapeCast2D = $caution

func get_directions() -> Array:
	return [
		[top, Vector2(0, -1)], [bottom, Vector2(0, 1)],
		[left, Vector2(-1, 0)], [right, Vector2(1, 0)]
	]

func sync_traps() -> bool:
	var open: bool = false
	for direction in [top, left, right, bottom]:
		open = open or direction.sync_trap()
	return open

func move() -> Vector2:
	var directions: Array = get_directions()
	for motion in directions:
		if motion[0].rail() and motion[0].move():
			#print("CarGo on rails: ", motion[1])
			# print("CarGo moves: ", motion[1])
			return motion[1]
	return Vector2.ZERO
