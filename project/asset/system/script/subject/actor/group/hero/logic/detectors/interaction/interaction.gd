extends Node2D

@onready var skills: Node2D = $skills
@onready var ability: Node2D = $ability

func set_direction(direction: Vector2i) -> void:
	skills.set_direction(direction)
	ability.set_direction(direction)
