extends Node

var _pull: Node
var _detector: Node2D

func controls(hero: CharacterBody2D, pull: Node) -> void:
	_detector = hero.logic.detectors.world.skills.pull
	_pull = pull

	_detector.box.body_entered.connect(pull.start_forward)
	_detector.box.body_exited.connect(pull.stop_forward)
	pull.hero = hero
