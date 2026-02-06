extends Node

enum { OFF, ON }

var toggles: Node

# func set_value(next: int)
# var ui: Dictionary = defaults()
# func defaults() -> Dictionary: return { "aura": ON, "resource": ON }

func decide() -> void:
	pass

func set_aura(section: int, ui: Control) -> void:
	"""
	match value:
		OFF: pass
		ON: pass
	"""
