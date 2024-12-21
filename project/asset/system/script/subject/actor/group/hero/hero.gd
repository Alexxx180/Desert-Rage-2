extends CharacterBody2D

signal move(position: Vector2)
signal moving(velocity: Vector2)

@onready var geometry: CollisionShape2D = $geometry
@onready var view: Node2D = $view
@onready var logic: Node = $logic

@onready var half: Vector2 = geometry.shape.size / 2

var center: Vector2:
	get: return position + half

func get_contact(direction: Vector2) -> Vector2:
	return position + half * (Vector2.ONE + direction)

func _ready() -> void:
	logic.relations.controls(self)

func teleport(next: Vector2) -> void:
	velocity = Vector2.ZERO
	position = next
	move.emit(position)
	#print("TELEPORT: ", position)

func dash(force: Vector2) -> void:
	position += force
	move.emit(position)
	#print("DASHING: ", position)

func _physics_process(_delta: float) -> void:
	move_and_slide()

func travel(motion: Vector2) -> void:
	#print("MOTION IS: ", motion)
	velocity = motion
	moving.emit(motion)
	move.emit(position)
