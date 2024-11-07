extends CharacterBody2D

signal move(position: Vector2)
signal moving(velocity: Vector2)

@onready var geometry: CollisionShape2D = $geometry
@onready var view: Node2D = $view
@onready var logic: Node = $logic

func _ready() -> void:
	logic.relations.apply(self)

func teleport(next: Vector2) -> void:
	position = next
	move.emit(position)
	print("TELEPORT: ", position)

func dash(force: Vector2) -> void:
	position += force
	move.emit(position)
	print("DASHING: ", position)

func travel(motion: Vector2) -> void:
	velocity = motion
	move_and_slide()
	#if motion.y > 0 and motion.x == 0:
	#moving.emit(velocity)
	print("BUT MOTION IS: ", motion)
	moving.emit(motion)
	move.emit(position)
