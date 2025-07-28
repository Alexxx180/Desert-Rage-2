extends Node

func controls(seat: Node) -> void:
	seat.place.standing.connect(_on_stand)
	seat.place.leaving.connect(_on_leave)

func _height(hero: CharacterBody2D) -> Callable:
	var input: Node = hero.logic.processors.ui.input
	return input.platforming.jump.feet.floors.set_box_floor

func _on_stand(seat: Node, hero: CharacterBody2D) -> void:
	print("connected ride")
	seat.climb.connect(_height(hero))
	seat.hero_climb()
	seat.move.connect(hero.logic.processors.ui.input.movement.type.move.teleport)

func _on_leave(seat: Node, hero: CharacterBody2D) -> void:
	print("disconnected ride")
	seat.climb.disconnect(_height(hero))
	seat.move.disconnect(hero.logic.processors.ui.input.movement.mode.type.teleport)
