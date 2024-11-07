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

func _physics_process(_delta: float) -> void:
	move_and_slide()

func travel(motion: Vector2) -> void:
	velocity = motion
	moving.emit(motion)
	move.emit(position)
