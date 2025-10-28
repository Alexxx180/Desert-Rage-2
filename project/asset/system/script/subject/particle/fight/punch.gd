extends Sprite2D

enum { TIME = 2, OFFSET = 5, PATH = 15 }

var rotate: Dictionary = {
	Vector2i(1, 0): 90, Vector2i(-1, 0): -90, 
	Vector2i(0, 1): 0, Vector2i(0, -1): 180,
	Vector2i(1, -1): 45, Vector2i(-1, -1): -45,
	Vector2i(1, 1): 135, Vector2i(-1, 1): -135
}

func set_direction(direction: Vector2) -> void:
	var pos: int = randi_range(0, OFFSET)
	rotation = rotate[direction]
	position += Vector2(pos, pos) * direction
	set_track(Vector2(PATH, PATH) * direction)

func set_track(target: Vector2) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", target, TIME)
	tween.tween_property(self, "modulate", Color.TRANSPARENT, TIME)
	tween.tween_callback(queue_free)
