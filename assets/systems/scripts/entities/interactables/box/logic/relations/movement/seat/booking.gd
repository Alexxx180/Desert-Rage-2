extends Node

func set_control(seat: Node) -> void:
	seat.stand.connect(_on_stand)
	seat.leave.connect(_on_leave)

func _height(hero: CharacterBody2D) -> Node:
	var input: Node = hero.logic.processors.input
	return input.platforming.jump.overview.height

func _on_stand(seat: Node, hero: CharacterBody2D) -> void:
	seat.climb.connect(_height(hero).set_floor)
	seat.move.connect(hero.teleport)

func _on_leave(seat: Node, hero: CharacterBody2D) -> void:
	seat.climb.disconnect(_height(hero).set_floor)
	seat.move.disconnect(hero.teleport)

"""
	signal move(target: Vector2)
	signal on_floor_changed(F: int)
	signal update_view(hero: Sprite2D, status: bool)
"""
