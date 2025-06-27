extends Node2D

@onready var ice: Area2D = $ice
@onready var torch: Area2D = $torch
@onready var enemy: Area2D = $enemy

func set_direction(direction: Vector2i) -> void:
	ice.set_direction(direction)
	torch.set_direction(direction)
	enemy.set_direction(direction)
