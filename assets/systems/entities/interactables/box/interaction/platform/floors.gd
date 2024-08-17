extends Area2D

const OFFSET: int = -45

var box: Node2D
@onready var ground = $ground
@onready var surface = $surface

var size: Node

var F: int:
	get:
		return surface.F

var pos: Vector2:
	get:
		return box.stats.size.basis + Vector2(0, OFFSET)

func _ready() -> void:
	surface.ground = ground

func set_control_entity(entity: Node2D) -> void:
	box = entity
	surface.seat = box.interaction.seat
