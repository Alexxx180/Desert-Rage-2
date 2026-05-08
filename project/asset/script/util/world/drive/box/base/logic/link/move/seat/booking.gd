extends Node

@onready var _hero: CharacterBody2D = HUD.ENTITY

func controls(seat: Node) -> void:
	seat.place.standing.connect(_on_stand)
	seat.place.leaving.connect(_on_leave)

func set_pos(pos: Vector2) -> void:
	if _hero != HUD.ENTITY and not _hero.to.topdown.levels.jump.jumped:
		print("override hero pos: ", pos)
		_hero.make_position(pos)

func _on_stand(box: CharacterBody2D, hero: CharacterBody2D) -> void:
	print("connected climb")
	_hero = hero
	hero.to.jump.feet.floors.entity = box
	box.logic.work.move.seat.move.connect(set_pos)

func _on_leave(box: CharacterBody2D, hero: CharacterBody2D) -> void:
	print("disconnected climb")
	_hero = HUD.ENTITY
	hero.to.jump.feet.floors.entity = HUD.ENTITY
	box.logic.work.move.seat.move.disconnect(set_pos)
