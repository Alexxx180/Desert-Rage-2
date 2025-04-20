extends Node

class_name AmbientOST

@onready var typed: Node = $typed
@onready var named: Node = $named

static func get_ambient() -> Array[String]:
	return ["ambient", "heating", "rampage"]

static func get_level_types() -> Array[String]:
	return ["caves"]

static func get_level_names() -> Dictionary:
	return {
		"caves": ["origin", "smoke", "sparkling", "ghost"]
	}

func setup(options: Node) -> void:
	typed.set_ost(options)
	named.set_ost(options)
