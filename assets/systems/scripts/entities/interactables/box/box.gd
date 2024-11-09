extends CharacterBody2D

signal move(next: Vector2)
signal directing(direction: Vector2i)

@export_range(0.2, 2.0, 0.1) var weight: float = 1

@onready var view: Node2D = $view
@onready var geometry: Node = $placement
@onready var logic: Node2D = $logic

const feedback: int = 2

func _ready() -> void:
	logic.relations.set_control_entity(self)

func _physics_process(_delta: float) -> void:
	move_and_slide()

func push(next: Vector2) -> void:
	velocity = next
	#directing.emit(velocity.normalized())
	move.emit(position)
