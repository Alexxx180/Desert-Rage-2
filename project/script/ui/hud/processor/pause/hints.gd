extends Node

#@onready var short: Node = $shortcut

var transit_info: Callable

func feedback() -> void: transit_info.call()
