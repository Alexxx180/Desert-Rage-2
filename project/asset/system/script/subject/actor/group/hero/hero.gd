extends CharacterBody2D

signal moving(velocity: Vector2)

@onready var view: Node2D = $view
@onready var logic: Node = $logic

var _weight: int = 0
var weight: int:
	get: return _weight
	set(value): _weight = max(0, value)

func _ready() -> void: logic.relations.controls(self)

func _physics_process(_delta: float) -> void:
	move_and_slide()

func teleport(next: Vector2) -> void:
	velocity = Vector2.ZERO
	position = next

func dash(force: Vector2) -> void:
	print("JUMP: ", force)
	position += force

func travel(motion: Vector2) -> void:
	if weight != 0:
		motion *= logic.stats.force / weight
	else:
		motion *= logic.stats.speed

	velocity = motion
	moving.emit(motion)
