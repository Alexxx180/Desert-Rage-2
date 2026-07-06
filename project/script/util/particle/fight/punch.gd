extends Sprite2D

enum { PUNCH, APPEAR = 0, KICK, TIME = 1, FIRE, DISAPPEAR = 2, DROP, OFFSET = 10, PATH = 100 }

const timing: PackedFloat32Array = [0.2, 0.4, 0.6]

func set_direction(pos: Vector2, direction: Vector2, type: int) -> void:
	match type:
		KICK: texture = preload("res://icon/vfx/kick.png")
		PUNCH: texture = preload("res://icon/vfx/punch.png")
		FIRE: texture = preload("res://icon/vfx/ray/fire.svg")
		DROP: texture = preload("res://icon/vfx/rock/water.svg")
	position = pos - Vector2(0, 32)
	var offsets: Vector2 = Vector2(OFFSET, OFFSET)
	var angle: float = Def.rotate(direction)
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
	tween.tween_property(self, "modulate", Color.from_rgba8(127, 127, 127, 200), timing[APPEAR])
	tween.parallel().tween_property(self, "position", target, timing[TIME])
	tween.tween_property(self, "modulate", Color.TRANSPARENT, timing[APPEAR])
	tween.tween_callback(queue_free)
