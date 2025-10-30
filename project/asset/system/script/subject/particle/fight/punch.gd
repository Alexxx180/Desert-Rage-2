extends Sprite2D

enum { OFFSET = 55, PATH = 50 }

const TIME: float = 0.4

var rotate: Dictionary = {
	Vector2i(1, 0): 90, Vector2i(-1, 0): -90, 
	Vector2i(0, -1): 0, Vector2i(0, 1): 180,
	Vector2i(1, -1): 45, Vector2i(-1, -1): -45,
	Vector2i(1, 1): 135, Vector2i(-1, 1): -135
}

func set_direction(pos: Vector2, direction: Vector2) -> void:
	position = pos
	var off: int = randi_range(5, OFFSET)
	# if direction == Vector2.ZERO: direction.y = 1
	var angle: float = rotate[Vector2i(roundi(direction.x), roundi(direction.y))] 
	rotation = angle
	var rot: Vector2 = direction.rotated(angle)
	print("ROT: ", rot)
	position += Vector2(off, off) * rot
	modulate = Color.from_rgba8(127, 127, 127, 127)
	set_track(position + Vector2(PATH, PATH) * direction)

func set_track(target: Vector2) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", target, TIME)
	tween.tween_property(self, "modulate", Color.TRANSPARENT, TIME)
	tween.tween_callback(queue_free)
