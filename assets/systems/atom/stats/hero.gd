extends Node

@onready var size = $size
@onready var speed = $speed
@onready var push = $push

func set_control_entity(hero: CharacterBody2D):
	size.set_control_entity(hero)
