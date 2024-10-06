extends Node

@onready var jump: Node = $jump

var _input: Node

func set_control(hero: CharacterBody2D, processors: Node) -> void:
	var input: Node = processors.input
	var platforming: Node = input.platforming
	_input = platforming.input
	input.directing.connect(_input.hero.set_direction)

	jump.set_control(hero, platforming.jump)
	#platforming.jump.feet.balance.disable.connect(_disable_input)

#func _disable_input() -> void:
	#Processors.disable(_input)
