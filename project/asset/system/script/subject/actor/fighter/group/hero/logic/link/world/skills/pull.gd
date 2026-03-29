extends Node

var _hero: CharacterBody2D
var _skills: Node

func controls(hero: CharacterBody2D, skills: Node) -> void:
	_hero = hero ; _skills = skills
	var detector: Node2D = hero.logic.see.world.skills.pull
	detector.box.body_entered.connect(start_forward)
	detector.box.body_exited.connect(stop_forward)
