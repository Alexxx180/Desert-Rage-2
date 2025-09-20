extends MarginContainer

@onready var count: VBoxContainer = $selection/count
@onready var view: Control = $view

func remove_item() -> void:
	view.remove_item()

func _show_text(caption: Label, next: String) -> void:
	caption.text = next
	caption.show()

func replace_item(next: Dictionary, prev: Dictionary) -> void:
	put_item(next)
	put_item(prev)

func put_item(slot: Dictionary) -> void:
	var item: Dictionary = HeroInventory.get_items_bank()[slot.id]
	view.put_item(item.icon)
	count.set_value(slot.x)
