extends Node

func get_rain(hero: CharacterBody2D) -> Node2D:
	return hero.logic.detectors.world.ability.rain

func set_puddle(hero: CharacterBody2D, rain: Node) -> void:
	var detector: Node2D = get_rain(hero).puddle
	detector.body_entered.connect(rain.watering)
	detector.body_exited.connect(rain.release)
	
func set_torch(hero: CharacterBody2D, rain: Node) -> void:
	var detector: Node2D = get_rain(hero).fire
	detector.body_entered.connect(rain.start_freeze)
	detector.body_exited.connect(rain.stop_freeze)

func controls(hero: CharacterBody2D, rain: Node, puddle: Node) -> void:
	set_puddle(hero, rain)
	set_torch(hero, rain)
	rain.activate.connect(puddle.activate)
	rain.hero = hero
