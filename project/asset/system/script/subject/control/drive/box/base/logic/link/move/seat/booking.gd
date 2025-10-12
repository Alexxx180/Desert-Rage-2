extends Node

func controls(seat: Node) -> void:
	seat.place.standing.connect(_on_stand)
	seat.place.leaving.connect(_on_leave)

func _on_stand(box: CharacterBody2D, hero: CharacterBody2D) -> void:
	print("connected climb")
	hero.to.jump.feet.floors.entity = box
	box.logic.work.move.seat.move.connect(hero.make_position)

func _on_leave(box: CharacterBody2D, hero: CharacterBody2D) -> void:
	print("disconnected climb")
	hero.to.jump.feet.floors.entity = Defaults.ENTITY
	box.logic.work.move.seat.move.disconnect(hero.make_position)
