extends TextureProgressBar

@onready var image: Dictionary = {
	Vector2(0, -1): preload("res://asset/resource/media/image/actors/aura/aura-mask/forward.png"),
	Vector2(0, 1): preload("res://asset/resource/media/image/actors/aura/aura-mask/backward.png"),
	Vector2(-1, 0): preload("res://asset/resource/media/image/actors/aura/aura-mask/left.png"),
	Vector2(1, 0): preload("res://asset/resource/media/image/actors/aura/aura-mask/right.png")
}

func set_direction(motion: Vector2) -> void:
	if image.has(motion):
		texture_progress = image[motion]
