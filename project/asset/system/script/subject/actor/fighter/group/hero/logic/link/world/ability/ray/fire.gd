extends Node

func detection(detector: Node2D, near: Callable, far: Callable) -> void:
	detector.body_entered.connect(near)
	detector.body_exited.connect(far)

func controls(hero: CharacterBody2D, fire: Node, trigger: Node) -> void:
	var detector: Node2D = hero.logic.see.world.ability.fire

	detection(detector.ice, fire.near_map, fire.far_map)
	detection(detector.torch, fire.near_box, fire.far_box) # detector.enemy.body_entered.connect(fire.near_enemy)
	detection(detector.enemy, fire.near_enemy, fire.far_enemy)
	fire.activate.connect(trigger.activate)
	fire.hero = hero
	fire.aura = hero.logic.work.stats.aura
