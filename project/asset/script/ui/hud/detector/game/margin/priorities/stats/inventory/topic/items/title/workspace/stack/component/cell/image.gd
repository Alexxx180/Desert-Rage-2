extends TextureRect

const ICONS: String = "res://asset/resource/media/image/inventory/"

func put_item(icon: String) -> void:
	var path: String = ICONS + icon
	texture = ImageTexture.create_from_image(Image.load_from_file(path))

func remove_item() -> void: texture = null
