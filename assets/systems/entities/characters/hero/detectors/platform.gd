extends Node2D

func set_control_entity(hero: CharacterBody2D) -> void:
	$floor/position.hero = hero
	$ledge/platforming.set_control_entity(hero)
