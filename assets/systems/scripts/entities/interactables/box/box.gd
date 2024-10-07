extends StaticBody2D

signal move(next: Vector2)

@export_range(0.2, 2.0, 0.1) var weight: float = 1

@onready var view: Sprite2D = $view
@onready var geometry: Node = $placement
@onready var logic: Node2D = $logic

var _delta: float = 0.0

func _physics_process(delta: float) -> void:
	_delta = delta

func push(motion: Vector2):
	print("MOVING: ", motion * weight)
	move_and_collide(motion * weight)
	move.emit(position)
