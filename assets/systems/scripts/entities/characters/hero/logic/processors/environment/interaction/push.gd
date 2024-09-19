extends Node

var impulse: int = 0
var direction: Vector2i = Vector2i.ZERO

func _set_impulse(next: int) -> void:
	impulse = next

func set_direction(next: Vector2i) -> void:
	direction = next

func push_forward(box: StaticBody2D) -> void:
	box.push(direction * impulse)

func set_control_entity(hero: CharacterBody2D) -> void:
	hero.logic.stats.impulse.connect(_set_impulse)
