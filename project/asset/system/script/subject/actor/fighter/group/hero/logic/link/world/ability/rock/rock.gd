extends Node

func controls(hero: CharacterBody2D, ability: Node, behavior: Node) -> void:
	controls_rain(hero, ability.rain, behavior.puddle.rain)
	controls_spark(hero, ability.spark, behavior.puddle.spark)

func detection(detector: Node2D, near: Callable, far: Callable) -> void:
	detector.body_entered.connect(near)
	detector.body_exited.connect(far)

func controls_spark(hero: CharacterBody2D, spark: Node, puddle: Node) -> void:
	var detector: Node2D = hero.logic.see.world.ability.spark
	
	spark.aura = hero.logic.work.stats.aura
	detection(detector.puddle, spark.near_map, spark.far_map)
	detection(detector.battery, spark.near_box, spark.far_box)
	spark.activate.connect(puddle.activate)
	spark.hero = hero

func controls_rain(hero: CharacterBody2D, rain: Node, puddle: Node) -> void:
	var detector: Node2D = hero.logic.see.world.ability.rain

	rain.aura = hero.logic.work.stats.aura
	detection(detector.fire, rain.near_box, rain.far_box)
	detector.puddle.body_entered.connect(rain.near_map)
	rain.activate.connect(puddle.activate)
	rain.hero = hero
