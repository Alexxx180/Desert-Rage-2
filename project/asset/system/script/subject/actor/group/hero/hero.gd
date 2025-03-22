extends CharacterBody2D

signal moving(velocity: Vector2)

@onready var view: Node2D = $view
@onready var logic: Node = $logic

# var _delta_count: float = 0
var _weight: int = 0
var weight: int:
	get: return _weight
	set(value): _weight = max(0, value)

# @onready var target: Vector2 = Vector2.ZERO

func _ready() -> void: logic.relations.controls(self)

func _physics_process(_delta: float) -> void:
# func _process(_delta: float) -> void:
#	if target != Vector2.ZERO:
		# target = Vector2.ZERO
#	else:
	"""
	if target != Vector2.ZERO:
		position = target
		print("TARGET: ", position)
		target = Vector2.ZERO
		_delta_count = 4
	elif _delta_count > 0:
		_delta_count -= _delta
		print("TARGET POS: ", position)
	else:
	"""
	#if velocity != Vector2.ZERO:
	move_and_slide()
	# print("TARGET: ", position)

func teleport(next: Vector2) -> void:
	velocity = Vector2.ZERO
	position = next
	print("SET TARGET: ", position)

func dash(force: Vector2) -> void:
	"""
	print("force: ", force)
	print("dash: ", position + force)
	print("world: ", get_collision_mask_value(1))
	print("borders: ", get_collision_mask_value(2))
	print("box: ", get_collision_mask_value(5))
	print("movement: ", logic.processors.input.movement.process_mode)
	print("platforming: ", logic.processors.input.platforming.process_mode)
	# """
	#target = force
	#target = 
	#position += force #target
	teleport(position + force)
	#velocity = Vector2.ZERO
	# position = position + force
	print("JUMPED: ", position)

func _set_velocity(motion: Vector2) -> void:
	velocity = motion
	moving.emit(motion)

func forget_velocity() -> void:
	_set_velocity(Vector2.ZERO)
	view.animation.move(Vector2.ZERO)

func travel(motion: Vector2) -> void:
	if weight != 0:
		motion *= logic.stats.force / weight
	else:
		motion *= logic.stats.speed

	_set_velocity(motion)
