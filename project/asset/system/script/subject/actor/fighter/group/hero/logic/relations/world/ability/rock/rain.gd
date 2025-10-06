extends Node

func detection(detector: Node2D, near: Callable, far: Callable) -> void:
	detector.body_entered.connect(near)
	detector.body_exited.connect(far)

func controls(hero: CharacterBody2D, rain: Node, puddle: Node) -> void:
	var detector: Node2D = hero.logic.see.world.ability.rain

	rain.aura = hero.logic.work.stats.aura
	detection(detector.fire, rain.near_box, rain.far_box)
	detector.puddle.body_entered.connect(rain.near_map)
	rain.activate.connect(puddle.activate)
	rain.hero = hero
