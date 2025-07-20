extends Node2D

@onready var close: Area2D = $close
@onready var zone: Area2D = $zone

@onready var hitbox: StaticBody2D = $hitbox

func set_direction(direction: Vector2i) -> void:
	close.set_direction(direction)
