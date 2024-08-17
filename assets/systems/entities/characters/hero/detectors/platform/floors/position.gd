extends Node

var from_floor: bool
var hero: CharacterBody2D
var movement: ProcessMode:
	get:
		return hero.processing.movement.process_mode

func _should_stand_at(surface: Node2D) -> void:
	if "surface" in surface:
		surface.box.interaction.seat.hero = hero
		if movement == hero.wont:
			surface.box.set_stand(hero)
			surface.box.switch_stand(hero, true)
	else:
		from_floor = true
		if (hero.detectors.platform.ledge.platforming.ledges.size >= 1):
			hero.processing.platforming.process_mode = hero.will

func _disable_stand(surface: Node2D) -> void:
	if "surface" in surface:
		#if movement == hero.will:
		surface.box.interaction.seat.has_hero = false
		surface.box.switch_stand(hero, false)
	else:
		from_floor = false
		if (hero.detectors.platform.ledge.platforming.ledges.size == 0):
			hero.processing.platforming.process_mode = hero.wont
