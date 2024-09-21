extends Node

@onready var jump: Node = $jump
@onready var input: Node = $input

func _ready() -> void:
	jump.disable.connect(_disable_input)
	input.overview = jump.overview

func _disable_input() -> void:
	Processors.disable(input)
