extends Node

@onready var input: Node = $input
@onready var platforming: Node = $platforming
@onready var movement: Node = $movement

func _ready() -> void:
	platforming.input = input
	movement.input = input

func set_control_entity(hero: CharacterBody2D) -> void:
	movement.set_control_entity(hero)
	platforming.set_control_entity(hero)
