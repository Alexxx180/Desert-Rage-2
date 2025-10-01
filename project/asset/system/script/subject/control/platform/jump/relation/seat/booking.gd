extends Node

func controls(seat: Node) -> void:
	seat.place.standing.connect(_on_stand)
	seat.place.leaving.connect(_on_leave)

func _height(hero: CharacterBody2D) -> Node:
	var input: Node = hero.logic.processors.ui.input
	return input.platforming.jump.feet.floors

func _on_stand(seat: Node, hero: CharacterBody2D) -> void:
	print("connected ride")
	var floors: Node = _height(hero)
	floors.entity = seat.entity
	seat.move.connect(hero.make_position)

func _on_leave(seat: Node, hero: CharacterBody2D) -> void:
	print("disconnected ride")
	var floors: Node = _height(hero)
	floors.entity = Defaults.ENTITY
	seat.move.disconnect(hero.make_position)
