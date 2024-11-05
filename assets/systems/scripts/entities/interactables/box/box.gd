extends CharacterBody2D

signal move(next: Vector2)
signal directing(direction: Vector2i)

@export_range(0.2, 2.0, 0.1) var weight: float = 1

@onready var view: Sprite2D = $view
@onready var geometry: Node = $placement
@onready var logic: Node2D = $logic

# @onready var _target: Vector2 = position

const feedback: int = 2

func _ready() -> void:
	logic.relations.set_control_entity(self)

func _physics_process(_delta: float) -> void:
	if velocity != Vector2.ZERO:
		move_and_slide()
		move.emit(position)

func push() -> void:
	var handle: Node = logic.processors.movement.push
	velocity = handle.box.velocity
	directing.emit(handle.box.velocity.normalized())
