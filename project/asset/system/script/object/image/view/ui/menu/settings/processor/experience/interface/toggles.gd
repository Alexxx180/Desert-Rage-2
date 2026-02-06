extends Node

enum { LISTEN, REPEAT, PLAYER, GENRE, NARRATIVE, QUOTES, HELP, EMOTIONS,
	SCREEN, AURA, RESOURCE, DAMAGE, ITEMS, ORDER_A, ORDER_X, PRESS }

var settings: int

func _set_value(next: int) -> void: settings = next

func decide(section: int) -> void:
	_set_value(settings ^ section)
