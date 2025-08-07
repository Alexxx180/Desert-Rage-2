extends Node2D

@onready var close: Area2D = $close

@onready var after_tile: Area2D = $after_tile
@onready var straight: Area2D = $straight
@onready var fireplace: Area2D = $fireplace
@onready var circle: Area2D = $circle
@onready var small_circle: Area2D = $small_circle
@onready var sided: Area2D = $sided

@onready var zone: Area2D = $zone

@onready var hitbox: StaticBody2D = $hitbox
@onready var stuck: Node2D = $stuck

func set_direction(direction: Vector2) -> void:
	close.set_direction(direction)
	if direction != Vector2.ZERO:
		after_tile.set_direction(direction)
