extends Node

@onready var ui: Node = $ui
@onready var world: Node = $world
@onready var stats: Node = $stats

@onready var freeze_input: Dictionary = {
	true: func() -> void:
		ui.input.movement.face.reset()
		Processors.turn(ui.input, false),
	false: func() -> void:
		Processors.turn(ui.input, true)
}
