extends RefCounted

class_name HeroSignalsDirecting

static func direct(hero: CharacterBody2D) -> Array[Callable]:
	var environment: Node = hero.logic.processors.environment
	var tracking: Callable = environment.surface.tracking.set_direction
	var push: Callable = environment.interaction.push.set_direction

	var platforms: Node = hero.logic.detectors.platforming.platforms
	var jump: Node = hero.logic.processors.input.platforming.jump

	return [hero.set_direction, tracking, push,
		platforms.surface.deployment.search, jump.overview.redirect]
