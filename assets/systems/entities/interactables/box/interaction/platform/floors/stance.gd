extends Node

var box: Node2D

func _should_stand_at(hero: CharacterBody2D) -> void:
	if box.interaction.seat.has_hero: return
	if not hero.detectors.platform.ledge.platforming.on_floor:
		box.interaction.seat.hero = hero
		box.set_stand(hero)
		box.switch_stand(hero, true)

func _disable_stand(hero: CharacterBody2D) -> void:
	if box.interaction.seat.has_hero and hero != box.interaction.seat.hero:
		return
	box.view.visible = true
	box.interaction.seat.has_hero = false
	if hero.detectors.platform.ledge.platforming.on_floor:
		hero.stand.visible = false
