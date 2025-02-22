extends CharacterBody2D

signal plot(text: Array[String])
signal move(position: Vector2)
signal moving(velocity: Vector2)

@onready var view: Node2D = $view
@onready var logic: Node = $logic

@onready var half: Vector2 = $geometry.shape.size / 2

var center: Vector2:
	get: return position + half

var _weight: int = 0
var weight: int:
	get: return _weight
	set(value):
		_weight = max(0, value)

func plot_unfolding(text: Array[String]) -> void:
	plot.emit(text)

func get_contact(direction: Vector2) -> Vector2:
	return position + half * (Vector2.ONE + direction)

func _ready() -> void: logic.relations.controls(self)

func teleport(next: Vector2) -> void:
	velocity = Vector2.ZERO
	position = next
	move.emit(position)

func dash(force: Vector2) -> void:
	position += force
	move.emit(position)

func _physics_process(_delta: float) -> void:
	move_and_slide()

func travel(motion: Vector2) -> void:
	if weight != 0:
		motion *= logic.stats.force / weight
	else:
		motion *= logic.stats.speed

	velocity = motion
	moving.emit(motion)
	move.emit(position)

func push(motion: Vector2) -> void:
	velocity = motion
