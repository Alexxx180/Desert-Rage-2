extends Node2D

@onready var close: Area2D = $close
@onready var zone: Area2D = $zone

@onready var hitbox: StaticBody2D = $hitbox
@onready var stuck: Node2D = $stuck

func set_direction(direction: Vector2i) -> void:
	close.set_direction(direction)
