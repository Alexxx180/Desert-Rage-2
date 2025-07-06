extends Node2D

@onready var platforms: Node2D = $platforms
@onready var floors: Area2D = $floors
@onready var stand: Area2D = $stand

func set_direction(direction: Vector2i) -> void:
	floors.set_direction(direction)
