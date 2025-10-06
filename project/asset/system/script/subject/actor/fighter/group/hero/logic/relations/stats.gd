extends Node

func controls(hero: CharacterBody2D, stats: Node) -> void:
	hero.logic.see.fight.hitbox.bash.connect(stats.health.hit)
	stats.health.aura.entity = hero
	stats.aura.bar = hero.view.ap

	stats.health.points.setup(hero.logic.stats.health)
	stats.aura.setup(hero.logic.stats.aura)
