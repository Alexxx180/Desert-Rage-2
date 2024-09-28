extends Node

@onready var logic: Node = $logic
@onready var movement: Node = $movement

func set_control(hero: CharacterBody2D, input: Node) -> void:
	movement.set_control(input, hero)
	logic.set_control(input, hero.logic)
