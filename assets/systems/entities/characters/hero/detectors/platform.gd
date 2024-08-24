extends Node2D

@onready var ledge: Area2D = $ledge
@onready var floors: Area2D = $floors

func set_control_entity(hero: CharacterBody2D) -> void:
	ledge.set_control_entity(hero)
	floors.set_control_entity(hero)
