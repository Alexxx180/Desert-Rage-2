extends Node

func controls(seat: Node) -> void:
	seat.place.standing.connect(_on_stand)
	seat.place.leaving.connect(_on_leave)

func _height(hero: CharacterBody2D) -> Node:
	return hero.to.jump.feet.floors

func _on_stand(platform: CharacterBody2D, hero: CharacterBody2D) -> void:
	print("connected ride")
	hero.to.jump.feet.floors.entity = platform
	platform.logic.work.seat.move.connect(hero.make_position)

func _on_leave(platform: CharacterBody2D, hero: CharacterBody2D) -> void:
	print("disconnected ride")
	hero.to.jump.feet.floors.entity = Defaults.ENTITY
	platform.logic.work.seat.move.disconnect(hero.make_position)
