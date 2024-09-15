extends Node2D

@onready var interaction = $interaction
@onready var platform = $platform

func set_control_entity(hero: CharacterBody2D):
	interaction.hero = hero
	platform.set_control_entity(hero)
