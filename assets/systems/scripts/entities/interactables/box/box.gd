extends StaticBody2D

signal move(next: Vector2)
signal directing(direction: Vector2i)

@export_range(0.2, 2.0, 0.1) var weight: float = 1

@onready var view: Sprite2D = $view
@onready var geometry: Node = $placement
@onready var logic: Node2D = $logic

var _delta: float = 0.0

func _ready() -> void:
	logic.relations.set_control_entity(self)

func _physics_process(delta: float) -> void:
	_delta = delta

func push() -> void:
	var handle: Node = logic.processors.movement.push
	var direction: Vector2i = handle.box.direction
	var impulse: float = handle.impulse
	var motion: Vector2 = direction * impulse
	motion *= weight
	print("MOVING: ", motion)
	move_and_collide(motion)
	move.emit(position)
	directing.emit(direction)
