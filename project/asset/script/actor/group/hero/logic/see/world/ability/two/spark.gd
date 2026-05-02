extends Node2D

@onready var puddle: Area2D = $puddle
@onready var battery: Area2D = $battery

func set_direction(direction: Vector2i) -> void:
	puddle.set_direction(direction)
	battery.set_direction(direction)
