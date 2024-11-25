extends Node

@onready var environment: Node = $environment
@onready var input: Node = $input

func controls(hero: CharacterBody2D, processors: Node) -> void:
	environment.controls(hero, processors.environment)
	input.controls(hero, processors.input)
