extends RefCounted

class_name HeroSignals

static func apply(hero: CharacterBody2D) -> void:
	var platforming: Node2D = hero.logic.detectors.platforming
	var processors: Node = hero.logic.processors

	HeroSignalsArea.apply(platforming, processors)
	HeroSignalsDeployment.apply(platforming.platforms.surface, processors)
	HeroSignalsJump.apply(hero)
