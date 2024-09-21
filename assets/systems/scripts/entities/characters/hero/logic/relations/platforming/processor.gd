extends Node

@onready var jump: Node = $jump

func set_control(hero: CharacterBody2D, processors: Node) -> void:
	jump.set_control(hero, processors.platforming.jump)
