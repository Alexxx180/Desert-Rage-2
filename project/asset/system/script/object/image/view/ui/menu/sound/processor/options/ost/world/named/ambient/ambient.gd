extends Node

@onready var typed: Node = $typed
@onready var named: Node = $named

func set_ost(options: Node) -> void:
	var events: Array[String] = ["town", "scene"]
	typed.set_ost(events, options)
	named.set_ost(events, options)
