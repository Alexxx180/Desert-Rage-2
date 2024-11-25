extends Node2D

@onready var push: Area2D = $push

@onready var geometry: CollisionShape2D = push.geometry
@onready var size: Vector2 = geometry.shape.size

const DISTANCE: int = 16

func set_direction(direction: Vector2i) -> void:
	push.position = direction * DISTANCE
	
	geometry.shape.size.x = size.x + size.x * abs(direction.y) * 4
	geometry.shape.size.y = size.y + size.y * abs(direction.x) * 2
