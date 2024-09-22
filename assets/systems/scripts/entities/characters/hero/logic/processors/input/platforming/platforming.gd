extends Node

@onready var jump: Node = $jump
@onready var input: Node = $input

func _ready() -> void:
	input.overview = jump.overview
