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
	platforming.process_mode = Processors.will
	platforming.jump.perform_jump(input.previous)
	Processors.turn(platforming, platforming.jump.feet.unstable)
