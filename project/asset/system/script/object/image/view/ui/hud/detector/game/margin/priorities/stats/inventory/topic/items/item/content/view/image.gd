extends TextureRect

const PREVIEW_SIZE: Vector2 = Vector2(30, 30)

func get_preview_texture() -> TextureRect:
	var preview: TextureRect = TextureRect.new()
	preview.texture = texture
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.size = PREVIEW_SIZE
	return preview
