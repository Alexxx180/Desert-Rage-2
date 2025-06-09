extends CharacterBody2D

enum { WORLD = 1, BORDERS = 2, BOX = 5, GAP = 7, UPLAND = 8 }

signal moving(velocity: Vector2)
#signal action_move(caption: String)

@onready var view: Node2D = $view
@onready var logic: Node = $logic

var _weight: int = 0
var weight: int:
	get: return _weight
	set(value): _weight = max(0, value)

var target: Rect2

func _ready() -> void:
	view.animation.hero = self
	logic.relations.controls(self)

func _physics_process(_delta: float) -> void:
	move_and_slide()

func turn_walls_collision(value: bool) -> void:
	for mask in [WORLD, BORDERS, BOX, GAP, UPLAND]:
		set_collision_mask_value(mask, value)

func teleport(next: Vector2) -> void:
	velocity = Vector2.ZERO
	target.position = position
	target.size = next - position
	print("SET TARGET: ", position)
	view.animation.action_move("jump")
	#action_move.emit("jump")

func dash(force: Vector2) -> void:
	teleport(position + force)
	print("JUMPED: ", position)

func move(proportion: float) -> void:
	var next: Vector2 = target.position + target.size * proportion
	var p: Vector2 = position
	print("POS: ", p, " - NEXT: ", next)
	position = next

func _set_velocity(motion: Vector2) -> void:
	velocity = motion
	moving.emit(motion)

func forget_velocity() -> void:
	var v = velocity
	print("VELOCITY: ", v)
	_set_velocity(Vector2.ZERO)
	v = velocity
	print("VELOCITY: ", v)
	view.animation.move(Vector2.ZERO)

func travel(motion: Vector2) -> void:
	if weight != 0:
		motion *= logic.stats.force / weight
	else:
		motion *= logic.stats.speed

	_set_velocity(motion)
