extends Node

@onready var topdown: Node = $topdown
@onready var platformer: Node = $platformer

func controls(hero: CharacterBody2D, input: Node) -> void:
	topdown.controls(hero, input.topdown)
	# TODO FIXME platformer connect
	# platformer.controls(hero, input.platformer.tools)
