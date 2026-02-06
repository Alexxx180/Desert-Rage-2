extends Node

enum { OFF, ON }

var toggles: Node

# func set_value(next: int)
# var ui: Dictionary = defaults()
# func defaults() -> Dictionary: return { "aura": ON, "resource": ON }

func decide() -> void:
	

func set_aura(section: int, ui: Control) -> void:
	match value:
		OFF: pass
		ON: pass

func decide(map: int, type: Array[PackedScene]) -> Array[int]:
	var monsters: Array[int] = []
	for i in range(0, type.size()):
		var bit: int = 2 ** i
		if bit & map == bit: monsters.append(i)
