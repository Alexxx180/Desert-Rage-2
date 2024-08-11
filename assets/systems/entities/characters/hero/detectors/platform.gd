extends Node2D

@onready var ledge: Area2D = $ledge
@onready var floor: Area2D = $floor

func set_control_entity(hero: CharacterBody2D) -> void:
	floor.stance.hero = hero
	ledge.platforming.set_control_entity(hero)
