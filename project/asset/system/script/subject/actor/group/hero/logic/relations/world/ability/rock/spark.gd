extends Node

func get_rain(hero: CharacterBody2D) -> Node2D:
	return hero.logic.detectors.world.ability.spark

func set_puddle(hero: CharacterBody2D, spark: Node) -> void:
	var detector: Node2D = get_rain(hero).puddle
	detector.body_entered.connect(spark.map_near)
	detector.body_exited.connect(spark.map_far)
	
func set_torch(hero: CharacterBody2D, spark: Node) -> void:
	var detector: Node2D = get_rain(hero).battery
	detector.body_entered.connect(spark.box_near)
	detector.body_exited.connect(spark.box_far)

func controls(hero: CharacterBody2D, spark: Node, puddle: Node) -> void:
	set_puddle(hero, spark)
	set_torch(hero, spark)
	spark.activate.connect(puddle.activate)
	spark.hero = hero
