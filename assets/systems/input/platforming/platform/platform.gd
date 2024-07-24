extends Area2D

@export_range(0, 9) var F: int = 0
@export_range(1, 2) var height: int = 1

@onready var directions: Node2D = $directions

func compare(ledge_floor: int) -> bool:
	return F + height == ledge_floor

func _on_step(body: Node2D):
	if body is CharacterBody2D:
		directions.jump_to_ledge(body)
