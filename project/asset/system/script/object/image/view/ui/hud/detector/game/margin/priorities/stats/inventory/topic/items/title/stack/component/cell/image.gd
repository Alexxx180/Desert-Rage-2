extends TextureRect

const ICONS: String = "res://asset/resource/media/image/inventory/"

func put_item(icon: String) -> void:
	texture = ImageTexture.create_from_image(Image.load_from_file(ICONS + icon))

func remove_item() -> void: texture = null
