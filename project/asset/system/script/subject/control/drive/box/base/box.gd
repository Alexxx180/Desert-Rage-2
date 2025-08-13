extends CharacterBody2D

class_name PlatformingBox

signal move(next: Vector2)

enum { JUMP = 200000, SINGULARITY = 35000, GRAVITY = 700000 } # JUMP = -75000, GRAVITY = 375000 / 150 - 750

@export_range(1.5, 3.0, 0.1) var weight: float = 1
@export_range(1, 2, 1) var height: int = 1

@onready var view: Node2D = $view
@onready var geometry: Node = $placement
@onready var logic: Node2D = $logic

const feedback: int = 2

@onready var half: Vector2 = geometry.shape.size / 2

var center: Vector2:
	get: return position + half

func _ready() -> void: logic.relations.controls(self)

func compare_height(hero: CharacterBody2D) -> bool:
	return logic.processors.movement.seat.compare(hero)

func _physics_process(delta: float) -> void:
	if logic.detectors.slide.is_colliding():
		velocity.y = delta * (SINGULARITY + 10000)
	move_and_slide()

func push(next: Vector2) -> void:
	velocity = next
	move.emit(position)
	#print("CURRENT POS: ", position)
