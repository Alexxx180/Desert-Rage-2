extends PanelContainer

class_name InventoryItem

@onready var icon: Label = $icon
@onready var count: MarginContainer = $count
@onready var image: TextureRect = $image

func remove_item() -> void:
	for ui in [icon, image, count]: ui.hide()

func _show_text(caption: Label, next: String) -> void:
	caption.text = next
	caption.show()

func replace_item(next: Dictionary, prev: Dictionary) -> void:
	put_item(next)
	put_item(prev)

func put_item(slot: Dictionary) -> void:
	var item: Dictionary = HeroInventory.get_items_bank()[slot.id]
	if item.icon.contains("/"):
		image.texture = ImageTexture.create_from_image(Image.load_from_file(image.icon))
		image.show()
	else:
		_show_text(icon, item.icon)
	count.set_value(slot.x)
