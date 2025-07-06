extends Node

func controls(hero: CharacterBody2D, stats: Node) -> void:
	stats.health.points.setup(hero.logic.stats.health)
	stats.aura.setup(hero.logic.stats.aura)
	hero.logic.detectors.fight.hitbox.hit.connect(stats.health.hit)
	hero.logic.processors.stats.health.aura.entity = hero
	hero.logic.processors.stats.aura.bar = hero.view.ap

	hero.logic.processors.stats.health.points.update_bar.connect(func(v: int):
		hero.get_node("../../hud").game.detector.game.set_hp_value(v))
	hero.logic.processors.stats.aura.update_bar.connect(func(v: int):
		hero.get_node("../../hud").game.detector.game.set_ap_value(v))
