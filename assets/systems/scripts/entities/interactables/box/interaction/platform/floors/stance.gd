extends Node

var view: Sprite2D
var seat: Node

func set_control_entity(box: Node2D) -> void:
	view = box.view
	seat = box.interaction.seat

func _at_floor(hero: CharacterBody2D) -> bool:
	return hero.processing.platforming.jump.feet.stable

func _should_stand_at(hero: CharacterBody2D) -> void:
	if not (seat.has_hero or _at_floor(hero)):
		seat.hero = hero
		hero.stand.image = view.texture
		view.visible = false

func _disable_stand(hero: CharacterBody2D) -> void:
	if seat.has_hero and hero == seat.hero:
		seat.has_hero = false
		view.visible = true
		if _at_floor(hero): hero.stand.visible = false
