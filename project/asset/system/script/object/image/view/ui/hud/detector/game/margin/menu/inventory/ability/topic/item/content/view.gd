extends Control

@onready var icon: Label = $icon
@onready var image: TextureRect = $image

func remove_item() -> void:
	for ui in [icon, image]: ui.hide()

func put_item(value: String) -> void:
	if value.contains("/"):
		# image.icon
		image.texture = ImageTexture.create_from_image(Image.load_from_file(value))
		image.show()
	else:
		icon.text = value
		icon.show()
