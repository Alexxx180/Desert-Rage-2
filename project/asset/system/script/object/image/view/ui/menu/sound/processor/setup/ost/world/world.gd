extends Node

@onready var typed: Node = $typed
@onready var named: Node = $named
@onready var weak: Node = $weak

func setup(options: Node) -> void:
	typed.setup(options)
	named.setup(options)
	weak.setup(options)
