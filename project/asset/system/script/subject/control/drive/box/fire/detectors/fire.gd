extends Node2D

@onready var detectors: Array[Area2D] = [$a, $b, $c, $d]
"""
@export var distance: Vector2i = Vector2i(32, 20)

func _set_directions(_a: Vector2, _b: Vector2) -> void:
	a.position = _a
	b.position = _b
"""

func set_direction(direction: Vector2i) -> void:
	return
	# if direction == Vector2i.ZERO: return

"""
	var next: Vector2i = direction * distance
	if next.y == 0:
		var y: int = distance.y
		_set_directions(Vector2(next.x, -y), Vector2(next.x, y))
"""
