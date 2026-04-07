extends Node2D

@onready var skills: Node2D = $skills
@onready var ability: Node2D = $ability
@onready var unique: Area2D = $unique
@onready var trigger: RayCast2D = $trigger

func set_direction(direction: Vector2i) -> void:
	trigger.target_position = Defaults.DIRECTION * direction
	skills.set_direction(direction)
	ability.set_direction(direction)
	unique.set_direction(direction)
