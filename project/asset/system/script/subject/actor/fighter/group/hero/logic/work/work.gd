extends Node

@onready var input: Node = $input
@onready var world: Node = $world
@onready var stats: Node = $stats

@onready var freeze_input: Dictionary = {
	true: func() -> void:
		input.topdown.move.act.run.reset_run() # input.movement.behavior.move.reset()
		Processors.turn(input, false),
	false: func() -> void:
		Processors.turn(input, true)
}
