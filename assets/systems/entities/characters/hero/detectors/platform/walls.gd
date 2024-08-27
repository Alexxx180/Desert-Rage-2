extends Area2D

var platforming: Node
var movement: Node
var decisions: Node

func set_control_entity(hero: CharacterBody2D):
	var pcs = hero.processing
	decisions = pcs.decisions
	platforming = pcs.platorming
	movement = pcs.movement

func on_ledge_encounter(_surface: TileMap):
	platforming.process_mode = decisions.will
	platforming.perform_jump(movement.previous)
	platforming.process_mode = decisions.decide(platforming.jump.feet.unstable)
