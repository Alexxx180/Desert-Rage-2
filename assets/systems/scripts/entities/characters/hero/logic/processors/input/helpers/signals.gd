extends RefCounted

class_name HeroSignals

static func apply(hero: CharacterBody2D) -> void:
	var platforming: Node2D = hero.logic.detectors.platforming
	var processors: Node = hero.logic.processors

	HeroSignalsArea.apply(platforming, processors)
	HeroSignalsDeployment.apply(platforming.platforms.surface, processors)
	HeroSignalsJump.apply(hero)

static func set_directing(input: Node, hero: CharacterBody2D) -> void:
	var surface: Node = hero.logic.processors.environment.surface
	var overview: Node = input.platfoming.jump.overview

	var events: Array[Callable] = [hero.set_direction,
		surface.tracking.set_direction, overview.redirect]

	for event in events: input.directing.connect(event)
