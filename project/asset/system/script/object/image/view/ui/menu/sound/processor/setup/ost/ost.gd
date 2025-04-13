extends Node

@onready var level: Node = $level
@onready var world: Node = $world

func setup(options: Node) -> void:
	level.setup(options)
	world.setup(options)
