extends Node

signal stand(seat: Node, hero: CharacterBody2D)
signal leave(seat: Node, hero: CharacterBody2D)
signal move(target: Vector2)
signal climb(F: int)
signal update_view(hero: Sprite2D, status: bool)

@export_range(1, 2) var height: int = 1

const OFFSET: Vector2 = Vector2(0, 32)

var _id: int = 0

func move(target: Vector2) -> void:
	move.emit(target + OFFSET)

func set_floor(F: int) -> void:
	climb.emit(F + height)

func set_stand(hero:CharacterBody2D, id: int) -> void:
	update_view.emit(hero.view.stand, status)
	_id = id

func _same(hero: CharacterBody2D) -> bool:
	return _id == hero.get_instance_id()

func enable_stand(hero: CharacterBody2D) -> void:
	if id == 0 and _higher(hero):
		set_stand(hero, hero.get_instance_id())
		stand.emit(self, hero) # if _at_floor(hero): hero.stand.visible = false

func disable_stand(hero: CharacterBody2D) -> void:
	if id != 0 and _same(hero):
		set_stand(hero, 0)
		leave.emit(self, hero)

func _higher(hero: CharacterBody2D) -> bool:
	return hero.logic.processors.platforming.jump.feet.unstable
