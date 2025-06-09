extends Node

@onready var input: Node = $input
@onready var world: Node = $world
@onready var hud: Node = $hud

@onready var freeze_input: Dictionary = {
	true: func() -> void:
		input.movement.face.reset()
		Processors.turn(input, false),
	false: func() -> void:
		Processors.turn(input, true)
}
