extends StaticBody2D

@onready var ground = $ground
@onready var surface = $surface

var size: Node

var F: int:
	get:
		return surface.F

var pos: Vector2:
	get:
		return Vector2(size.basis.x, size.basis.y + position.y)

func _ready() -> void:
	surface.ground = ground

func set_control_entity(box: Node2D) -> void:
	size = box.stats.size

func grab(hero):
	hero.position = pos
