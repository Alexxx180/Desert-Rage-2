extends Area2D

var platforming: Node
var input: Node
var decisions: Node

func set_control_entity(hero: CharacterBody2D):
	var pcs = hero.processing
	decisions = pcs.decisions
	platforming = pcs.platforming
	input = pcs.input

func on_ledge_encounter(_surface: TileMap):
	platforming.process_mode = decisions.will
	print("TO JUMP: ", input.previous)
	platforming.jump.perform_jump(input.previous)
	platforming.process_mode = decisions.decide(platforming.jump.feet.unstable)
