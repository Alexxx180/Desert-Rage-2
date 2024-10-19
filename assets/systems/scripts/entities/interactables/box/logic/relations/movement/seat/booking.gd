extends Node

func set_control(seat: Node) -> void:
	seat.place.standing.connect(_on_stand)
	seat.place.leaving.connect(_on_leave)

func _height(hero: CharacterBody2D) -> Node:
	var input: Node = hero.logic.processors.input
	return input.platforming.jump.overview.height

func _on_stand(seat: Node, hero: CharacterBody2D) -> void:
	seat.climb.connect(_height(hero).set_box_floor)
	seat.move.connect(hero.teleport)
	seat.hero_climb()

func _on_leave(seat: Node, hero: CharacterBody2D) -> void:
	seat.climb.disconnect(_height(hero).set_box_floor)
	seat.move.disconnect(hero.teleport)
