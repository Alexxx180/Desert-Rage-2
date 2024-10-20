extends StaticBody2D

signal move(next: Vector2)
signal directing(direction: Vector2i)

@export_range(0.2, 2.0, 0.1) var weight: float = 1

@onready var view: Sprite2D = $view
@onready var geometry: Node = $placement
@onready var logic: Node2D = $logic

@onready var _target: Vector2 = position

const feedback: int = 2

var _delta: float = 0.0
var _impulse: float = 1

func _ready() -> void:
	logic.relations.set_control_entity(self)

func _physics_process(delta: float) -> void:
	_delta = delta
	var target: Vector2 = position.move_toward(_target, delta * _impulse)
	if target != position: move.emit()
	position = target
	#logic.processors.movement.seat.transport()
	# logic.processors.movement.seat.hero_climb()

func push() -> void:
	position = position.move_toward(_target, _delta * _impulse)
	var handle: Node = logic.processors.movement.push
	_impulse = handle.impulse
	var motion: Vector2 = handle.box.direction * (_impulse / feedback)
	motion *= weight
	_target = position + motion
	#move.emit() # position
	directing.emit(handle.box.direction)
