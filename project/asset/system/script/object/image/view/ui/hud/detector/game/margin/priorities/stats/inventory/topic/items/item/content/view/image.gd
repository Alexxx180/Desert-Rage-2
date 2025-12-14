extends TextureRect

var holder: Texture2D = null

const PREVIEW_SIZE: Vector2 = Vector2(72, 72)
const ICONS: String = "res://asset/resource/media/image/inventory/"

func get_preview_texture() -> TextureRect:
	var image: TextureRect = TextureRect.new()
	holder = texture
	image.texture = texture
	image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	image.size = PREVIEW_SIZE
	image.position -= PREVIEW_SIZE / 2
	return image

func get_cursor_preview() -> Control:
	var preview: Control = Control.new()
	preview.add_child(get_preview_texture())
	return preview

func put_item(icon: String) -> void:
	texture = ImageTexture.create_from_image(Image.load_from_file(ICONS + icon))

func remove_item() -> void: texture = null

func reset_holder() -> void: holder = null
func reset_texture() -> void:
	if holder != null:
		texture = holder
		reset_holder()
