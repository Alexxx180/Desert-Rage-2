extends Sprite2D

enum { OFFSET = 10, PATH = 100 }

const APPEAR: float = 0.2
const TIME: float = 0.4
const DISAPPEAR: float = 0.6

var rotate: Dictionary = {
	Vector2i(1, 0): 90, Vector2i(-1, 0): -90, 
	Vector2i(0, -1): 0, Vector2i(0, 1): 135,
	Vector2i(1, -1): 45, Vector2i(-1, -1): -45,
	Vector2i(1, 1): 135, Vector2i(-1, 1): -135
}

func set_direction(pos: Vector2, direction: Vector2) -> void:
	position = pos - Vector2(0, 32)
	var offsets: Vector2 = Vector2(OFFSET, OFFSET)
	var angle: float = rotate[Vector2i(roundi(direction.x), roundi(direction.y))] 
	rotation = angle
	var delta: Vector2 = Vector2(PATH, PATH) * direction
	if direction.x != 0 and direction.y != 0:
		var axis: int = randi_range(0, 2)
		if axis != 2:
			direction[axis] *= -1
			position += offsets * direction
		delta *= 0.75
	elif direction.x != 0:
		var track: int = randi_range(-1, 1)
		if track != 0:
			direction.y = track
			position += offsets * direction * 2
	elif direction.y != 0:
		var track: int = randi_range(-1, 1)
		if track != 0:
			direction.x = track
			position += offsets * direction * 2
		
	modulate = Color.TRANSPARENT
	#modulate = Color.from_rgba8(127, 127, 127, 127)
	set_track(position + delta)

func set_track(target: Vector2) -> void:
	var tween: Tween = create_tween()# .set_parallel(true)
	tween.tween_property(self, "modulate", Color.from_rgba8(127, 127, 127, 200), APPEAR)
	tween.parallel().tween_property(self, "position", target, TIME)
	tween.tween_property(self, "modulate", Color.TRANSPARENT, APPEAR)
	tween.tween_callback(queue_free)
