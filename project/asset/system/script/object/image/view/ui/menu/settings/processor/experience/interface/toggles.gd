extends Node

enum { SCREEN = 1, ON }

var settings: int

func _set_value(next: int) -> void: settings = next

func decide(section: int) -> void:
	_set_value(settings ^ section)
