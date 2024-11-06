extends CharacterBody2D

signal move(position: Vector2)
signal moving(velocity: Vector2)

@onready var geometry: CollisionShape2D = $geometry
@onready var view: Node2D = $view
@onready var logic: Node = $logic

func _ready() -> void:
	logic.relations.apply(self)

func teleport(next: Vector2) -> void:
	print("REAL POS: ", next)
	position = next
	move.emit(position)

func dash(force: Vector2) -> void:
	position += force
	move.emit(position)

func travel(motion: Vector2) -> void:
	velocity = motion
	move_and_slide()
	#print("MOTION: ", motion)
	moving.emit(motion)
	move.emit(position)
