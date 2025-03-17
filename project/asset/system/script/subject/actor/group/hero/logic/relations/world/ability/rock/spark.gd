extends Node

func detection(detector: Node2D, near: Callable, far: Callable) -> void:
	detector.body_entered.connect(near)
	detector.body_exited.connect(far)

func controls(hero: CharacterBody2D, spark: Node, puddle: Node) -> void:
	var detector: Node2D = hero.logic.detectors.world.ability.spark
	detection(detector.puddle, spark.near_map, spark.far_map)
	detection(detector.battery, spark.near_box, spark.far_box)
	spark.activate.connect(puddle.activate)
	spark.hero = hero
