extends Node

signal stand(seat: Node, hero: CharacterBody2D)
signal leave(seat: Node, hero: CharacterBody2D)
signal move(target: Vector2)
signal climb(F: int)

@onready var offset: Node = $offset
@onready var height: Node = $height
@onready var place: Node = $place

func transport(target: Vector2) -> void:
	move.emit(target + offset.value)

func set_floor(F: int) -> void:
	climb.emit(F + height.F)

func enable_stand(hero: CharacterBody2D) -> void:
	if place.empty() and place.is_in_midair(hero):
		place.visit(hero, hero.get_instance_id())
		stand.emit(self, hero)
		# if _at_floor(hero): hero.stand.visible = false

func disable_stand(hero: CharacterBody2D) -> void:
	if place.stand() and place.same(hero):
		place.visit(hero, 0)
		leave.emit(self, hero)
