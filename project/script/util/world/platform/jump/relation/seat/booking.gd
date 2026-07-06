extends Node

@onready var _hero: CharacterBody2D = HUD.ENTITY

func controls(seat: Node) -> void:
	seat.place.standing.connect(_on_stand)
	seat.place.leaving.connect(_on_leave)

func _height(hero: CharacterBody2D) -> Node:
	return hero.to.jump.feet.floors

func set_pos(pos: Vector2) -> void:
	if _hero != HUD.ENTITY and not _hero.to.topdown.levels.jump.jumped:
		print("override hero pos: ", pos)
		_hero.make_position(pos)
#	else:

func _on_stand(platform: CharacterBody2D, hero: CharacterBody2D) -> void:
	print("connected ride")
	_hero = hero
	hero.to.jump.feet.floors.entity = platform
	platform.logic.work.seat.move.connect(set_pos)

func _on_leave(platform: CharacterBody2D, hero: CharacterBody2D) -> void:
	print("disconnected ride")
	hero.to.jump.feet.floors.entity = HUD.ENTITY
	platform.logic.work.seat.move.disconnect(set_pos)
