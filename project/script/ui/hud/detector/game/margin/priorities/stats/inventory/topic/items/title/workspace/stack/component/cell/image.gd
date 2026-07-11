extends TextureRect

@onready var image: TextureRect = $image

func put_item(icon: String) -> void:
	var path: String = ICONS + icon
	texture = ImageTexture.create_from_image(Image.load_from_file(path))

func hides() -> void:
	image.remove_item()
	hide()

@onready var a: PanelContainer = $a
@onready var b: PanelContainer = $b

# func hides() -> void: for i in [a, b]: i.hides()
func shows() -> void: for i in [a, b]: i.show()

const ICONS: String = "res://asset/resource/media/image/inventory/"

func remove_item() -> void: texture = null
