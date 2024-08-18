extends Area2D

@onready var distance: Node2D = $distance
@onready var ledges: Node = $ledges

func set_control_entity(hero: CharacterBody2D) -> void:
	ledges.set_control_entity(hero)
	distance.set_control_entity(hero)
