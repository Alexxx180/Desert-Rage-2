class_name Boxes extends Node

@onready var seat: Node = $seat
@onready var push: Node = $push

# LINKING
var _push: Node
var _hero

func _get_velocity(hero: CharacterBody2D) -> Node:
	return hero.to.topdown.move.act.velocity

func rides(_m):
	_push.apply_velocity(_hero.logic.stats.motion) # print("MOVING BOX: ", _hero.logic.stats.motion)

func _grab(hero: CharacterBody2D) -> void:
	_hero = hero
	seat.controls(box, move.seat)
	push.controls(box, move.push)
	move.gravity.box = box
	hero.to.act.moving.connect(rides)
	hero.to.moves.set_move_action("pull")

func _release(hero: CharacterBody2D) -> void:
	hero.to.act.moving.disconnect(rides)
	hero.to.moves.set_move_action("go")
	_push.apply_velocity(Vector2.ZERO)

func controls(box: CharacterBody2D, push: Node) -> void:
	_push = push
	_push.box = box
	var work: Node = box.logic.work # processor.grab.connect(_grab) # processor.release.connect(_release)	
	push.directing.connect(work.press.set_direction) # push.forwarding.connect(box.push)
	push.weight = box.weight

@onready var booking: Node = $booking

func controls(box: CharacterBody2D, seat: Node) -> void:
	var stand: StaticBody2D = box.logic.see.stand

	seat.place.entity = box
	stand.box = box
	booking.controls(seat)

func controls(box: CharacterBody2D, press: Node, button: Node) -> void:
	var see: Area2D = box.logic.see.press
	see.body_entered.connect(press.encounter)
	see.body_exited.connect(press.diverge)
	
	press.activate.connect(button.activate)
	press.deactivate.connect(button.deactivate)
	press.box = box

@onready var _hero: CharacterBody2D = HUD.ENTITY

func controls(seat: Node) -> void:
	seat.place.standing.connect(_on_stand)
	seat.place.leaving.connect(_on_leave)

func set_pos(pos: Vector2) -> void:
	if _hero != HUD.ENTITY and not _hero.to.topdown.levels.jump.jumped:
		print("override hero pos: ", pos)
		_hero.make_position(pos)

func _on_stand(box: CharacterBody2D, hero: CharacterBody2D) -> void:
	print("connected climb")
	_hero = hero
	hero.to.jump.feet.floors.entity = box
	box.logic.work.move.seat.move.connect(set_pos)

func _on_leave(box: CharacterBody2D, hero: CharacterBody2D) -> void:
	print("disconnected climb")
	_hero = HUD.ENTITY
	hero.to.jump.feet.floors.entity = HUD.ENTITY
	box.logic.work.move.seat.move.disconnect(set_pos)

# WORK

signal grab(pull: Node)
signal release(pull: Node)

@onready var move: Node = $move
@onready var press: Node = $press

func transport(pos: Vector2) -> void:
	move.seat.transport(pos)

func grab_box(pull: Node) -> void: grab.emit(pull)
func release_box(pull: Node) -> void: release.emit(pull)

signal move(target: Vector2)

@onready var place: Node = $place

var height: int = 1
var F: int:
	get: return place.get_floor() + height

func compare(hero: CharacterBody2D) -> bool:
	return hero.to.F == place.get_floor()

func transport(_position: Vector2) -> void:
	pass
	# move.emit(place.stand.get_ledge_position()) #print("TRANSPORTED: ", target)

func enable_stand(hero: CharacterBody2D) -> void:
	if place.empty() and place.is_in_midair(hero):# print("ENABLE STAND! ", place.empty())
		place.stay(hero)
		place.visit(hero, hero.get_instance_id())

func disable_stand(hero: CharacterBody2D) -> void:
	if not place.empty() and place.same(hero):# print("DISABLE STAND? ", place.stand())
		place.leave(hero)
		place.visit(hero)



enum { WORLD = 1, BORDERS = 2, GAP = 7, UPLAND = 8 } # , JUMP = 200000, GRAVITY = 700000
# CHARACTER = 3, BOX = 5
var box: CharacterBody2D
var collision_on: bool = true
# var height: float = 0

func turn_walls_collision(value: bool, borders: bool = false) -> void:
	print("BOX - ENABLED COLLISION: ", value)
	collision_on = value
	var colliders: Array[int] = [WORLD, GAP, UPLAND] # BOX,
	if not borders: colliders.push_front(BORDERS)
	for mask in colliders:
		box.set_collision_mask_value(mask, value)


signal activate(pos: Vector2)
signal deactivate(pos: Vector2)

@export var target = Vector2(59, 17)

var _last_position: Vector2
var _box: CharacterBody2D
var _roll: Vector2

var box: CharacterBody2D:
	set(value):
		_box = value

func set_direction(direction: Vector2):
	if direction != Vector2.ZERO:
		_roll = target * direction

func encounter(_execute: TileMapLayer) -> void:
	_last_position = _box.position# + _roll
	activate.emit(_last_position)

func diverge(_execute: TileMapLayer) -> void:
	deactivate.emit(_last_position)
