extends Node

@onready var typed: Node = $typed
@onready var named: Node = $named
@onready var weak: Node = $weak

func setup(options: Node) -> void:
	typed.set_ost(options)
	named.set_ost(options)
	weak.set_ost(options)
