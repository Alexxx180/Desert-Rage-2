extends CharacterBody2D

signal move(position: Vector2)

@onready var geometry: CollisionShape2D = $geometry
@onready var view: Node2D = $view
@onready var logic: Node = $logic

func teleport(next: Vector2) -> void:
	position = next
	move.emit(position)

func travel(motion: Vector2) -> void:
	velocity = motion
	move_and_slide()
	move.emit(position)
