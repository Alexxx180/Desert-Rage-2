extends Node

@onready var platforming: Node = $platforming
@onready var movement: Node = $movement

func _ready() -> void:
	var input: Node = $input
	platforming.input = input
	movement.input = input

func set_control_entity(hero: CharacterBody2D) -> void:
	movement.set_control_entity(hero)
	platforming.hero = hero
