extends CharacterBody2D

enum { WORLD = 1, BORDERS = 2, CHARACTER = 3, BOX = 5, GAP = 7, UPLAND = 8, DISTANCE = 50, MULTIPLIER = 50 }

signal moving(velocity: Vector2)

@onready var view: Node2D = $view
@onready var logic: Node = $logic
@onready var _enemy: CharacterBody2D = Defaults.CHARACTER

var _movement: Callable = usual_movement

var enemy: CharacterBody2D:
	get: return _enemy
	set(value):
		_enemy = value
		_movement = usual_movement if value == Defaults.CHARACTER else targeted_movement

var _weight: int = 0
var weight: int:
	get: return _weight
	set(value): _weight = max(0, value)

var target: Rect2
var targeted: bool = false

func _ready() -> void:
	view.animation.hero = self
	logic.relations.controls(self)

func targeted_movement() -> void:
	var motion: Vector2 = position.direction_to(enemy.position) * (logic.stats.speed / MULTIPLIER)
	velocity = motion # 400
	moving.emit(motion)
	view.animation.move(motion)
	logic.processors.ui.input.imitate_motion(position.direction_to(enemy.position)) #.normalized()
	if position.distance_to(enemy.position) > DISTANCE:
		move_and_slide()
	else:
		enemy = Defaults.CHARACTER
		view.animation.start_fight("active")
		view.animation.fight_body("hands")
		forget_velocity()

func usual_movement() -> void:
	move_and_slide()

func _physics_process(_delta: float) -> void:
	_movement.call()

func turn_walls_collision(value: bool) -> void:
	for mask in [WORLD, BORDERS, BOX, GAP, UPLAND]:
		set_collision_mask_value(mask, value)
	set_hero_collision(value)

func set_hero_collision(value: bool) -> void:
	set_collision_layer_value(CHARACTER, value)

func teleport(next: Vector2) -> void:
	velocity = Vector2.ZERO
	target.position = position
	target.size = next - position
	view.animation.action_move("jump")

func dash(force: Vector2) -> void:
	teleport(position + force)
	print("JUMPED: ", position)

func move(proportion: float) -> void:
	position = target.position + target.size * proportion

func reset_velocity(motion: Vector2 = Vector2.ZERO) -> void:
	make_velocity(motion)
	moving.emit(motion)

func make_velocity(motion: Vector2) -> void:
	velocity = motion

func directed_to(target: Vector2) -> Vector2:
	return position.direction_to(target)

func forget_velocity() -> void:
	reset_velocity()
	view.animation.move(Vector2.ZERO)

func travel(motion: Vector2) -> void:
	if weight != 0:
		motion *= logic.stats.force / weight
	else:
		motion *= logic.stats.speed

	reset_velocity(motion)
