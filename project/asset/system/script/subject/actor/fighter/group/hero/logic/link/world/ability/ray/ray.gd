extends Node

@onready var skill: Node = $skill

func controls(hero: CharacterBody2D, ability: Node, behavior: Node) -> void:
	skill.setup(hero, ability)
	connect_fire(hero.logic.see.world.ability.fire)
	
	ability.fire.activate.connect(behavior.freeze.activate)
	ability.whip.pillar = hero.to.topdown.levels.pillar
	#fire.hero = hero # fire.aura = hero.logic.work.stats.aura

func connect_fire(fire: Node2D) -> void:
	for i in ["ice", "torch", "enemy"]:
		detection(fire.get(i), skill.get("fire_" + i), skill.get("fire_far_" + i))

func detection(detector: Node2D, near: Callable, far: Callable) -> void:
	detector.body_entered.connect(near)
	detector.body_exited.connect(far)
