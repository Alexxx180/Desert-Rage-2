extends Node

@onready var jump: Node = $jump

var _input: Node

func set_control(hero: CharacterBody2D, processors: Node) -> void:
	var _jump: Node = processors.platforming.jump
	_input = processors.platforming.input
	processors.input.directing.connect(_input.hero.set_direction)

	jump.set_control(hero, jump)
	_jump.disable.connect(_disable_input)

func _disable_input() -> void:
	Processors.disable(_input)
