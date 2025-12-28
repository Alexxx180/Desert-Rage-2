extends PanelContainer

@onready var image: TextureRect = $image

func put_item(icon: String) -> void:
	image.put_item(icon)

func hides() -> void: image.remove_item()
