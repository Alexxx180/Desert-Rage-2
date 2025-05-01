extends Node

@onready var short: Node = $shortcut

var transit_settings: Callable

func feedback() -> void: transit_settings.call()
