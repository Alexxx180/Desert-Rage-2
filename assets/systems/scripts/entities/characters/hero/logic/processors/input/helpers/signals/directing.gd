extends RefCounted

class_name HeroSignalsDirecting

static func direct(hero: CharacterBody2D) -> Array[Callable]:
	var surface: Node = hero.logic.processors.environment.surface
	var platforms: Node = hero.logic.detectors.platforming.platforms
	var jump: Node = hero.logic.processors.input.platforming.jump

	return [hero.set_direction, surface.tracking.set_direction,
		platforms.surface.deployment.search, jump.overview.redirect]
